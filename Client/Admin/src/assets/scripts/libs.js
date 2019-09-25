"use strict";

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

/**
 * Owl Carousel v2.3.4
 * Copyright 2013-2018 David Deutsch
 * Licensed under: SEE LICENSE IN https://github.com/OwlCarousel2/OwlCarousel2/blob/master/LICENSE
 */

/**
 * Owl carousel
 * @version 2.3.4
 * @author Bartosz Wojciechowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 * @todo Lazy Load Icon
 * @todo prevent animationend bubling
 * @todo itemsScaleUp
 * @todo Test Zepto
 * @todo stagePadding calculate wrong active classes
 */
;

(function ($, window, document, undefined) {
  /**
   * Creates a carousel.
   * @class The Owl Carousel.
   * @public
   * @param {HTMLElement|jQuery} element - The element to create the carousel for.
   * @param {Object} [options] - The options
   */
  function Owl(element, options) {
    /**
     * Current settings for the carousel.
     * @public
     */
    this.settings = null;
    /**
     * Current options set by the caller including defaults.
     * @public
     */

    this.options = $.extend({}, Owl.Defaults, options);
    /**
     * Plugin element.
     * @public
     */

    this.$element = $(element);
    /**
     * Proxied event handlers.
     * @protected
     */

    this._handlers = {};
    /**
     * References to the running plugins of this carousel.
     * @protected
     */

    this._plugins = {};
    /**
     * Currently suppressed events to prevent them from being retriggered.
     * @protected
     */

    this._supress = {};
    /**
     * Absolute current position.
     * @protected
     */

    this._current = null;
    /**
     * Animation speed in milliseconds.
     * @protected
     */

    this._speed = null;
    /**
     * Coordinates of all items in pixel.
     * @todo The name of this member is missleading.
     * @protected
     */

    this._coordinates = [];
    /**
     * Current breakpoint.
     * @todo Real media queries would be nice.
     * @protected
     */

    this._breakpoint = null;
    /**
     * Current width of the plugin element.
     */

    this._width = null;
    /**
     * All real items.
     * @protected
     */

    this._items = [];
    /**
     * All cloned items.
     * @protected
     */

    this._clones = [];
    /**
     * Merge values of all items.
     * @todo Maybe this could be part of a plugin.
     * @protected
     */

    this._mergers = [];
    /**
     * Widths of all items.
     */

    this._widths = [];
    /**
     * Invalidated parts within the update process.
     * @protected
     */

    this._invalidated = {};
    /**
     * Ordered list of workers for the update process.
     * @protected
     */

    this._pipe = [];
    /**
     * Current state information for the drag operation.
     * @todo #261
     * @protected
     */

    this._drag = {
      time: null,
      target: null,
      pointer: null,
      stage: {
        start: null,
        current: null
      },
      direction: null
    };
    /**
     * Current state information and their tags.
     * @type {Object}
     * @protected
     */

    this._states = {
      current: {},
      tags: {
        'initializing': ['busy'],
        'animating': ['busy'],
        'dragging': ['interacting']
      }
    };
    $.each(['onResize', 'onThrottledResize'], $.proxy(function (i, handler) {
      this._handlers[handler] = $.proxy(this[handler], this);
    }, this));
    $.each(Owl.Plugins, $.proxy(function (key, plugin) {
      this._plugins[key.charAt(0).toLowerCase() + key.slice(1)] = new plugin(this);
    }, this));
    $.each(Owl.Workers, $.proxy(function (priority, worker) {
      this._pipe.push({
        'filter': worker.filter,
        'run': $.proxy(worker.run, this)
      });
    }, this));
    this.setup();
    this.initialize();
  }
  /**
   * Default options for the carousel.
   * @public
   */


  Owl.Defaults = {
    items: 3,
    loop: false,
    center: false,
    rewind: false,
    checkVisibility: true,
    mouseDrag: true,
    touchDrag: true,
    pullDrag: true,
    freeDrag: false,
    margin: 0,
    stagePadding: 0,
    merge: false,
    mergeFit: true,
    autoWidth: false,
    startPosition: 0,
    rtl: false,
    smartSpeed: 250,
    fluidSpeed: false,
    dragEndSpeed: false,
    responsive: {},
    responsiveRefreshRate: 200,
    responsiveBaseElement: window,
    fallbackEasing: 'swing',
    slideTransition: '',
    info: false,
    nestedItemSelector: false,
    itemElement: 'div',
    stageElement: 'div',
    refreshClass: 'owl-refresh',
    loadedClass: 'owl-loaded',
    loadingClass: 'owl-loading',
    rtlClass: 'owl-rtl',
    responsiveClass: 'owl-responsive',
    dragClass: 'owl-drag',
    itemClass: 'owl-item',
    stageClass: 'owl-stage',
    stageOuterClass: 'owl-stage-outer',
    grabClass: 'owl-grab'
  };
  /**
   * Enumeration for width.
   * @public
   * @readonly
   * @enum {String}
   */

  Owl.Width = {
    Default: 'default',
    Inner: 'inner',
    Outer: 'outer'
  };
  /**
   * Enumeration for types.
   * @public
   * @readonly
   * @enum {String}
   */

  Owl.Type = {
    Event: 'event',
    State: 'state'
  };
  /**
   * Contains all registered plugins.
   * @public
   */

  Owl.Plugins = {};
  /**
   * List of workers involved in the update process.
   */

  Owl.Workers = [{
    filter: ['width', 'settings'],
    run: function run() {
      this._width = this.$element.width();
    }
  }, {
    filter: ['width', 'items', 'settings'],
    run: function run(cache) {
      cache.current = this._items && this._items[this.relative(this._current)];
    }
  }, {
    filter: ['items', 'settings'],
    run: function run() {
      this.$stage.children('.cloned').remove();
    }
  }, {
    filter: ['width', 'items', 'settings'],
    run: function run(cache) {
      var margin = this.settings.margin || '',
          grid = !this.settings.autoWidth,
          rtl = this.settings.rtl,
          css = {
        'width': 'auto',
        'margin-left': rtl ? margin : '',
        'margin-right': rtl ? '' : margin
      };
      !grid && this.$stage.children().css(css);
      cache.css = css;
    }
  }, {
    filter: ['width', 'items', 'settings'],
    run: function run(cache) {
      var width = (this.width() / this.settings.items).toFixed(3) - this.settings.margin,
          merge = null,
          iterator = this._items.length,
          grid = !this.settings.autoWidth,
          widths = [];
      cache.items = {
        merge: false,
        width: width
      };

      while (iterator--) {
        merge = this._mergers[iterator];
        merge = this.settings.mergeFit && Math.min(merge, this.settings.items) || merge;
        cache.items.merge = merge > 1 || cache.items.merge;
        widths[iterator] = !grid ? this._items[iterator].width() : width * merge;
      }

      this._widths = widths;
    }
  }, {
    filter: ['items', 'settings'],
    run: function run() {
      var clones = [],
          items = this._items,
          settings = this.settings,
          // TODO: Should be computed from number of min width items in stage
      view = Math.max(settings.items * 2, 4),
          size = Math.ceil(items.length / 2) * 2,
          repeat = settings.loop && items.length ? settings.rewind ? view : Math.max(view, size) : 0,
          append = '',
          prepend = '';
      repeat /= 2;

      while (repeat > 0) {
        // Switch to only using appended clones
        clones.push(this.normalize(clones.length / 2, true));
        append = append + items[clones[clones.length - 1]][0].outerHTML;
        clones.push(this.normalize(items.length - 1 - (clones.length - 1) / 2, true));
        prepend = items[clones[clones.length - 1]][0].outerHTML + prepend;
        repeat -= 1;
      }

      this._clones = clones;
      $(append).addClass('cloned').appendTo(this.$stage);
      $(prepend).addClass('cloned').prependTo(this.$stage);
    }
  }, {
    filter: ['width', 'items', 'settings'],
    run: function run() {
      var rtl = this.settings.rtl ? 1 : -1,
          size = this._clones.length + this._items.length,
          iterator = -1,
          previous = 0,
          current = 0,
          coordinates = [];

      while (++iterator < size) {
        previous = coordinates[iterator - 1] || 0;
        current = this._widths[this.relative(iterator)] + this.settings.margin;
        coordinates.push(previous + current * rtl);
      }

      this._coordinates = coordinates;
    }
  }, {
    filter: ['width', 'items', 'settings'],
    run: function run() {
      var padding = this.settings.stagePadding,
          coordinates = this._coordinates,
          css = {
        'width': Math.ceil(Math.abs(coordinates[coordinates.length - 1])) + padding * 2,
        'padding-left': padding || '',
        'padding-right': padding || ''
      };
      this.$stage.css(css);
    }
  }, {
    filter: ['width', 'items', 'settings'],
    run: function run(cache) {
      var iterator = this._coordinates.length,
          grid = !this.settings.autoWidth,
          items = this.$stage.children();

      if (grid && cache.items.merge) {
        while (iterator--) {
          cache.css.width = this._widths[this.relative(iterator)];
          items.eq(iterator).css(cache.css);
        }
      } else if (grid) {
        cache.css.width = cache.items.width;
        items.css(cache.css);
      }
    }
  }, {
    filter: ['items'],
    run: function run() {
      this._coordinates.length < 1 && this.$stage.removeAttr('style');
    }
  }, {
    filter: ['width', 'items', 'settings'],
    run: function run(cache) {
      cache.current = cache.current ? this.$stage.children().index(cache.current) : 0;
      cache.current = Math.max(this.minimum(), Math.min(this.maximum(), cache.current));
      this.reset(cache.current);
    }
  }, {
    filter: ['position'],
    run: function run() {
      this.animate(this.coordinates(this._current));
    }
  }, {
    filter: ['width', 'position', 'items', 'settings'],
    run: function run() {
      var rtl = this.settings.rtl ? 1 : -1,
          padding = this.settings.stagePadding * 2,
          begin = this.coordinates(this.current()) + padding,
          end = begin + this.width() * rtl,
          inner,
          outer,
          matches = [],
          i,
          n;

      for (i = 0, n = this._coordinates.length; i < n; i++) {
        inner = this._coordinates[i - 1] || 0;
        outer = Math.abs(this._coordinates[i]) + padding * rtl;

        if (this.op(inner, '<=', begin) && this.op(inner, '>', end) || this.op(outer, '<', begin) && this.op(outer, '>', end)) {
          matches.push(i);
        }
      }

      this.$stage.children('.active').removeClass('active');
      this.$stage.children(':eq(' + matches.join('), :eq(') + ')').addClass('active');
      this.$stage.children('.center').removeClass('center');

      if (this.settings.center) {
        this.$stage.children().eq(this.current()).addClass('center');
      }
    }
  }];
  /**
   * Create the stage DOM element
   */

  Owl.prototype.initializeStage = function () {
    this.$stage = this.$element.find('.' + this.settings.stageClass); // if the stage is already in the DOM, grab it and skip stage initialization

    if (this.$stage.length) {
      return;
    }

    this.$element.addClass(this.options.loadingClass); // create stage

    this.$stage = $('<' + this.settings.stageElement + '>', {
      "class": this.settings.stageClass
    }).wrap($('<div/>', {
      "class": this.settings.stageOuterClass
    })); // append stage

    this.$element.append(this.$stage.parent());
  };
  /**
   * Create item DOM elements
   */


  Owl.prototype.initializeItems = function () {
    var $items = this.$element.find('.owl-item'); // if the items are already in the DOM, grab them and skip item initialization

    if ($items.length) {
      this._items = $items.get().map(function (item) {
        return $(item);
      });
      this._mergers = this._items.map(function () {
        return 1;
      });
      this.refresh();
      return;
    } // append content


    this.replace(this.$element.children().not(this.$stage.parent())); // check visibility

    if (this.isVisible()) {
      // update view
      this.refresh();
    } else {
      // invalidate width
      this.invalidate('width');
    }

    this.$element.removeClass(this.options.loadingClass).addClass(this.options.loadedClass);
  };
  /**
   * Initializes the carousel.
   * @protected
   */


  Owl.prototype.initialize = function () {
    this.enter('initializing');
    this.trigger('initialize');
    this.$element.toggleClass(this.settings.rtlClass, this.settings.rtl);

    if (this.settings.autoWidth && !this.is('pre-loading')) {
      var imgs, nestedSelector, width;
      imgs = this.$element.find('img');
      nestedSelector = this.settings.nestedItemSelector ? '.' + this.settings.nestedItemSelector : undefined;
      width = this.$element.children(nestedSelector).width();

      if (imgs.length && width <= 0) {
        this.preloadAutoWidthImages(imgs);
      }
    }

    this.initializeStage();
    this.initializeItems(); // register event handlers

    this.registerEventHandlers();
    this.leave('initializing');
    this.trigger('initialized');
  };
  /**
   * @returns {Boolean} visibility of $element
   *                    if you know the carousel will always be visible you can set `checkVisibility` to `false` to
   *                    prevent the expensive browser layout forced reflow the $element.is(':visible') does
   */


  Owl.prototype.isVisible = function () {
    return this.settings.checkVisibility ? this.$element.is(':visible') : true;
  };
  /**
   * Setups the current settings.
   * @todo Remove responsive classes. Why should adaptive designs be brought into IE8?
   * @todo Support for media queries by using `matchMedia` would be nice.
   * @public
   */


  Owl.prototype.setup = function () {
    var viewport = this.viewport(),
        overwrites = this.options.responsive,
        match = -1,
        settings = null;

    if (!overwrites) {
      settings = $.extend({}, this.options);
    } else {
      $.each(overwrites, function (breakpoint) {
        if (breakpoint <= viewport && breakpoint > match) {
          match = Number(breakpoint);
        }
      });
      settings = $.extend({}, this.options, overwrites[match]);

      if (typeof settings.stagePadding === 'function') {
        settings.stagePadding = settings.stagePadding();
      }

      delete settings.responsive; // responsive class

      if (settings.responsiveClass) {
        this.$element.attr('class', this.$element.attr('class').replace(new RegExp('(' + this.options.responsiveClass + '-)\\S+\\s', 'g'), '$1' + match));
      }
    }

    this.trigger('change', {
      property: {
        name: 'settings',
        value: settings
      }
    });
    this._breakpoint = match;
    this.settings = settings;
    this.invalidate('settings');
    this.trigger('changed', {
      property: {
        name: 'settings',
        value: this.settings
      }
    });
  };
  /**
   * Updates option logic if necessery.
   * @protected
   */


  Owl.prototype.optionsLogic = function () {
    if (this.settings.autoWidth) {
      this.settings.stagePadding = false;
      this.settings.merge = false;
    }
  };
  /**
   * Prepares an item before add.
   * @todo Rename event parameter `content` to `item`.
   * @protected
   * @returns {jQuery|HTMLElement} - The item container.
   */


  Owl.prototype.prepare = function (item) {
    var event = this.trigger('prepare', {
      content: item
    });

    if (!event.data) {
      event.data = $('<' + this.settings.itemElement + '/>').addClass(this.options.itemClass).append(item);
    }

    this.trigger('prepared', {
      content: event.data
    });
    return event.data;
  };
  /**
   * Updates the view.
   * @public
   */


  Owl.prototype.update = function () {
    var i = 0,
        n = this._pipe.length,
        filter = $.proxy(function (p) {
      return this[p];
    }, this._invalidated),
        cache = {};

    while (i < n) {
      if (this._invalidated.all || $.grep(this._pipe[i].filter, filter).length > 0) {
        this._pipe[i].run(cache);
      }

      i++;
    }

    this._invalidated = {};
    !this.is('valid') && this.enter('valid');
  };
  /**
   * Gets the width of the view.
   * @public
   * @param {Owl.Width} [dimension=Owl.Width.Default] - The dimension to return.
   * @returns {Number} - The width of the view in pixel.
   */


  Owl.prototype.width = function (dimension) {
    dimension = dimension || Owl.Width.Default;

    switch (dimension) {
      case Owl.Width.Inner:
      case Owl.Width.Outer:
        return this._width;

      default:
        return this._width - this.settings.stagePadding * 2 + this.settings.margin;
    }
  };
  /**
   * Refreshes the carousel primarily for adaptive purposes.
   * @public
   */


  Owl.prototype.refresh = function () {
    this.enter('refreshing');
    this.trigger('refresh');
    this.setup();
    this.optionsLogic();
    this.$element.addClass(this.options.refreshClass);
    this.update();
    this.$element.removeClass(this.options.refreshClass);
    this.leave('refreshing');
    this.trigger('refreshed');
  };
  /**
   * Checks window `resize` event.
   * @protected
   */


  Owl.prototype.onThrottledResize = function () {
    window.clearTimeout(this.resizeTimer);
    this.resizeTimer = window.setTimeout(this._handlers.onResize, this.settings.responsiveRefreshRate);
  };
  /**
   * Checks window `resize` event.
   * @protected
   */


  Owl.prototype.onResize = function () {
    if (!this._items.length) {
      return false;
    }

    if (this._width === this.$element.width()) {
      return false;
    }

    if (!this.isVisible()) {
      return false;
    }

    this.enter('resizing');

    if (this.trigger('resize').isDefaultPrevented()) {
      this.leave('resizing');
      return false;
    }

    this.invalidate('width');
    this.refresh();
    this.leave('resizing');
    this.trigger('resized');
  };
  /**
   * Registers event handlers.
   * @todo Check `msPointerEnabled`
   * @todo #261
   * @protected
   */


  Owl.prototype.registerEventHandlers = function () {
    if ($.support.transition) {
      this.$stage.on($.support.transition.end + '.owl.core', $.proxy(this.onTransitionEnd, this));
    }

    if (this.settings.responsive !== false) {
      this.on(window, 'resize', this._handlers.onThrottledResize);
    }

    if (this.settings.mouseDrag) {
      this.$element.addClass(this.options.dragClass);
      this.$stage.on('mousedown.owl.core', $.proxy(this.onDragStart, this));
      this.$stage.on('dragstart.owl.core selectstart.owl.core', function () {
        return false;
      });
    }

    if (this.settings.touchDrag) {
      this.$stage.on('touchstart.owl.core', $.proxy(this.onDragStart, this));
      this.$stage.on('touchcancel.owl.core', $.proxy(this.onDragEnd, this));
    }
  };
  /**
   * Handles `touchstart` and `mousedown` events.
   * @todo Horizontal swipe threshold as option
   * @todo #261
   * @protected
   * @param {Event} event - The event arguments.
   */


  Owl.prototype.onDragStart = function (event) {
    var stage = null;

    if (event.which === 3) {
      return;
    }

    if ($.support.transform) {
      stage = this.$stage.css('transform').replace(/.*\(|\)| /g, '').split(',');
      stage = {
        x: stage[stage.length === 16 ? 12 : 4],
        y: stage[stage.length === 16 ? 13 : 5]
      };
    } else {
      stage = this.$stage.position();
      stage = {
        x: this.settings.rtl ? stage.left + this.$stage.width() - this.width() + this.settings.margin : stage.left,
        y: stage.top
      };
    }

    if (this.is('animating')) {
      $.support.transform ? this.animate(stage.x) : this.$stage.stop();
      this.invalidate('position');
    }

    this.$element.toggleClass(this.options.grabClass, event.type === 'mousedown');
    this.speed(0);
    this._drag.time = new Date().getTime();
    this._drag.target = $(event.target);
    this._drag.stage.start = stage;
    this._drag.stage.current = stage;
    this._drag.pointer = this.pointer(event);
    $(document).on('mouseup.owl.core touchend.owl.core', $.proxy(this.onDragEnd, this));
    $(document).one('mousemove.owl.core touchmove.owl.core', $.proxy(function (event) {
      var delta = this.difference(this._drag.pointer, this.pointer(event));
      $(document).on('mousemove.owl.core touchmove.owl.core', $.proxy(this.onDragMove, this));

      if (Math.abs(delta.x) < Math.abs(delta.y) && this.is('valid')) {
        return;
      }

      event.preventDefault();
      this.enter('dragging');
      this.trigger('drag');
    }, this));
  };
  /**
   * Handles the `touchmove` and `mousemove` events.
   * @todo #261
   * @protected
   * @param {Event} event - The event arguments.
   */


  Owl.prototype.onDragMove = function (event) {
    var minimum = null,
        maximum = null,
        pull = null,
        delta = this.difference(this._drag.pointer, this.pointer(event)),
        stage = this.difference(this._drag.stage.start, delta);

    if (!this.is('dragging')) {
      return;
    }

    event.preventDefault();

    if (this.settings.loop) {
      minimum = this.coordinates(this.minimum());
      maximum = this.coordinates(this.maximum() + 1) - minimum;
      stage.x = ((stage.x - minimum) % maximum + maximum) % maximum + minimum;
    } else {
      minimum = this.settings.rtl ? this.coordinates(this.maximum()) : this.coordinates(this.minimum());
      maximum = this.settings.rtl ? this.coordinates(this.minimum()) : this.coordinates(this.maximum());
      pull = this.settings.pullDrag ? -1 * delta.x / 5 : 0;
      stage.x = Math.max(Math.min(stage.x, minimum + pull), maximum + pull);
    }

    this._drag.stage.current = stage;
    this.animate(stage.x);
  };
  /**
   * Handles the `touchend` and `mouseup` events.
   * @todo #261
   * @todo Threshold for click event
   * @protected
   * @param {Event} event - The event arguments.
   */


  Owl.prototype.onDragEnd = function (event) {
    var delta = this.difference(this._drag.pointer, this.pointer(event)),
        stage = this._drag.stage.current,
        direction = delta.x > 0 ^ this.settings.rtl ? 'left' : 'right';
    $(document).off('.owl.core');
    this.$element.removeClass(this.options.grabClass);

    if (delta.x !== 0 && this.is('dragging') || !this.is('valid')) {
      this.speed(this.settings.dragEndSpeed || this.settings.smartSpeed);
      this.current(this.closest(stage.x, delta.x !== 0 ? direction : this._drag.direction));
      this.invalidate('position');
      this.update();
      this._drag.direction = direction;

      if (Math.abs(delta.x) > 3 || new Date().getTime() - this._drag.time > 300) {
        this._drag.target.one('click.owl.core', function () {
          return false;
        });
      }
    }

    if (!this.is('dragging')) {
      return;
    }

    this.leave('dragging');
    this.trigger('dragged');
  };
  /**
   * Gets absolute position of the closest item for a coordinate.
   * @todo Setting `freeDrag` makes `closest` not reusable. See #165.
   * @protected
   * @param {Number} coordinate - The coordinate in pixel.
   * @param {String} direction - The direction to check for the closest item. Ether `left` or `right`.
   * @return {Number} - The absolute position of the closest item.
   */


  Owl.prototype.closest = function (coordinate, direction) {
    var position = -1,
        pull = 30,
        width = this.width(),
        coordinates = this.coordinates();

    if (!this.settings.freeDrag) {
      // check closest item
      $.each(coordinates, $.proxy(function (index, value) {
        // on a left pull, check on current index
        if (direction === 'left' && coordinate > value - pull && coordinate < value + pull) {
          position = index; // on a right pull, check on previous index
          // to do so, subtract width from value and set position = index + 1
        } else if (direction === 'right' && coordinate > value - width - pull && coordinate < value - width + pull) {
          position = index + 1;
        } else if (this.op(coordinate, '<', value) && this.op(coordinate, '>', coordinates[index + 1] !== undefined ? coordinates[index + 1] : value - width)) {
          position = direction === 'left' ? index + 1 : index;
        }

        return position === -1;
      }, this));
    }

    if (!this.settings.loop) {
      // non loop boundries
      if (this.op(coordinate, '>', coordinates[this.minimum()])) {
        position = coordinate = this.minimum();
      } else if (this.op(coordinate, '<', coordinates[this.maximum()])) {
        position = coordinate = this.maximum();
      }
    }

    return position;
  };
  /**
   * Animates the stage.
   * @todo #270
   * @public
   * @param {Number} coordinate - The coordinate in pixels.
   */


  Owl.prototype.animate = function (coordinate) {
    var animate = this.speed() > 0;
    this.is('animating') && this.onTransitionEnd();

    if (animate) {
      this.enter('animating');
      this.trigger('translate');
    }

    if ($.support.transform3d && $.support.transition) {
      this.$stage.css({
        transform: 'translate3d(' + coordinate + 'px,0px,0px)',
        transition: this.speed() / 1000 + 's' + (this.settings.slideTransition ? ' ' + this.settings.slideTransition : '')
      });
    } else if (animate) {
      this.$stage.animate({
        left: coordinate + 'px'
      }, this.speed(), this.settings.fallbackEasing, $.proxy(this.onTransitionEnd, this));
    } else {
      this.$stage.css({
        left: coordinate + 'px'
      });
    }
  };
  /**
   * Checks whether the carousel is in a specific state or not.
   * @param {String} state - The state to check.
   * @returns {Boolean} - The flag which indicates if the carousel is busy.
   */


  Owl.prototype.is = function (state) {
    return this._states.current[state] && this._states.current[state] > 0;
  };
  /**
   * Sets the absolute position of the current item.
   * @public
   * @param {Number} [position] - The new absolute position or nothing to leave it unchanged.
   * @returns {Number} - The absolute position of the current item.
   */


  Owl.prototype.current = function (position) {
    if (position === undefined) {
      return this._current;
    }

    if (this._items.length === 0) {
      return undefined;
    }

    position = this.normalize(position);

    if (this._current !== position) {
      var event = this.trigger('change', {
        property: {
          name: 'position',
          value: position
        }
      });

      if (event.data !== undefined) {
        position = this.normalize(event.data);
      }

      this._current = position;
      this.invalidate('position');
      this.trigger('changed', {
        property: {
          name: 'position',
          value: this._current
        }
      });
    }

    return this._current;
  };
  /**
   * Invalidates the given part of the update routine.
   * @param {String} [part] - The part to invalidate.
   * @returns {Array.<String>} - The invalidated parts.
   */


  Owl.prototype.invalidate = function (part) {
    if ($.type(part) === 'string') {
      this._invalidated[part] = true;
      this.is('valid') && this.leave('valid');
    }

    return $.map(this._invalidated, function (v, i) {
      return i;
    });
  };
  /**
   * Resets the absolute position of the current item.
   * @public
   * @param {Number} position - The absolute position of the new item.
   */


  Owl.prototype.reset = function (position) {
    position = this.normalize(position);

    if (position === undefined) {
      return;
    }

    this._speed = 0;
    this._current = position;
    this.suppress(['translate', 'translated']);
    this.animate(this.coordinates(position));
    this.release(['translate', 'translated']);
  };
  /**
   * Normalizes an absolute or a relative position of an item.
   * @public
   * @param {Number} position - The absolute or relative position to normalize.
   * @param {Boolean} [relative=false] - Whether the given position is relative or not.
   * @returns {Number} - The normalized position.
   */


  Owl.prototype.normalize = function (position, relative) {
    var n = this._items.length,
        m = relative ? 0 : this._clones.length;

    if (!this.isNumeric(position) || n < 1) {
      position = undefined;
    } else if (position < 0 || position >= n + m) {
      position = ((position - m / 2) % n + n) % n + m / 2;
    }

    return position;
  };
  /**
   * Converts an absolute position of an item into a relative one.
   * @public
   * @param {Number} position - The absolute position to convert.
   * @returns {Number} - The converted position.
   */


  Owl.prototype.relative = function (position) {
    position -= this._clones.length / 2;
    return this.normalize(position, true);
  };
  /**
   * Gets the maximum position for the current item.
   * @public
   * @param {Boolean} [relative=false] - Whether to return an absolute position or a relative position.
   * @returns {Number}
   */


  Owl.prototype.maximum = function (relative) {
    var settings = this.settings,
        maximum = this._coordinates.length,
        iterator,
        reciprocalItemsWidth,
        elementWidth;

    if (settings.loop) {
      maximum = this._clones.length / 2 + this._items.length - 1;
    } else if (settings.autoWidth || settings.merge) {
      iterator = this._items.length;

      if (iterator) {
        reciprocalItemsWidth = this._items[--iterator].width();
        elementWidth = this.$element.width();

        while (iterator--) {
          reciprocalItemsWidth += this._items[iterator].width() + this.settings.margin;

          if (reciprocalItemsWidth > elementWidth) {
            break;
          }
        }
      }

      maximum = iterator + 1;
    } else if (settings.center) {
      maximum = this._items.length - 1;
    } else {
      maximum = this._items.length - settings.items;
    }

    if (relative) {
      maximum -= this._clones.length / 2;
    }

    return Math.max(maximum, 0);
  };
  /**
   * Gets the minimum position for the current item.
   * @public
   * @param {Boolean} [relative=false] - Whether to return an absolute position or a relative position.
   * @returns {Number}
   */


  Owl.prototype.minimum = function (relative) {
    return relative ? 0 : this._clones.length / 2;
  };
  /**
   * Gets an item at the specified relative position.
   * @public
   * @param {Number} [position] - The relative position of the item.
   * @return {jQuery|Array.<jQuery>} - The item at the given position or all items if no position was given.
   */


  Owl.prototype.items = function (position) {
    if (position === undefined) {
      return this._items.slice();
    }

    position = this.normalize(position, true);
    return this._items[position];
  };
  /**
   * Gets an item at the specified relative position.
   * @public
   * @param {Number} [position] - The relative position of the item.
   * @return {jQuery|Array.<jQuery>} - The item at the given position or all items if no position was given.
   */


  Owl.prototype.mergers = function (position) {
    if (position === undefined) {
      return this._mergers.slice();
    }

    position = this.normalize(position, true);
    return this._mergers[position];
  };
  /**
   * Gets the absolute positions of clones for an item.
   * @public
   * @param {Number} [position] - The relative position of the item.
   * @returns {Array.<Number>} - The absolute positions of clones for the item or all if no position was given.
   */


  Owl.prototype.clones = function (position) {
    var odd = this._clones.length / 2,
        even = odd + this._items.length,
        map = function map(index) {
      return index % 2 === 0 ? even + index / 2 : odd - (index + 1) / 2;
    };

    if (position === undefined) {
      return $.map(this._clones, function (v, i) {
        return map(i);
      });
    }

    return $.map(this._clones, function (v, i) {
      return v === position ? map(i) : null;
    });
  };
  /**
   * Sets the current animation speed.
   * @public
   * @param {Number} [speed] - The animation speed in milliseconds or nothing to leave it unchanged.
   * @returns {Number} - The current animation speed in milliseconds.
   */


  Owl.prototype.speed = function (speed) {
    if (speed !== undefined) {
      this._speed = speed;
    }

    return this._speed;
  };
  /**
   * Gets the coordinate of an item.
   * @todo The name of this method is missleanding.
   * @public
   * @param {Number} position - The absolute position of the item within `minimum()` and `maximum()`.
   * @returns {Number|Array.<Number>} - The coordinate of the item in pixel or all coordinates.
   */


  Owl.prototype.coordinates = function (position) {
    var multiplier = 1,
        newPosition = position - 1,
        coordinate;

    if (position === undefined) {
      return $.map(this._coordinates, $.proxy(function (coordinate, index) {
        return this.coordinates(index);
      }, this));
    }

    if (this.settings.center) {
      if (this.settings.rtl) {
        multiplier = -1;
        newPosition = position + 1;
      }

      coordinate = this._coordinates[position];
      coordinate += (this.width() - coordinate + (this._coordinates[newPosition] || 0)) / 2 * multiplier;
    } else {
      coordinate = this._coordinates[newPosition] || 0;
    }

    coordinate = Math.ceil(coordinate);
    return coordinate;
  };
  /**
   * Calculates the speed for a translation.
   * @protected
   * @param {Number} from - The absolute position of the start item.
   * @param {Number} to - The absolute position of the target item.
   * @param {Number} [factor=undefined] - The time factor in milliseconds.
   * @returns {Number} - The time in milliseconds for the translation.
   */


  Owl.prototype.duration = function (from, to, factor) {
    if (factor === 0) {
      return 0;
    }

    return Math.min(Math.max(Math.abs(to - from), 1), 6) * Math.abs(factor || this.settings.smartSpeed);
  };
  /**
   * Slides to the specified item.
   * @public
   * @param {Number} position - The position of the item.
   * @param {Number} [speed] - The time in milliseconds for the transition.
   */


  Owl.prototype.to = function (position, speed) {
    var current = this.current(),
        revert = null,
        distance = position - this.relative(current),
        direction = (distance > 0) - (distance < 0),
        items = this._items.length,
        minimum = this.minimum(),
        maximum = this.maximum();

    if (this.settings.loop) {
      if (!this.settings.rewind && Math.abs(distance) > items / 2) {
        distance += direction * -1 * items;
      }

      position = current + distance;
      revert = ((position - minimum) % items + items) % items + minimum;

      if (revert !== position && revert - distance <= maximum && revert - distance > 0) {
        current = revert - distance;
        position = revert;
        this.reset(current);
      }
    } else if (this.settings.rewind) {
      maximum += 1;
      position = (position % maximum + maximum) % maximum;
    } else {
      position = Math.max(minimum, Math.min(maximum, position));
    }

    this.speed(this.duration(current, position, speed));
    this.current(position);

    if (this.isVisible()) {
      this.update();
    }
  };
  /**
   * Slides to the next item.
   * @public
   * @param {Number} [speed] - The time in milliseconds for the transition.
   */


  Owl.prototype.next = function (speed) {
    speed = speed || false;
    this.to(this.relative(this.current()) + 1, speed);
  };
  /**
   * Slides to the previous item.
   * @public
   * @param {Number} [speed] - The time in milliseconds for the transition.
   */


  Owl.prototype.prev = function (speed) {
    speed = speed || false;
    this.to(this.relative(this.current()) - 1, speed);
  };
  /**
   * Handles the end of an animation.
   * @protected
   * @param {Event} event - The event arguments.
   */


  Owl.prototype.onTransitionEnd = function (event) {
    // if css2 animation then event object is undefined
    if (event !== undefined) {
      event.stopPropagation(); // Catch only owl-stage transitionEnd event

      if ((event.target || event.srcElement || event.originalTarget) !== this.$stage.get(0)) {
        return false;
      }
    }

    this.leave('animating');
    this.trigger('translated');
  };
  /**
   * Gets viewport width.
   * @protected
   * @return {Number} - The width in pixel.
   */


  Owl.prototype.viewport = function () {
    var width;

    if (this.options.responsiveBaseElement !== window) {
      width = $(this.options.responsiveBaseElement).width();
    } else if (window.innerWidth) {
      width = window.innerWidth;
    } else if (document.documentElement && document.documentElement.clientWidth) {
      width = document.documentElement.clientWidth;
    } else {
      console.warn('Can not detect viewport width.');
    }

    return width;
  };
  /**
   * Replaces the current content.
   * @public
   * @param {HTMLElement|jQuery|String} content - The new content.
   */


  Owl.prototype.replace = function (content) {
    this.$stage.empty();
    this._items = [];

    if (content) {
      content = content instanceof jQuery ? content : $(content);
    }

    if (this.settings.nestedItemSelector) {
      content = content.find('.' + this.settings.nestedItemSelector);
    }

    content.filter(function () {
      return this.nodeType === 1;
    }).each($.proxy(function (index, item) {
      item = this.prepare(item);
      this.$stage.append(item);

      this._items.push(item);

      this._mergers.push(item.find('[data-merge]').addBack('[data-merge]').attr('data-merge') * 1 || 1);
    }, this));
    this.reset(this.isNumeric(this.settings.startPosition) ? this.settings.startPosition : 0);
    this.invalidate('items');
  };
  /**
   * Adds an item.
   * @todo Use `item` instead of `content` for the event arguments.
   * @public
   * @param {HTMLElement|jQuery|String} content - The item content to add.
   * @param {Number} [position] - The relative position at which to insert the item otherwise the item will be added to the end.
   */


  Owl.prototype.add = function (content, position) {
    var current = this.relative(this._current);
    position = position === undefined ? this._items.length : this.normalize(position, true);
    content = content instanceof jQuery ? content : $(content);
    this.trigger('add', {
      content: content,
      position: position
    });
    content = this.prepare(content);

    if (this._items.length === 0 || position === this._items.length) {
      this._items.length === 0 && this.$stage.append(content);
      this._items.length !== 0 && this._items[position - 1].after(content);

      this._items.push(content);

      this._mergers.push(content.find('[data-merge]').addBack('[data-merge]').attr('data-merge') * 1 || 1);
    } else {
      this._items[position].before(content);

      this._items.splice(position, 0, content);

      this._mergers.splice(position, 0, content.find('[data-merge]').addBack('[data-merge]').attr('data-merge') * 1 || 1);
    }

    this._items[current] && this.reset(this._items[current].index());
    this.invalidate('items');
    this.trigger('added', {
      content: content,
      position: position
    });
  };
  /**
   * Removes an item by its position.
   * @todo Use `item` instead of `content` for the event arguments.
   * @public
   * @param {Number} position - The relative position of the item to remove.
   */


  Owl.prototype.remove = function (position) {
    position = this.normalize(position, true);

    if (position === undefined) {
      return;
    }

    this.trigger('remove', {
      content: this._items[position],
      position: position
    });

    this._items[position].remove();

    this._items.splice(position, 1);

    this._mergers.splice(position, 1);

    this.invalidate('items');
    this.trigger('removed', {
      content: null,
      position: position
    });
  };
  /**
   * Preloads images with auto width.
   * @todo Replace by a more generic approach
   * @protected
   */


  Owl.prototype.preloadAutoWidthImages = function (images) {
    images.each($.proxy(function (i, element) {
      this.enter('pre-loading');
      element = $(element);
      $(new Image()).one('load', $.proxy(function (e) {
        element.attr('src', e.target.src);
        element.css('opacity', 1);
        this.leave('pre-loading');
        !this.is('pre-loading') && !this.is('initializing') && this.refresh();
      }, this)).attr('src', element.attr('src') || element.attr('data-src') || element.attr('data-src-retina'));
    }, this));
  };
  /**
   * Destroys the carousel.
   * @public
   */


  Owl.prototype.destroy = function () {
    this.$element.off('.owl.core');
    this.$stage.off('.owl.core');
    $(document).off('.owl.core');

    if (this.settings.responsive !== false) {
      window.clearTimeout(this.resizeTimer);
      this.off(window, 'resize', this._handlers.onThrottledResize);
    }

    for (var i in this._plugins) {
      this._plugins[i].destroy();
    }

    this.$stage.children('.cloned').remove();
    this.$stage.unwrap();
    this.$stage.children().contents().unwrap();
    this.$stage.children().unwrap();
    this.$stage.remove();
    this.$element.removeClass(this.options.refreshClass).removeClass(this.options.loadingClass).removeClass(this.options.loadedClass).removeClass(this.options.rtlClass).removeClass(this.options.dragClass).removeClass(this.options.grabClass).attr('class', this.$element.attr('class').replace(new RegExp(this.options.responsiveClass + '-\\S+\\s', 'g'), '')).removeData('owl.carousel');
  };
  /**
   * Operators to calculate right-to-left and left-to-right.
   * @protected
   * @param {Number} [a] - The left side operand.
   * @param {String} [o] - The operator.
   * @param {Number} [b] - The right side operand.
   */


  Owl.prototype.op = function (a, o, b) {
    var rtl = this.settings.rtl;

    switch (o) {
      case '<':
        return rtl ? a > b : a < b;

      case '>':
        return rtl ? a < b : a > b;

      case '>=':
        return rtl ? a <= b : a >= b;

      case '<=':
        return rtl ? a >= b : a <= b;

      default:
        break;
    }
  };
  /**
   * Attaches to an internal event.
   * @protected
   * @param {HTMLElement} element - The event source.
   * @param {String} event - The event name.
   * @param {Function} listener - The event handler to attach.
   * @param {Boolean} capture - Wether the event should be handled at the capturing phase or not.
   */


  Owl.prototype.on = function (element, event, listener, capture) {
    if (element.addEventListener) {
      element.addEventListener(event, listener, capture);
    } else if (element.attachEvent) {
      element.attachEvent('on' + event, listener);
    }
  };
  /**
   * Detaches from an internal event.
   * @protected
   * @param {HTMLElement} element - The event source.
   * @param {String} event - The event name.
   * @param {Function} listener - The attached event handler to detach.
   * @param {Boolean} capture - Wether the attached event handler was registered as a capturing listener or not.
   */


  Owl.prototype.off = function (element, event, listener, capture) {
    if (element.removeEventListener) {
      element.removeEventListener(event, listener, capture);
    } else if (element.detachEvent) {
      element.detachEvent('on' + event, listener);
    }
  };
  /**
   * Triggers a public event.
   * @todo Remove `status`, `relatedTarget` should be used instead.
   * @protected
   * @param {String} name - The event name.
   * @param {*} [data=null] - The event data.
   * @param {String} [namespace=carousel] - The event namespace.
   * @param {String} [state] - The state which is associated with the event.
   * @param {Boolean} [enter=false] - Indicates if the call enters the specified state or not.
   * @returns {Event} - The event arguments.
   */


  Owl.prototype.trigger = function (name, data, namespace, state, enter) {
    var status = {
      item: {
        count: this._items.length,
        index: this.current()
      }
    },
        handler = $.camelCase($.grep(['on', name, namespace], function (v) {
      return v;
    }).join('-').toLowerCase()),
        event = $.Event([name, 'owl', namespace || 'carousel'].join('.').toLowerCase(), $.extend({
      relatedTarget: this
    }, status, data));

    if (!this._supress[name]) {
      $.each(this._plugins, function (name, plugin) {
        if (plugin.onTrigger) {
          plugin.onTrigger(event);
        }
      });
      this.register({
        type: Owl.Type.Event,
        name: name
      });
      this.$element.trigger(event);

      if (this.settings && typeof this.settings[handler] === 'function') {
        this.settings[handler].call(this, event);
      }
    }

    return event;
  };
  /**
   * Enters a state.
   * @param name - The state name.
   */


  Owl.prototype.enter = function (name) {
    $.each([name].concat(this._states.tags[name] || []), $.proxy(function (i, name) {
      if (this._states.current[name] === undefined) {
        this._states.current[name] = 0;
      }

      this._states.current[name]++;
    }, this));
  };
  /**
   * Leaves a state.
   * @param name - The state name.
   */


  Owl.prototype.leave = function (name) {
    $.each([name].concat(this._states.tags[name] || []), $.proxy(function (i, name) {
      this._states.current[name]--;
    }, this));
  };
  /**
   * Registers an event or state.
   * @public
   * @param {Object} object - The event or state to register.
   */


  Owl.prototype.register = function (object) {
    if (object.type === Owl.Type.Event) {
      if (!$.event.special[object.name]) {
        $.event.special[object.name] = {};
      }

      if (!$.event.special[object.name].owl) {
        var _default = $.event.special[object.name]._default;

        $.event.special[object.name]._default = function (e) {
          if (_default && _default.apply && (!e.namespace || e.namespace.indexOf('owl') === -1)) {
            return _default.apply(this, arguments);
          }

          return e.namespace && e.namespace.indexOf('owl') > -1;
        };

        $.event.special[object.name].owl = true;
      }
    } else if (object.type === Owl.Type.State) {
      if (!this._states.tags[object.name]) {
        this._states.tags[object.name] = object.tags;
      } else {
        this._states.tags[object.name] = this._states.tags[object.name].concat(object.tags);
      }

      this._states.tags[object.name] = $.grep(this._states.tags[object.name], $.proxy(function (tag, i) {
        return $.inArray(tag, this._states.tags[object.name]) === i;
      }, this));
    }
  };
  /**
   * Suppresses events.
   * @protected
   * @param {Array.<String>} events - The events to suppress.
   */


  Owl.prototype.suppress = function (events) {
    $.each(events, $.proxy(function (index, event) {
      this._supress[event] = true;
    }, this));
  };
  /**
   * Releases suppressed events.
   * @protected
   * @param {Array.<String>} events - The events to release.
   */


  Owl.prototype.release = function (events) {
    $.each(events, $.proxy(function (index, event) {
      delete this._supress[event];
    }, this));
  };
  /**
   * Gets unified pointer coordinates from event.
   * @todo #261
   * @protected
   * @param {Event} - The `mousedown` or `touchstart` event.
   * @returns {Object} - Contains `x` and `y` coordinates of current pointer position.
   */


  Owl.prototype.pointer = function (event) {
    var result = {
      x: null,
      y: null
    };
    event = event.originalEvent || event || window.event;
    event = event.touches && event.touches.length ? event.touches[0] : event.changedTouches && event.changedTouches.length ? event.changedTouches[0] : event;

    if (event.pageX) {
      result.x = event.pageX;
      result.y = event.pageY;
    } else {
      result.x = event.clientX;
      result.y = event.clientY;
    }

    return result;
  };
  /**
   * Determines if the input is a Number or something that can be coerced to a Number
   * @protected
   * @param {Number|String|Object|Array|Boolean|RegExp|Function|Symbol} - The input to be tested
   * @returns {Boolean} - An indication if the input is a Number or can be coerced to a Number
   */


  Owl.prototype.isNumeric = function (number) {
    return !isNaN(parseFloat(number));
  };
  /**
   * Gets the difference of two vectors.
   * @todo #261
   * @protected
   * @param {Object} - The first vector.
   * @param {Object} - The second vector.
   * @returns {Object} - The difference.
   */


  Owl.prototype.difference = function (first, second) {
    return {
      x: first.x - second.x,
      y: first.y - second.y
    };
  };
  /**
   * The jQuery Plugin for the Owl Carousel
   * @todo Navigation plugin `next` and `prev`
   * @public
   */


  $.fn.owlCarousel = function (option) {
    var args = Array.prototype.slice.call(arguments, 1);
    return this.each(function () {
      var $this = $(this),
          data = $this.data('owl.carousel');

      if (!data) {
        data = new Owl(this, _typeof(option) == 'object' && option);
        $this.data('owl.carousel', data);
        $.each(['next', 'prev', 'to', 'destroy', 'refresh', 'replace', 'add', 'remove'], function (i, event) {
          data.register({
            type: Owl.Type.Event,
            name: event
          });
          data.$element.on(event + '.owl.carousel.core', $.proxy(function (e) {
            if (e.namespace && e.relatedTarget !== this) {
              this.suppress([event]);
              data[event].apply(this, [].slice.call(arguments, 1));
              this.release([event]);
            }
          }, data));
        });
      }

      if (typeof option == 'string' && option.charAt(0) !== '_') {
        data[option].apply(data, args);
      }
    });
  };
  /**
   * The constructor for the jQuery Plugin
   * @public
   */


  $.fn.owlCarousel.Constructor = Owl;
})(window.Zepto || window.jQuery, window, document);
/**
 * AutoRefresh Plugin
 * @version 2.3.4
 * @author Artus Kolanowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  /**
   * Creates the auto refresh plugin.
   * @class The Auto Refresh Plugin
   * @param {Owl} carousel - The Owl Carousel
   */
  var AutoRefresh = function AutoRefresh(carousel) {
    /**
     * Reference to the core.
     * @protected
     * @type {Owl}
     */
    this._core = carousel;
    /**
     * Refresh interval.
     * @protected
     * @type {number}
     */

    this._interval = null;
    /**
     * Whether the element is currently visible or not.
     * @protected
     * @type {Boolean}
     */

    this._visible = null;
    /**
     * All event handlers.
     * @protected
     * @type {Object}
     */

    this._handlers = {
      'initialized.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.autoRefresh) {
          this.watch();
        }
      }, this)
    }; // set default options

    this._core.options = $.extend({}, AutoRefresh.Defaults, this._core.options); // register event handlers

    this._core.$element.on(this._handlers);
  };
  /**
   * Default options.
   * @public
   */


  AutoRefresh.Defaults = {
    autoRefresh: true,
    autoRefreshInterval: 500
  };
  /**
   * Watches the element.
   */

  AutoRefresh.prototype.watch = function () {
    if (this._interval) {
      return;
    }

    this._visible = this._core.isVisible();
    this._interval = window.setInterval($.proxy(this.refresh, this), this._core.settings.autoRefreshInterval);
  };
  /**
   * Refreshes the element.
   */


  AutoRefresh.prototype.refresh = function () {
    if (this._core.isVisible() === this._visible) {
      return;
    }

    this._visible = !this._visible;

    this._core.$element.toggleClass('owl-hidden', !this._visible);

    this._visible && this._core.invalidate('width') && this._core.refresh();
  };
  /**
   * Destroys the plugin.
   */


  AutoRefresh.prototype.destroy = function () {
    var handler, property;
    window.clearInterval(this._interval);

    for (handler in this._handlers) {
      this._core.$element.off(handler, this._handlers[handler]);
    }

    for (property in Object.getOwnPropertyNames(this)) {
      typeof this[property] != 'function' && (this[property] = null);
    }
  };

  $.fn.owlCarousel.Constructor.Plugins.AutoRefresh = AutoRefresh;
})(window.Zepto || window.jQuery, window, document);
/**
 * Lazy Plugin
 * @version 2.3.4
 * @author Bartosz Wojciechowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  /**
   * Creates the lazy plugin.
   * @class The Lazy Plugin
   * @param {Owl} carousel - The Owl Carousel
   */
  var Lazy = function Lazy(carousel) {
    /**
     * Reference to the core.
     * @protected
     * @type {Owl}
     */
    this._core = carousel;
    /**
     * Already loaded items.
     * @protected
     * @type {Array.<jQuery>}
     */

    this._loaded = [];
    /**
     * Event handlers.
     * @protected
     * @type {Object}
     */

    this._handlers = {
      'initialized.owl.carousel change.owl.carousel resized.owl.carousel': $.proxy(function (e) {
        if (!e.namespace) {
          return;
        }

        if (!this._core.settings || !this._core.settings.lazyLoad) {
          return;
        }

        if (e.property && e.property.name == 'position' || e.type == 'initialized') {
          var settings = this._core.settings,
              n = settings.center && Math.ceil(settings.items / 2) || settings.items,
              i = settings.center && n * -1 || 0,
              position = (e.property && e.property.value !== undefined ? e.property.value : this._core.current()) + i,
              clones = this._core.clones().length,
              load = $.proxy(function (i, v) {
            this.load(v);
          }, this); //TODO: Need documentation for this new option


          if (settings.lazyLoadEager > 0) {
            n += settings.lazyLoadEager; // If the carousel is looping also preload images that are to the "left"

            if (settings.loop) {
              position -= settings.lazyLoadEager;
              n++;
            }
          }

          while (i++ < n) {
            this.load(clones / 2 + this._core.relative(position));
            clones && $.each(this._core.clones(this._core.relative(position)), load);
            position++;
          }
        }
      }, this)
    }; // set the default options

    this._core.options = $.extend({}, Lazy.Defaults, this._core.options); // register event handler

    this._core.$element.on(this._handlers);
  };
  /**
   * Default options.
   * @public
   */


  Lazy.Defaults = {
    lazyLoad: false,
    lazyLoadEager: 0
  };
  /**
   * Loads all resources of an item at the specified position.
   * @param {Number} position - The absolute position of the item.
   * @protected
   */

  Lazy.prototype.load = function (position) {
    var $item = this._core.$stage.children().eq(position),
        $elements = $item && $item.find('.owl-lazy');

    if (!$elements || $.inArray($item.get(0), this._loaded) > -1) {
      return;
    }

    $elements.each($.proxy(function (index, element) {
      var $element = $(element),
          image,
          url = window.devicePixelRatio > 1 && $element.attr('data-src-retina') || $element.attr('data-src') || $element.attr('data-srcset');

      this._core.trigger('load', {
        element: $element,
        url: url
      }, 'lazy');

      if ($element.is('img')) {
        $element.one('load.owl.lazy', $.proxy(function () {
          $element.css('opacity', 1);

          this._core.trigger('loaded', {
            element: $element,
            url: url
          }, 'lazy');
        }, this)).attr('src', url);
      } else if ($element.is('source')) {
        $element.one('load.owl.lazy', $.proxy(function () {
          this._core.trigger('loaded', {
            element: $element,
            url: url
          }, 'lazy');
        }, this)).attr('srcset', url);
      } else {
        image = new Image();
        image.onload = $.proxy(function () {
          $element.css({
            'background-image': 'url("' + url + '")',
            'opacity': '1'
          });

          this._core.trigger('loaded', {
            element: $element,
            url: url
          }, 'lazy');
        }, this);
        image.src = url;
      }
    }, this));

    this._loaded.push($item.get(0));
  };
  /**
   * Destroys the plugin.
   * @public
   */


  Lazy.prototype.destroy = function () {
    var handler, property;

    for (handler in this.handlers) {
      this._core.$element.off(handler, this.handlers[handler]);
    }

    for (property in Object.getOwnPropertyNames(this)) {
      typeof this[property] != 'function' && (this[property] = null);
    }
  };

  $.fn.owlCarousel.Constructor.Plugins.Lazy = Lazy;
})(window.Zepto || window.jQuery, window, document);
/**
 * AutoHeight Plugin
 * @version 2.3.4
 * @author Bartosz Wojciechowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  /**
   * Creates the auto height plugin.
   * @class The Auto Height Plugin
   * @param {Owl} carousel - The Owl Carousel
   */
  var AutoHeight = function AutoHeight(carousel) {
    /**
     * Reference to the core.
     * @protected
     * @type {Owl}
     */
    this._core = carousel;
    this._previousHeight = null;
    /**
     * All event handlers.
     * @protected
     * @type {Object}
     */

    this._handlers = {
      'initialized.owl.carousel refreshed.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.autoHeight) {
          this.update();
        }
      }, this),
      'changed.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.autoHeight && e.property.name === 'position') {
          this.update();
        }
      }, this),
      'loaded.owl.lazy': $.proxy(function (e) {
        if (e.namespace && this._core.settings.autoHeight && e.element.closest('.' + this._core.settings.itemClass).index() === this._core.current()) {
          this.update();
        }
      }, this)
    }; // set default options

    this._core.options = $.extend({}, AutoHeight.Defaults, this._core.options); // register event handlers

    this._core.$element.on(this._handlers);

    this._intervalId = null;
    var refThis = this; // These changes have been taken from a PR by gavrochelegnou proposed in #1575
    // and have been made compatible with the latest jQuery version

    $(window).on('load', function () {
      if (refThis._core.settings.autoHeight) {
        refThis.update();
      }
    }); // Autoresize the height of the carousel when window is resized
    // When carousel has images, the height is dependent on the width
    // and should also change on resize

    $(window).resize(function () {
      if (refThis._core.settings.autoHeight) {
        if (refThis._intervalId != null) {
          clearTimeout(refThis._intervalId);
        }

        refThis._intervalId = setTimeout(function () {
          refThis.update();
        }, 250);
      }
    });
  };
  /**
   * Default options.
   * @public
   */


  AutoHeight.Defaults = {
    autoHeight: false,
    autoHeightClass: 'owl-height'
  };
  /**
   * Updates the view.
   */

  AutoHeight.prototype.update = function () {
    var start = this._core._current,
        end = start + this._core.settings.items,
        lazyLoadEnabled = this._core.settings.lazyLoad,
        visible = this._core.$stage.children().toArray().slice(start, end),
        heights = [],
        maxheight = 0;

    $.each(visible, function (index, item) {
      heights.push($(item).height());
    });
    maxheight = Math.max.apply(null, heights);

    if (maxheight <= 1 && lazyLoadEnabled && this._previousHeight) {
      maxheight = this._previousHeight;
    }

    this._previousHeight = maxheight;

    this._core.$stage.parent().height(maxheight).addClass(this._core.settings.autoHeightClass);
  };

  AutoHeight.prototype.destroy = function () {
    var handler, property;

    for (handler in this._handlers) {
      this._core.$element.off(handler, this._handlers[handler]);
    }

    for (property in Object.getOwnPropertyNames(this)) {
      typeof this[property] !== 'function' && (this[property] = null);
    }
  };

  $.fn.owlCarousel.Constructor.Plugins.AutoHeight = AutoHeight;
})(window.Zepto || window.jQuery, window, document);
/**
 * Video Plugin
 * @version 2.3.4
 * @author Bartosz Wojciechowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  /**
   * Creates the video plugin.
   * @class The Video Plugin
   * @param {Owl} carousel - The Owl Carousel
   */
  var Video = function Video(carousel) {
    /**
     * Reference to the core.
     * @protected
     * @type {Owl}
     */
    this._core = carousel;
    /**
     * Cache all video URLs.
     * @protected
     * @type {Object}
     */

    this._videos = {};
    /**
     * Current playing item.
     * @protected
     * @type {jQuery}
     */

    this._playing = null;
    /**
     * All event handlers.
     * @todo The cloned content removale is too late
     * @protected
     * @type {Object}
     */

    this._handlers = {
      'initialized.owl.carousel': $.proxy(function (e) {
        if (e.namespace) {
          this._core.register({
            type: 'state',
            name: 'playing',
            tags: ['interacting']
          });
        }
      }, this),
      'resize.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.video && this.isInFullScreen()) {
          e.preventDefault();
        }
      }, this),
      'refreshed.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.is('resizing')) {
          this._core.$stage.find('.cloned .owl-video-frame').remove();
        }
      }, this),
      'changed.owl.carousel': $.proxy(function (e) {
        if (e.namespace && e.property.name === 'position' && this._playing) {
          this.stop();
        }
      }, this),
      'prepared.owl.carousel': $.proxy(function (e) {
        if (!e.namespace) {
          return;
        }

        var $element = $(e.content).find('.owl-video');

        if ($element.length) {
          $element.css('display', 'none');
          this.fetch($element, $(e.content));
        }
      }, this)
    }; // set default options

    this._core.options = $.extend({}, Video.Defaults, this._core.options); // register event handlers

    this._core.$element.on(this._handlers);

    this._core.$element.on('click.owl.video', '.owl-video-play-icon', $.proxy(function (e) {
      this.play(e);
    }, this));
  };
  /**
   * Default options.
   * @public
   */


  Video.Defaults = {
    video: false,
    videoHeight: false,
    videoWidth: false
  };
  /**
   * Gets the video ID and the type (YouTube/Vimeo/vzaar only).
   * @protected
   * @param {jQuery} target - The target containing the video data.
   * @param {jQuery} item - The item containing the video.
   */

  Video.prototype.fetch = function (target, item) {
    var type = function () {
      if (target.attr('data-vimeo-id')) {
        return 'vimeo';
      } else if (target.attr('data-vzaar-id')) {
        return 'vzaar';
      } else {
        return 'youtube';
      }
    }(),
        id = target.attr('data-vimeo-id') || target.attr('data-youtube-id') || target.attr('data-vzaar-id'),
        width = target.attr('data-width') || this._core.settings.videoWidth,
        height = target.attr('data-height') || this._core.settings.videoHeight,
        url = target.attr('href');

    if (url) {
      /*
      		Parses the id's out of the following urls (and probably more):
      		https://www.youtube.com/watch?v=:id
      		https://youtu.be/:id
      		https://vimeo.com/:id
      		https://vimeo.com/channels/:channel/:id
      		https://vimeo.com/groups/:group/videos/:id
      		https://app.vzaar.com/videos/:id
      				Visual example: https://regexper.com/#(http%3A%7Chttps%3A%7C)%5C%2F%5C%2F(player.%7Cwww.%7Capp.)%3F(vimeo%5C.com%7Cyoutu(be%5C.com%7C%5C.be%7Cbe%5C.googleapis%5C.com)%7Cvzaar%5C.com)%5C%2F(video%5C%2F%7Cvideos%5C%2F%7Cembed%5C%2F%7Cchannels%5C%2F.%2B%5C%2F%7Cgroups%5C%2F.%2B%5C%2F%7Cwatch%5C%3Fv%3D%7Cv%5C%2F)%3F(%5BA-Za-z0-9._%25-%5D*)(%5C%26%5CS%2B)%3F
      */
      id = url.match(/(http:|https:|)\/\/(player.|www.|app.)?(vimeo\.com|youtu(be\.com|\.be|be\.googleapis\.com|be\-nocookie\.com)|vzaar\.com)\/(video\/|videos\/|embed\/|channels\/.+\/|groups\/.+\/|watch\?v=|v\/)?([A-Za-z0-9._%-]*)(\&\S+)?/);

      if (id[3].indexOf('youtu') > -1) {
        type = 'youtube';
      } else if (id[3].indexOf('vimeo') > -1) {
        type = 'vimeo';
      } else if (id[3].indexOf('vzaar') > -1) {
        type = 'vzaar';
      } else {
        throw new Error('Video URL not supported.');
      }

      id = id[6];
    } else {
      throw new Error('Missing video URL.');
    }

    this._videos[url] = {
      type: type,
      id: id,
      width: width,
      height: height
    };
    item.attr('data-video', url);
    this.thumbnail(target, this._videos[url]);
  };
  /**
   * Creates video thumbnail.
   * @protected
   * @param {jQuery} target - The target containing the video data.
   * @param {Object} info - The video info object.
   * @see `fetch`
   */


  Video.prototype.thumbnail = function (target, video) {
    var tnLink,
        icon,
        path,
        dimensions = video.width && video.height ? 'width:' + video.width + 'px;height:' + video.height + 'px;' : '',
        customTn = target.find('img'),
        srcType = 'src',
        lazyClass = '',
        settings = this._core.settings,
        create = function create(path) {
      icon = '<div class="owl-video-play-icon"></div>';

      if (settings.lazyLoad) {
        tnLink = $('<div/>', {
          "class": 'owl-video-tn ' + lazyClass,
          "srcType": path
        });
      } else {
        tnLink = $('<div/>', {
          "class": "owl-video-tn",
          "style": 'opacity:1;background-image:url(' + path + ')'
        });
      }

      target.after(tnLink);
      target.after(icon);
    }; // wrap video content into owl-video-wrapper div


    target.wrap($('<div/>', {
      "class": "owl-video-wrapper",
      "style": dimensions
    }));

    if (this._core.settings.lazyLoad) {
      srcType = 'data-src';
      lazyClass = 'owl-lazy';
    } // custom thumbnail


    if (customTn.length) {
      create(customTn.attr(srcType));
      customTn.remove();
      return false;
    }

    if (video.type === 'youtube') {
      path = "//img.youtube.com/vi/" + video.id + "/hqdefault.jpg";
      create(path);
    } else if (video.type === 'vimeo') {
      $.ajax({
        type: 'GET',
        url: '//vimeo.com/api/v2/video/' + video.id + '.json',
        jsonp: 'callback',
        dataType: 'jsonp',
        success: function success(data) {
          path = data[0].thumbnail_large;
          create(path);
        }
      });
    } else if (video.type === 'vzaar') {
      $.ajax({
        type: 'GET',
        url: '//vzaar.com/api/videos/' + video.id + '.json',
        jsonp: 'callback',
        dataType: 'jsonp',
        success: function success(data) {
          path = data.framegrab_url;
          create(path);
        }
      });
    }
  };
  /**
   * Stops the current video.
   * @public
   */


  Video.prototype.stop = function () {
    this._core.trigger('stop', null, 'video');

    this._playing.find('.owl-video-frame').remove();

    this._playing.removeClass('owl-video-playing');

    this._playing = null;

    this._core.leave('playing');

    this._core.trigger('stopped', null, 'video');
  };
  /**
   * Starts the current video.
   * @public
   * @param {Event} event - The event arguments.
   */


  Video.prototype.play = function (event) {
    var target = $(event.target),
        item = target.closest('.' + this._core.settings.itemClass),
        video = this._videos[item.attr('data-video')],
        width = video.width || '100%',
        height = video.height || this._core.$stage.height(),
        html,
        iframe;

    if (this._playing) {
      return;
    }

    this._core.enter('playing');

    this._core.trigger('play', null, 'video');

    item = this._core.items(this._core.relative(item.index()));

    this._core.reset(item.index());

    html = $('<iframe frameborder="0" allowfullscreen mozallowfullscreen webkitAllowFullScreen ></iframe>');
    html.attr('height', height);
    html.attr('width', width);

    if (video.type === 'youtube') {
      html.attr('src', '//www.youtube.com/embed/' + video.id + '?autoplay=1&rel=0&v=' + video.id);
    } else if (video.type === 'vimeo') {
      html.attr('src', '//player.vimeo.com/video/' + video.id + '?autoplay=1');
    } else if (video.type === 'vzaar') {
      html.attr('src', '//view.vzaar.com/' + video.id + '/player?autoplay=true');
    }

    iframe = $(html).wrap('<div class="owl-video-frame" />').insertAfter(item.find('.owl-video'));
    this._playing = item.addClass('owl-video-playing');
  };
  /**
   * Checks whether an video is currently in full screen mode or not.
   * @todo Bad style because looks like a readonly method but changes members.
   * @protected
   * @returns {Boolean}
   */


  Video.prototype.isInFullScreen = function () {
    var element = document.fullscreenElement || document.mozFullScreenElement || document.webkitFullscreenElement;
    return element && $(element).parent().hasClass('owl-video-frame');
  };
  /**
   * Destroys the plugin.
   */


  Video.prototype.destroy = function () {
    var handler, property;

    this._core.$element.off('click.owl.video');

    for (handler in this._handlers) {
      this._core.$element.off(handler, this._handlers[handler]);
    }

    for (property in Object.getOwnPropertyNames(this)) {
      typeof this[property] != 'function' && (this[property] = null);
    }
  };

  $.fn.owlCarousel.Constructor.Plugins.Video = Video;
})(window.Zepto || window.jQuery, window, document);
/**
 * Animate Plugin
 * @version 2.3.4
 * @author Bartosz Wojciechowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  /**
   * Creates the animate plugin.
   * @class The Navigation Plugin
   * @param {Owl} scope - The Owl Carousel
   */
  var Animate = function Animate(scope) {
    this.core = scope;
    this.core.options = $.extend({}, Animate.Defaults, this.core.options);
    this.swapping = true;
    this.previous = undefined;
    this.next = undefined;
    this.handlers = {
      'change.owl.carousel': $.proxy(function (e) {
        if (e.namespace && e.property.name == 'position') {
          this.previous = this.core.current();
          this.next = e.property.value;
        }
      }, this),
      'drag.owl.carousel dragged.owl.carousel translated.owl.carousel': $.proxy(function (e) {
        if (e.namespace) {
          this.swapping = e.type == 'translated';
        }
      }, this),
      'translate.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this.swapping && (this.core.options.animateOut || this.core.options.animateIn)) {
          this.swap();
        }
      }, this)
    };
    this.core.$element.on(this.handlers);
  };
  /**
   * Default options.
   * @public
   */


  Animate.Defaults = {
    animateOut: false,
    animateIn: false
  };
  /**
   * Toggles the animation classes whenever an translations starts.
   * @protected
   * @returns {Boolean|undefined}
   */

  Animate.prototype.swap = function () {
    if (this.core.settings.items !== 1) {
      return;
    }

    if (!$.support.animation || !$.support.transition) {
      return;
    }

    this.core.speed(0);
    var left,
        clear = $.proxy(this.clear, this),
        previous = this.core.$stage.children().eq(this.previous),
        next = this.core.$stage.children().eq(this.next),
        incoming = this.core.settings.animateIn,
        outgoing = this.core.settings.animateOut;

    if (this.core.current() === this.previous) {
      return;
    }

    if (outgoing) {
      left = this.core.coordinates(this.previous) - this.core.coordinates(this.next);
      previous.one($.support.animation.end, clear).css({
        'left': left + 'px'
      }).addClass('animated owl-animated-out').addClass(outgoing);
    }

    if (incoming) {
      next.one($.support.animation.end, clear).addClass('animated owl-animated-in').addClass(incoming);
    }
  };

  Animate.prototype.clear = function (e) {
    $(e.target).css({
      'left': ''
    }).removeClass('animated owl-animated-out owl-animated-in').removeClass(this.core.settings.animateIn).removeClass(this.core.settings.animateOut);
    this.core.onTransitionEnd();
  };
  /**
   * Destroys the plugin.
   * @public
   */


  Animate.prototype.destroy = function () {
    var handler, property;

    for (handler in this.handlers) {
      this.core.$element.off(handler, this.handlers[handler]);
    }

    for (property in Object.getOwnPropertyNames(this)) {
      typeof this[property] != 'function' && (this[property] = null);
    }
  };

  $.fn.owlCarousel.Constructor.Plugins.Animate = Animate;
})(window.Zepto || window.jQuery, window, document);
/**
 * Autoplay Plugin
 * @version 2.3.4
 * @author Bartosz Wojciechowski
 * @author Artus Kolanowski
 * @author David Deutsch
 * @author Tom De Caluwé
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  /**
   * Creates the autoplay plugin.
   * @class The Autoplay Plugin
   * @param {Owl} scope - The Owl Carousel
   */
  var Autoplay = function Autoplay(carousel) {
    /**
     * Reference to the core.
     * @protected
     * @type {Owl}
     */
    this._core = carousel;
    /**
     * The autoplay timeout id.
     * @type {Number}
     */

    this._call = null;
    /**
     * Depending on the state of the plugin, this variable contains either
     * the start time of the timer or the current timer value if it's
     * paused. Since we start in a paused state we initialize the timer
     * value.
     * @type {Number}
     */

    this._time = 0;
    /**
     * Stores the timeout currently used.
     * @type {Number}
     */

    this._timeout = 0;
    /**
     * Indicates whenever the autoplay is paused.
     * @type {Boolean}
     */

    this._paused = true;
    /**
     * All event handlers.
     * @protected
     * @type {Object}
     */

    this._handlers = {
      'changed.owl.carousel': $.proxy(function (e) {
        if (e.namespace && e.property.name === 'settings') {
          if (this._core.settings.autoplay) {
            this.play();
          } else {
            this.stop();
          }
        } else if (e.namespace && e.property.name === 'position' && this._paused) {
          // Reset the timer. This code is triggered when the position
          // of the carousel was changed through user interaction.
          this._time = 0;
        }
      }, this),
      'initialized.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.autoplay) {
          this.play();
        }
      }, this),
      'play.owl.autoplay': $.proxy(function (e, t, s) {
        if (e.namespace) {
          this.play(t, s);
        }
      }, this),
      'stop.owl.autoplay': $.proxy(function (e) {
        if (e.namespace) {
          this.stop();
        }
      }, this),
      'mouseover.owl.autoplay': $.proxy(function () {
        if (this._core.settings.autoplayHoverPause && this._core.is('rotating')) {
          this.pause();
        }
      }, this),
      'mouseleave.owl.autoplay': $.proxy(function () {
        if (this._core.settings.autoplayHoverPause && this._core.is('rotating')) {
          this.play();
        }
      }, this),
      'touchstart.owl.core': $.proxy(function () {
        if (this._core.settings.autoplayHoverPause && this._core.is('rotating')) {
          this.pause();
        }
      }, this),
      'touchend.owl.core': $.proxy(function () {
        if (this._core.settings.autoplayHoverPause) {
          this.play();
        }
      }, this)
    }; // register event handlers

    this._core.$element.on(this._handlers); // set default options


    this._core.options = $.extend({}, Autoplay.Defaults, this._core.options);
  };
  /**
   * Default options.
   * @public
   */


  Autoplay.Defaults = {
    autoplay: false,
    autoplayTimeout: 5000,
    autoplayHoverPause: false,
    autoplaySpeed: false
  };
  /**
   * Transition to the next slide and set a timeout for the next transition.
   * @private
   * @param {Number} [speed] - The animation speed for the animations.
   */

  Autoplay.prototype._next = function (speed) {
    this._call = window.setTimeout($.proxy(this._next, this, speed), this._timeout * (Math.round(this.read() / this._timeout) + 1) - this.read());

    if (this._core.is('interacting') || document.hidden) {
      return;
    }

    this._core.next(speed || this._core.settings.autoplaySpeed);
  };
  /**
   * Reads the current timer value when the timer is playing.
   * @public
   */


  Autoplay.prototype.read = function () {
    return new Date().getTime() - this._time;
  };
  /**
   * Starts the autoplay.
   * @public
   * @param {Number} [timeout] - The interval before the next animation starts.
   * @param {Number} [speed] - The animation speed for the animations.
   */


  Autoplay.prototype.play = function (timeout, speed) {
    var elapsed;

    if (!this._core.is('rotating')) {
      this._core.enter('rotating');
    }

    timeout = timeout || this._core.settings.autoplayTimeout; // Calculate the elapsed time since the last transition. If the carousel
    // wasn't playing this calculation will yield zero.

    elapsed = Math.min(this._time % (this._timeout || timeout), timeout);

    if (this._paused) {
      // Start the clock.
      this._time = this.read();
      this._paused = false;
    } else {
      // Clear the active timeout to allow replacement.
      window.clearTimeout(this._call);
    } // Adjust the origin of the timer to match the new timeout value.


    this._time += this.read() % timeout - elapsed;
    this._timeout = timeout;
    this._call = window.setTimeout($.proxy(this._next, this, speed), timeout - elapsed);
  };
  /**
   * Stops the autoplay.
   * @public
   */


  Autoplay.prototype.stop = function () {
    if (this._core.is('rotating')) {
      // Reset the clock.
      this._time = 0;
      this._paused = true;
      window.clearTimeout(this._call);

      this._core.leave('rotating');
    }
  };
  /**
   * Pauses the autoplay.
   * @public
   */


  Autoplay.prototype.pause = function () {
    if (this._core.is('rotating') && !this._paused) {
      // Pause the clock.
      this._time = this.read();
      this._paused = true;
      window.clearTimeout(this._call);
    }
  };
  /**
   * Destroys the plugin.
   */


  Autoplay.prototype.destroy = function () {
    var handler, property;
    this.stop();

    for (handler in this._handlers) {
      this._core.$element.off(handler, this._handlers[handler]);
    }

    for (property in Object.getOwnPropertyNames(this)) {
      typeof this[property] != 'function' && (this[property] = null);
    }
  };

  $.fn.owlCarousel.Constructor.Plugins.autoplay = Autoplay;
})(window.Zepto || window.jQuery, window, document);
/**
 * Navigation Plugin
 * @version 2.3.4
 * @author Artus Kolanowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  'use strict';
  /**
   * Creates the navigation plugin.
   * @class The Navigation Plugin
   * @param {Owl} carousel - The Owl Carousel.
   */

  var Navigation = function Navigation(carousel) {
    /**
     * Reference to the core.
     * @protected
     * @type {Owl}
     */
    this._core = carousel;
    /**
     * Indicates whether the plugin is initialized or not.
     * @protected
     * @type {Boolean}
     */

    this._initialized = false;
    /**
     * The current paging indexes.
     * @protected
     * @type {Array}
     */

    this._pages = [];
    /**
     * All DOM elements of the user interface.
     * @protected
     * @type {Object}
     */

    this._controls = {};
    /**
     * Markup for an indicator.
     * @protected
     * @type {Array.<String>}
     */

    this._templates = [];
    /**
     * The carousel element.
     * @type {jQuery}
     */

    this.$element = this._core.$element;
    /**
     * Overridden methods of the carousel.
     * @protected
     * @type {Object}
     */

    this._overrides = {
      next: this._core.next,
      prev: this._core.prev,
      to: this._core.to
    };
    /**
     * All event handlers.
     * @protected
     * @type {Object}
     */

    this._handlers = {
      'prepared.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.dotsData) {
          this._templates.push('<div class="' + this._core.settings.dotClass + '">' + $(e.content).find('[data-dot]').addBack('[data-dot]').attr('data-dot') + '</div>');
        }
      }, this),
      'added.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.dotsData) {
          this._templates.splice(e.position, 0, this._templates.pop());
        }
      }, this),
      'remove.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.dotsData) {
          this._templates.splice(e.position, 1);
        }
      }, this),
      'changed.owl.carousel': $.proxy(function (e) {
        if (e.namespace && e.property.name == 'position') {
          this.draw();
        }
      }, this),
      'initialized.owl.carousel': $.proxy(function (e) {
        if (e.namespace && !this._initialized) {
          this._core.trigger('initialize', null, 'navigation');

          this.initialize();
          this.update();
          this.draw();
          this._initialized = true;

          this._core.trigger('initialized', null, 'navigation');
        }
      }, this),
      'refreshed.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._initialized) {
          this._core.trigger('refresh', null, 'navigation');

          this.update();
          this.draw();

          this._core.trigger('refreshed', null, 'navigation');
        }
      }, this)
    }; // set default options

    this._core.options = $.extend({}, Navigation.Defaults, this._core.options); // register event handlers

    this.$element.on(this._handlers);
  };
  /**
   * Default options.
   * @public
   * @todo Rename `slideBy` to `navBy`
   */


  Navigation.Defaults = {
    nav: false,
    navText: ['<span aria-label="' + 'Previous' + '">&#x2039;</span>', '<span aria-label="' + 'Next' + '">&#x203a;</span>'],
    navSpeed: false,
    navElement: 'button type="button" role="presentation"',
    navContainer: false,
    navContainerClass: 'owl-nav',
    navClass: ['owl-prev', 'owl-next'],
    slideBy: 1,
    dotClass: 'owl-dot',
    dotsClass: 'owl-dots',
    dots: true,
    dotsEach: false,
    dotsData: false,
    dotsSpeed: false,
    dotsContainer: false
  };
  /**
   * Initializes the layout of the plugin and extends the carousel.
   * @protected
   */

  Navigation.prototype.initialize = function () {
    var override,
        settings = this._core.settings; // create DOM structure for relative navigation

    this._controls.$relative = (settings.navContainer ? $(settings.navContainer) : $('<div>').addClass(settings.navContainerClass).appendTo(this.$element)).addClass('disabled');
    this._controls.$previous = $('<' + settings.navElement + '>').addClass(settings.navClass[0]).html(settings.navText[0]).prependTo(this._controls.$relative).on('click', $.proxy(function (e) {
      this.prev(settings.navSpeed);
    }, this));
    this._controls.$next = $('<' + settings.navElement + '>').addClass(settings.navClass[1]).html(settings.navText[1]).appendTo(this._controls.$relative).on('click', $.proxy(function (e) {
      this.next(settings.navSpeed);
    }, this)); // create DOM structure for absolute navigation

    if (!settings.dotsData) {
      this._templates = [$('<button role="button">').addClass(settings.dotClass).append($('<span>')).prop('outerHTML')];
    }

    this._controls.$absolute = (settings.dotsContainer ? $(settings.dotsContainer) : $('<div>').addClass(settings.dotsClass).appendTo(this.$element)).addClass('disabled');

    this._controls.$absolute.on('click', 'button', $.proxy(function (e) {
      var index = $(e.target).parent().is(this._controls.$absolute) ? $(e.target).index() : $(e.target).parent().index();
      e.preventDefault();
      this.to(index, settings.dotsSpeed);
    }, this));
    /*$el.on('focusin', function() {
    	$(document).off(".carousel");
    			$(document).on('keydown.carousel', function(e) {
    		if(e.keyCode == 37) {
    			$el.trigger('prev.owl')
    		}
    		if(e.keyCode == 39) {
    			$el.trigger('next.owl')
    		}
    	});
    });*/
    // override public methods of the carousel


    for (override in this._overrides) {
      this._core[override] = $.proxy(this[override], this);
    }
  };
  /**
   * Destroys the plugin.
   * @protected
   */


  Navigation.prototype.destroy = function () {
    var handler, control, property, override, settings;
    settings = this._core.settings;

    for (handler in this._handlers) {
      this.$element.off(handler, this._handlers[handler]);
    }

    for (control in this._controls) {
      if (control === '$relative' && settings.navContainer) {
        this._controls[control].html('');
      } else {
        this._controls[control].remove();
      }
    }

    for (override in this.overides) {
      this._core[override] = this._overrides[override];
    }

    for (property in Object.getOwnPropertyNames(this)) {
      typeof this[property] != 'function' && (this[property] = null);
    }
  };
  /**
   * Updates the internal state.
   * @protected
   */


  Navigation.prototype.update = function () {
    var i,
        j,
        k,
        lower = this._core.clones().length / 2,
        upper = lower + this._core.items().length,
        maximum = this._core.maximum(true),
        settings = this._core.settings,
        size = settings.center || settings.autoWidth || settings.dotsData ? 1 : settings.dotsEach || settings.items;

    if (settings.slideBy !== 'page') {
      settings.slideBy = Math.min(settings.slideBy, settings.items);
    }

    if (settings.dots || settings.slideBy == 'page') {
      this._pages = [];

      for (i = lower, j = 0, k = 0; i < upper; i++) {
        if (j >= size || j === 0) {
          this._pages.push({
            start: Math.min(maximum, i - lower),
            end: i - lower + size - 1
          });

          if (Math.min(maximum, i - lower) === maximum) {
            break;
          }

          j = 0, ++k;
        }

        j += this._core.mergers(this._core.relative(i));
      }
    }
  };
  /**
   * Draws the user interface.
   * @todo The option `dotsData` wont work.
   * @protected
   */


  Navigation.prototype.draw = function () {
    var difference,
        settings = this._core.settings,
        disabled = this._core.items().length <= settings.items,
        index = this._core.relative(this._core.current()),
        loop = settings.loop || settings.rewind;

    this._controls.$relative.toggleClass('disabled', !settings.nav || disabled);

    if (settings.nav) {
      this._controls.$previous.toggleClass('disabled', !loop && index <= this._core.minimum(true));

      this._controls.$next.toggleClass('disabled', !loop && index >= this._core.maximum(true));
    }

    this._controls.$absolute.toggleClass('disabled', !settings.dots || disabled);

    if (settings.dots) {
      difference = this._pages.length - this._controls.$absolute.children().length;

      if (settings.dotsData && difference !== 0) {
        this._controls.$absolute.html(this._templates.join(''));
      } else if (difference > 0) {
        this._controls.$absolute.append(new Array(difference + 1).join(this._templates[0]));
      } else if (difference < 0) {
        this._controls.$absolute.children().slice(difference).remove();
      }

      this._controls.$absolute.find('.active').removeClass('active');

      this._controls.$absolute.children().eq($.inArray(this.current(), this._pages)).addClass('active');
    }
  };
  /**
   * Extends event data.
   * @protected
   * @param {Event} event - The event object which gets thrown.
   */


  Navigation.prototype.onTrigger = function (event) {
    var settings = this._core.settings;
    event.page = {
      index: $.inArray(this.current(), this._pages),
      count: this._pages.length,
      size: settings && (settings.center || settings.autoWidth || settings.dotsData ? 1 : settings.dotsEach || settings.items)
    };
  };
  /**
   * Gets the current page position of the carousel.
   * @protected
   * @returns {Number}
   */


  Navigation.prototype.current = function () {
    var current = this._core.relative(this._core.current());

    return $.grep(this._pages, $.proxy(function (page, index) {
      return page.start <= current && page.end >= current;
    }, this)).pop();
  };
  /**
   * Gets the current succesor/predecessor position.
   * @protected
   * @returns {Number}
   */


  Navigation.prototype.getPosition = function (successor) {
    var position,
        length,
        settings = this._core.settings;

    if (settings.slideBy == 'page') {
      position = $.inArray(this.current(), this._pages);
      length = this._pages.length;
      successor ? ++position : --position;
      position = this._pages[(position % length + length) % length].start;
    } else {
      position = this._core.relative(this._core.current());
      length = this._core.items().length;
      successor ? position += settings.slideBy : position -= settings.slideBy;
    }

    return position;
  };
  /**
   * Slides to the next item or page.
   * @public
   * @param {Number} [speed=false] - The time in milliseconds for the transition.
   */


  Navigation.prototype.next = function (speed) {
    $.proxy(this._overrides.to, this._core)(this.getPosition(true), speed);
  };
  /**
   * Slides to the previous item or page.
   * @public
   * @param {Number} [speed=false] - The time in milliseconds for the transition.
   */


  Navigation.prototype.prev = function (speed) {
    $.proxy(this._overrides.to, this._core)(this.getPosition(false), speed);
  };
  /**
   * Slides to the specified item or page.
   * @public
   * @param {Number} position - The position of the item or page.
   * @param {Number} [speed] - The time in milliseconds for the transition.
   * @param {Boolean} [standard=false] - Whether to use the standard behaviour or not.
   */


  Navigation.prototype.to = function (position, speed, standard) {
    var length;

    if (!standard && this._pages.length) {
      length = this._pages.length;
      $.proxy(this._overrides.to, this._core)(this._pages[(position % length + length) % length].start, speed);
    } else {
      $.proxy(this._overrides.to, this._core)(position, speed);
    }
  };

  $.fn.owlCarousel.Constructor.Plugins.Navigation = Navigation;
})(window.Zepto || window.jQuery, window, document);
/**
 * Hash Plugin
 * @version 2.3.4
 * @author Artus Kolanowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  'use strict';
  /**
   * Creates the hash plugin.
   * @class The Hash Plugin
   * @param {Owl} carousel - The Owl Carousel
   */

  var Hash = function Hash(carousel) {
    /**
     * Reference to the core.
     * @protected
     * @type {Owl}
     */
    this._core = carousel;
    /**
     * Hash index for the items.
     * @protected
     * @type {Object}
     */

    this._hashes = {};
    /**
     * The carousel element.
     * @type {jQuery}
     */

    this.$element = this._core.$element;
    /**
     * All event handlers.
     * @protected
     * @type {Object}
     */

    this._handlers = {
      'initialized.owl.carousel': $.proxy(function (e) {
        if (e.namespace && this._core.settings.startPosition === 'URLHash') {
          $(window).trigger('hashchange.owl.navigation');
        }
      }, this),
      'prepared.owl.carousel': $.proxy(function (e) {
        if (e.namespace) {
          var hash = $(e.content).find('[data-hash]').addBack('[data-hash]').attr('data-hash');

          if (!hash) {
            return;
          }

          this._hashes[hash] = e.content;
        }
      }, this),
      'changed.owl.carousel': $.proxy(function (e) {
        if (e.namespace && e.property.name === 'position') {
          var current = this._core.items(this._core.relative(this._core.current())),
              hash = $.map(this._hashes, function (item, hash) {
            return item === current ? hash : null;
          }).join();

          if (!hash || window.location.hash.slice(1) === hash) {
            return;
          }

          window.location.hash = hash;
        }
      }, this)
    }; // set default options

    this._core.options = $.extend({}, Hash.Defaults, this._core.options); // register the event handlers

    this.$element.on(this._handlers); // register event listener for hash navigation

    $(window).on('hashchange.owl.navigation', $.proxy(function (e) {
      var hash = window.location.hash.substring(1),
          items = this._core.$stage.children(),
          position = this._hashes[hash] && items.index(this._hashes[hash]);

      if (position === undefined || position === this._core.current()) {
        return;
      }

      this._core.to(this._core.relative(position), false, true);
    }, this));
  };
  /**
   * Default options.
   * @public
   */


  Hash.Defaults = {
    URLhashListener: false
  };
  /**
   * Destroys the plugin.
   * @public
   */

  Hash.prototype.destroy = function () {
    var handler, property;
    $(window).off('hashchange.owl.navigation');

    for (handler in this._handlers) {
      this._core.$element.off(handler, this._handlers[handler]);
    }

    for (property in Object.getOwnPropertyNames(this)) {
      typeof this[property] != 'function' && (this[property] = null);
    }
  };

  $.fn.owlCarousel.Constructor.Plugins.Hash = Hash;
})(window.Zepto || window.jQuery, window, document);
/**
 * Support Plugin
 *
 * @version 2.3.4
 * @author Vivid Planet Software GmbH
 * @author Artus Kolanowski
 * @author David Deutsch
 * @license The MIT License (MIT)
 */


;

(function ($, window, document, undefined) {
  var style = $('<support>').get(0).style,
      prefixes = 'Webkit Moz O ms'.split(' '),
      events = {
    transition: {
      end: {
        WebkitTransition: 'webkitTransitionEnd',
        MozTransition: 'transitionend',
        OTransition: 'oTransitionEnd',
        transition: 'transitionend'
      }
    },
    animation: {
      end: {
        WebkitAnimation: 'webkitAnimationEnd',
        MozAnimation: 'animationend',
        OAnimation: 'oAnimationEnd',
        animation: 'animationend'
      }
    }
  },
      tests = {
    csstransforms: function csstransforms() {
      return !!test('transform');
    },
    csstransforms3d: function csstransforms3d() {
      return !!test('perspective');
    },
    csstransitions: function csstransitions() {
      return !!test('transition');
    },
    cssanimations: function cssanimations() {
      return !!test('animation');
    }
  };

  function test(property, prefixed) {
    var result = false,
        upper = property.charAt(0).toUpperCase() + property.slice(1);
    $.each((property + ' ' + prefixes.join(upper + ' ') + upper).split(' '), function (i, property) {
      if (style[property] !== undefined) {
        result = prefixed ? property : true;
        return false;
      }
    });
    return result;
  }

  function prefixed(property) {
    return test(property, true);
  }

  if (tests.csstransitions()) {
    /* jshint -W053 */
    $.support.transition = new String(prefixed('transition'));
    $.support.transition.end = events.transition.end[$.support.transition];
  }

  if (tests.cssanimations()) {
    /* jshint -W053 */
    $.support.animation = new String(prefixed('animation'));
    $.support.animation.end = events.animation.end[$.support.animation];
  }

  if (tests.csstransforms()) {
    /* jshint -W053 */
    $.support.transform = new String(prefixed('transform'));
    $.support.transform3d = tests.csstransforms3d();
  }
})(window.Zepto || window.jQuery, window, document);
"use strict";

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

/*! Hammer.JS - v2.0.8 - 2016-04-23
 * http://hammerjs.github.io/
 *
 * Copyright (c) 2016 Jorik Tangelder;
 * Licensed under the MIT license */
!function (a, b, c, d) {
  "use strict";

  function e(a, b, c) {
    return setTimeout(j(a, c), b);
  }

  function f(a, b, c) {
    return Array.isArray(a) ? (g(a, c[b], c), !0) : !1;
  }

  function g(a, b, c) {
    var e;
    if (a) if (a.forEach) a.forEach(b, c);else if (a.length !== d) for (e = 0; e < a.length;) {
      b.call(c, a[e], e, a), e++;
    } else for (e in a) {
      a.hasOwnProperty(e) && b.call(c, a[e], e, a);
    }
  }

  function h(b, c, d) {
    var e = "DEPRECATED METHOD: " + c + "\n" + d + " AT \n";
    return function () {
      var c = new Error("get-stack-trace"),
          d = c && c.stack ? c.stack.replace(/^[^\(]+?[\n$]/gm, "").replace(/^\s+at\s+/gm, "").replace(/^Object.<anonymous>\s*\(/gm, "{anonymous}()@") : "Unknown Stack Trace",
          f = a.console && (a.console.warn || a.console.log);
      return f && f.call(a.console, e, d), b.apply(this, arguments);
    };
  }

  function i(a, b, c) {
    var d,
        e = b.prototype;
    d = a.prototype = Object.create(e), d.constructor = a, d._super = e, c && la(d, c);
  }

  function j(a, b) {
    return function () {
      return a.apply(b, arguments);
    };
  }

  function k(a, b) {
    return _typeof(a) == oa ? a.apply(b ? b[0] || d : d, b) : a;
  }

  function l(a, b) {
    return a === d ? b : a;
  }

  function m(a, b, c) {
    g(q(b), function (b) {
      a.addEventListener(b, c, !1);
    });
  }

  function n(a, b, c) {
    g(q(b), function (b) {
      a.removeEventListener(b, c, !1);
    });
  }

  function o(a, b) {
    for (; a;) {
      if (a == b) return !0;
      a = a.parentNode;
    }

    return !1;
  }

  function p(a, b) {
    return a.indexOf(b) > -1;
  }

  function q(a) {
    return a.trim().split(/\s+/g);
  }

  function r(a, b, c) {
    if (a.indexOf && !c) return a.indexOf(b);

    for (var d = 0; d < a.length;) {
      if (c && a[d][c] == b || !c && a[d] === b) return d;
      d++;
    }

    return -1;
  }

  function s(a) {
    return Array.prototype.slice.call(a, 0);
  }

  function t(a, b, c) {
    for (var d = [], e = [], f = 0; f < a.length;) {
      var g = b ? a[f][b] : a[f];
      r(e, g) < 0 && d.push(a[f]), e[f] = g, f++;
    }

    return c && (d = b ? d.sort(function (a, c) {
      return a[b] > c[b];
    }) : d.sort()), d;
  }

  function u(a, b) {
    for (var c, e, f = b[0].toUpperCase() + b.slice(1), g = 0; g < ma.length;) {
      if (c = ma[g], e = c ? c + f : b, e in a) return e;
      g++;
    }

    return d;
  }

  function v() {
    return ua++;
  }

  function w(b) {
    var c = b.ownerDocument || b;
    return c.defaultView || c.parentWindow || a;
  }

  function x(a, b) {
    var c = this;
    this.manager = a, this.callback = b, this.element = a.element, this.target = a.options.inputTarget, this.domHandler = function (b) {
      k(a.options.enable, [a]) && c.handler(b);
    }, this.init();
  }

  function y(a) {
    var b,
        c = a.options.inputClass;
    return new (b = c ? c : xa ? M : ya ? P : wa ? R : L)(a, z);
  }

  function z(a, b, c) {
    var d = c.pointers.length,
        e = c.changedPointers.length,
        f = b & Ea && d - e === 0,
        g = b & (Ga | Ha) && d - e === 0;
    c.isFirst = !!f, c.isFinal = !!g, f && (a.session = {}), c.eventType = b, A(a, c), a.emit("hammer.input", c), a.recognize(c), a.session.prevInput = c;
  }

  function A(a, b) {
    var c = a.session,
        d = b.pointers,
        e = d.length;
    c.firstInput || (c.firstInput = D(b)), e > 1 && !c.firstMultiple ? c.firstMultiple = D(b) : 1 === e && (c.firstMultiple = !1);
    var f = c.firstInput,
        g = c.firstMultiple,
        h = g ? g.center : f.center,
        i = b.center = E(d);
    b.timeStamp = ra(), b.deltaTime = b.timeStamp - f.timeStamp, b.angle = I(h, i), b.distance = H(h, i), B(c, b), b.offsetDirection = G(b.deltaX, b.deltaY);
    var j = F(b.deltaTime, b.deltaX, b.deltaY);
    b.overallVelocityX = j.x, b.overallVelocityY = j.y, b.overallVelocity = qa(j.x) > qa(j.y) ? j.x : j.y, b.scale = g ? K(g.pointers, d) : 1, b.rotation = g ? J(g.pointers, d) : 0, b.maxPointers = c.prevInput ? b.pointers.length > c.prevInput.maxPointers ? b.pointers.length : c.prevInput.maxPointers : b.pointers.length, C(c, b);
    var k = a.element;
    o(b.srcEvent.target, k) && (k = b.srcEvent.target), b.target = k;
  }

  function B(a, b) {
    var c = b.center,
        d = a.offsetDelta || {},
        e = a.prevDelta || {},
        f = a.prevInput || {};
    b.eventType !== Ea && f.eventType !== Ga || (e = a.prevDelta = {
      x: f.deltaX || 0,
      y: f.deltaY || 0
    }, d = a.offsetDelta = {
      x: c.x,
      y: c.y
    }), b.deltaX = e.x + (c.x - d.x), b.deltaY = e.y + (c.y - d.y);
  }

  function C(a, b) {
    var c,
        e,
        f,
        g,
        h = a.lastInterval || b,
        i = b.timeStamp - h.timeStamp;

    if (b.eventType != Ha && (i > Da || h.velocity === d)) {
      var j = b.deltaX - h.deltaX,
          k = b.deltaY - h.deltaY,
          l = F(i, j, k);
      e = l.x, f = l.y, c = qa(l.x) > qa(l.y) ? l.x : l.y, g = G(j, k), a.lastInterval = b;
    } else c = h.velocity, e = h.velocityX, f = h.velocityY, g = h.direction;

    b.velocity = c, b.velocityX = e, b.velocityY = f, b.direction = g;
  }

  function D(a) {
    for (var b = [], c = 0; c < a.pointers.length;) {
      b[c] = {
        clientX: pa(a.pointers[c].clientX),
        clientY: pa(a.pointers[c].clientY)
      }, c++;
    }

    return {
      timeStamp: ra(),
      pointers: b,
      center: E(b),
      deltaX: a.deltaX,
      deltaY: a.deltaY
    };
  }

  function E(a) {
    var b = a.length;
    if (1 === b) return {
      x: pa(a[0].clientX),
      y: pa(a[0].clientY)
    };

    for (var c = 0, d = 0, e = 0; b > e;) {
      c += a[e].clientX, d += a[e].clientY, e++;
    }

    return {
      x: pa(c / b),
      y: pa(d / b)
    };
  }

  function F(a, b, c) {
    return {
      x: b / a || 0,
      y: c / a || 0
    };
  }

  function G(a, b) {
    return a === b ? Ia : qa(a) >= qa(b) ? 0 > a ? Ja : Ka : 0 > b ? La : Ma;
  }

  function H(a, b, c) {
    c || (c = Qa);
    var d = b[c[0]] - a[c[0]],
        e = b[c[1]] - a[c[1]];
    return Math.sqrt(d * d + e * e);
  }

  function I(a, b, c) {
    c || (c = Qa);
    var d = b[c[0]] - a[c[0]],
        e = b[c[1]] - a[c[1]];
    return 180 * Math.atan2(e, d) / Math.PI;
  }

  function J(a, b) {
    return I(b[1], b[0], Ra) + I(a[1], a[0], Ra);
  }

  function K(a, b) {
    return H(b[0], b[1], Ra) / H(a[0], a[1], Ra);
  }

  function L() {
    this.evEl = Ta, this.evWin = Ua, this.pressed = !1, x.apply(this, arguments);
  }

  function M() {
    this.evEl = Xa, this.evWin = Ya, x.apply(this, arguments), this.store = this.manager.session.pointerEvents = [];
  }

  function N() {
    this.evTarget = $a, this.evWin = _a, this.started = !1, x.apply(this, arguments);
  }

  function O(a, b) {
    var c = s(a.touches),
        d = s(a.changedTouches);
    return b & (Ga | Ha) && (c = t(c.concat(d), "identifier", !0)), [c, d];
  }

  function P() {
    this.evTarget = bb, this.targetIds = {}, x.apply(this, arguments);
  }

  function Q(a, b) {
    var c = s(a.touches),
        d = this.targetIds;
    if (b & (Ea | Fa) && 1 === c.length) return d[c[0].identifier] = !0, [c, c];
    var e,
        f,
        g = s(a.changedTouches),
        h = [],
        i = this.target;
    if (f = c.filter(function (a) {
      return o(a.target, i);
    }), b === Ea) for (e = 0; e < f.length;) {
      d[f[e].identifier] = !0, e++;
    }

    for (e = 0; e < g.length;) {
      d[g[e].identifier] && h.push(g[e]), b & (Ga | Ha) && delete d[g[e].identifier], e++;
    }

    return h.length ? [t(f.concat(h), "identifier", !0), h] : void 0;
  }

  function R() {
    x.apply(this, arguments);
    var a = j(this.handler, this);
    this.touch = new P(this.manager, a), this.mouse = new L(this.manager, a), this.primaryTouch = null, this.lastTouches = [];
  }

  function S(a, b) {
    a & Ea ? (this.primaryTouch = b.changedPointers[0].identifier, T.call(this, b)) : a & (Ga | Ha) && T.call(this, b);
  }

  function T(a) {
    var b = a.changedPointers[0];

    if (b.identifier === this.primaryTouch) {
      var c = {
        x: b.clientX,
        y: b.clientY
      };
      this.lastTouches.push(c);

      var d = this.lastTouches,
          e = function e() {
        var a = d.indexOf(c);
        a > -1 && d.splice(a, 1);
      };

      setTimeout(e, cb);
    }
  }

  function U(a) {
    for (var b = a.srcEvent.clientX, c = a.srcEvent.clientY, d = 0; d < this.lastTouches.length; d++) {
      var e = this.lastTouches[d],
          f = Math.abs(b - e.x),
          g = Math.abs(c - e.y);
      if (db >= f && db >= g) return !0;
    }

    return !1;
  }

  function V(a, b) {
    this.manager = a, this.set(b);
  }

  function W(a) {
    if (p(a, jb)) return jb;
    var b = p(a, kb),
        c = p(a, lb);
    return b && c ? jb : b || c ? b ? kb : lb : p(a, ib) ? ib : hb;
  }

  function X() {
    if (!fb) return !1;
    var b = {},
        c = a.CSS && a.CSS.supports;
    return ["auto", "manipulation", "pan-y", "pan-x", "pan-x pan-y", "none"].forEach(function (d) {
      b[d] = c ? a.CSS.supports("touch-action", d) : !0;
    }), b;
  }

  function Y(a) {
    this.options = la({}, this.defaults, a || {}), this.id = v(), this.manager = null, this.options.enable = l(this.options.enable, !0), this.state = nb, this.simultaneous = {}, this.requireFail = [];
  }

  function Z(a) {
    return a & sb ? "cancel" : a & qb ? "end" : a & pb ? "move" : a & ob ? "start" : "";
  }

  function $(a) {
    return a == Ma ? "down" : a == La ? "up" : a == Ja ? "left" : a == Ka ? "right" : "";
  }

  function _(a, b) {
    var c = b.manager;
    return c ? c.get(a) : a;
  }

  function aa() {
    Y.apply(this, arguments);
  }

  function ba() {
    aa.apply(this, arguments), this.pX = null, this.pY = null;
  }

  function ca() {
    aa.apply(this, arguments);
  }

  function da() {
    Y.apply(this, arguments), this._timer = null, this._input = null;
  }

  function ea() {
    aa.apply(this, arguments);
  }

  function fa() {
    aa.apply(this, arguments);
  }

  function ga() {
    Y.apply(this, arguments), this.pTime = !1, this.pCenter = !1, this._timer = null, this._input = null, this.count = 0;
  }

  function ha(a, b) {
    return b = b || {}, b.recognizers = l(b.recognizers, ha.defaults.preset), new ia(a, b);
  }

  function ia(a, b) {
    this.options = la({}, ha.defaults, b || {}), this.options.inputTarget = this.options.inputTarget || a, this.handlers = {}, this.session = {}, this.recognizers = [], this.oldCssProps = {}, this.element = a, this.input = y(this), this.touchAction = new V(this, this.options.touchAction), ja(this, !0), g(this.options.recognizers, function (a) {
      var b = this.add(new a[0](a[1]));
      a[2] && b.recognizeWith(a[2]), a[3] && b.requireFailure(a[3]);
    }, this);
  }

  function ja(a, b) {
    var c = a.element;

    if (c.style) {
      var d;
      g(a.options.cssProps, function (e, f) {
        d = u(c.style, f), b ? (a.oldCssProps[d] = c.style[d], c.style[d] = e) : c.style[d] = a.oldCssProps[d] || "";
      }), b || (a.oldCssProps = {});
    }
  }

  function ka(a, c) {
    var d = b.createEvent("Event");
    d.initEvent(a, !0, !0), d.gesture = c, c.target.dispatchEvent(d);
  }

  var la,
      ma = ["", "webkit", "Moz", "MS", "ms", "o"],
      na = b.createElement("div"),
      oa = "function",
      pa = Math.round,
      qa = Math.abs,
      ra = Date.now;
  la = "function" != typeof Object.assign ? function (a) {
    if (a === d || null === a) throw new TypeError("Cannot convert undefined or null to object");

    for (var b = Object(a), c = 1; c < arguments.length; c++) {
      var e = arguments[c];
      if (e !== d && null !== e) for (var f in e) {
        e.hasOwnProperty(f) && (b[f] = e[f]);
      }
    }

    return b;
  } : Object.assign;
  var sa = h(function (a, b, c) {
    for (var e = Object.keys(b), f = 0; f < e.length;) {
      (!c || c && a[e[f]] === d) && (a[e[f]] = b[e[f]]), f++;
    }

    return a;
  }, "extend", "Use `assign`."),
      ta = h(function (a, b) {
    return sa(a, b, !0);
  }, "merge", "Use `assign`."),
      ua = 1,
      va = /mobile|tablet|ip(ad|hone|od)|android/i,
      wa = "ontouchstart" in a,
      xa = u(a, "PointerEvent") !== d,
      ya = wa && va.test(navigator.userAgent),
      za = "touch",
      Aa = "pen",
      Ba = "mouse",
      Ca = "kinect",
      Da = 25,
      Ea = 1,
      Fa = 2,
      Ga = 4,
      Ha = 8,
      Ia = 1,
      Ja = 2,
      Ka = 4,
      La = 8,
      Ma = 16,
      Na = Ja | Ka,
      Oa = La | Ma,
      Pa = Na | Oa,
      Qa = ["x", "y"],
      Ra = ["clientX", "clientY"];
  x.prototype = {
    handler: function handler() {},
    init: function init() {
      this.evEl && m(this.element, this.evEl, this.domHandler), this.evTarget && m(this.target, this.evTarget, this.domHandler), this.evWin && m(w(this.element), this.evWin, this.domHandler);
    },
    destroy: function destroy() {
      this.evEl && n(this.element, this.evEl, this.domHandler), this.evTarget && n(this.target, this.evTarget, this.domHandler), this.evWin && n(w(this.element), this.evWin, this.domHandler);
    }
  };
  var Sa = {
    mousedown: Ea,
    mousemove: Fa,
    mouseup: Ga
  },
      Ta = "mousedown",
      Ua = "mousemove mouseup";
  i(L, x, {
    handler: function handler(a) {
      var b = Sa[a.type];
      b & Ea && 0 === a.button && (this.pressed = !0), b & Fa && 1 !== a.which && (b = Ga), this.pressed && (b & Ga && (this.pressed = !1), this.callback(this.manager, b, {
        pointers: [a],
        changedPointers: [a],
        pointerType: Ba,
        srcEvent: a
      }));
    }
  });
  var Va = {
    pointerdown: Ea,
    pointermove: Fa,
    pointerup: Ga,
    pointercancel: Ha,
    pointerout: Ha
  },
      Wa = {
    2: za,
    3: Aa,
    4: Ba,
    5: Ca
  },
      Xa = "pointerdown",
      Ya = "pointermove pointerup pointercancel";
  a.MSPointerEvent && !a.PointerEvent && (Xa = "MSPointerDown", Ya = "MSPointerMove MSPointerUp MSPointerCancel"), i(M, x, {
    handler: function handler(a) {
      var b = this.store,
          c = !1,
          d = a.type.toLowerCase().replace("ms", ""),
          e = Va[d],
          f = Wa[a.pointerType] || a.pointerType,
          g = f == za,
          h = r(b, a.pointerId, "pointerId");
      e & Ea && (0 === a.button || g) ? 0 > h && (b.push(a), h = b.length - 1) : e & (Ga | Ha) && (c = !0), 0 > h || (b[h] = a, this.callback(this.manager, e, {
        pointers: b,
        changedPointers: [a],
        pointerType: f,
        srcEvent: a
      }), c && b.splice(h, 1));
    }
  });
  var Za = {
    touchstart: Ea,
    touchmove: Fa,
    touchend: Ga,
    touchcancel: Ha
  },
      $a = "touchstart",
      _a = "touchstart touchmove touchend touchcancel";
  i(N, x, {
    handler: function handler(a) {
      var b = Za[a.type];

      if (b === Ea && (this.started = !0), this.started) {
        var c = O.call(this, a, b);
        b & (Ga | Ha) && c[0].length - c[1].length === 0 && (this.started = !1), this.callback(this.manager, b, {
          pointers: c[0],
          changedPointers: c[1],
          pointerType: za,
          srcEvent: a
        });
      }
    }
  });
  var ab = {
    touchstart: Ea,
    touchmove: Fa,
    touchend: Ga,
    touchcancel: Ha
  },
      bb = "touchstart touchmove touchend touchcancel";
  i(P, x, {
    handler: function handler(a) {
      var b = ab[a.type],
          c = Q.call(this, a, b);
      c && this.callback(this.manager, b, {
        pointers: c[0],
        changedPointers: c[1],
        pointerType: za,
        srcEvent: a
      });
    }
  });
  var cb = 2500,
      db = 25;
  i(R, x, {
    handler: function handler(a, b, c) {
      var d = c.pointerType == za,
          e = c.pointerType == Ba;

      if (!(e && c.sourceCapabilities && c.sourceCapabilities.firesTouchEvents)) {
        if (d) S.call(this, b, c);else if (e && U.call(this, c)) return;
        this.callback(a, b, c);
      }
    },
    destroy: function destroy() {
      this.touch.destroy(), this.mouse.destroy();
    }
  });
  var eb = u(na.style, "touchAction"),
      fb = eb !== d,
      gb = "compute",
      hb = "auto",
      ib = "manipulation",
      jb = "none",
      kb = "pan-x",
      lb = "pan-y",
      mb = X();
  V.prototype = {
    set: function set(a) {
      a == gb && (a = this.compute()), fb && this.manager.element.style && mb[a] && (this.manager.element.style[eb] = a), this.actions = a.toLowerCase().trim();
    },
    update: function update() {
      this.set(this.manager.options.touchAction);
    },
    compute: function compute() {
      var a = [];
      return g(this.manager.recognizers, function (b) {
        k(b.options.enable, [b]) && (a = a.concat(b.getTouchAction()));
      }), W(a.join(" "));
    },
    preventDefaults: function preventDefaults(a) {
      var b = a.srcEvent,
          c = a.offsetDirection;
      if (this.manager.session.prevented) return void b.preventDefault();
      var d = this.actions,
          e = p(d, jb) && !mb[jb],
          f = p(d, lb) && !mb[lb],
          g = p(d, kb) && !mb[kb];

      if (e) {
        var h = 1 === a.pointers.length,
            i = a.distance < 2,
            j = a.deltaTime < 250;
        if (h && i && j) return;
      }

      return g && f ? void 0 : e || f && c & Na || g && c & Oa ? this.preventSrc(b) : void 0;
    },
    preventSrc: function preventSrc(a) {
      this.manager.session.prevented = !0, a.preventDefault();
    }
  };
  var nb = 1,
      ob = 2,
      pb = 4,
      qb = 8,
      rb = qb,
      sb = 16,
      tb = 32;
  Y.prototype = {
    defaults: {},
    set: function set(a) {
      return la(this.options, a), this.manager && this.manager.touchAction.update(), this;
    },
    recognizeWith: function recognizeWith(a) {
      if (f(a, "recognizeWith", this)) return this;
      var b = this.simultaneous;
      return a = _(a, this), b[a.id] || (b[a.id] = a, a.recognizeWith(this)), this;
    },
    dropRecognizeWith: function dropRecognizeWith(a) {
      return f(a, "dropRecognizeWith", this) ? this : (a = _(a, this), delete this.simultaneous[a.id], this);
    },
    requireFailure: function requireFailure(a) {
      if (f(a, "requireFailure", this)) return this;
      var b = this.requireFail;
      return a = _(a, this), -1 === r(b, a) && (b.push(a), a.requireFailure(this)), this;
    },
    dropRequireFailure: function dropRequireFailure(a) {
      if (f(a, "dropRequireFailure", this)) return this;
      a = _(a, this);
      var b = r(this.requireFail, a);
      return b > -1 && this.requireFail.splice(b, 1), this;
    },
    hasRequireFailures: function hasRequireFailures() {
      return this.requireFail.length > 0;
    },
    canRecognizeWith: function canRecognizeWith(a) {
      return !!this.simultaneous[a.id];
    },
    emit: function emit(a) {
      function b(b) {
        c.manager.emit(b, a);
      }

      var c = this,
          d = this.state;
      qb > d && b(c.options.event + Z(d)), b(c.options.event), a.additionalEvent && b(a.additionalEvent), d >= qb && b(c.options.event + Z(d));
    },
    tryEmit: function tryEmit(a) {
      return this.canEmit() ? this.emit(a) : void (this.state = tb);
    },
    canEmit: function canEmit() {
      for (var a = 0; a < this.requireFail.length;) {
        if (!(this.requireFail[a].state & (tb | nb))) return !1;
        a++;
      }

      return !0;
    },
    recognize: function recognize(a) {
      var b = la({}, a);
      return k(this.options.enable, [this, b]) ? (this.state & (rb | sb | tb) && (this.state = nb), this.state = this.process(b), void (this.state & (ob | pb | qb | sb) && this.tryEmit(b))) : (this.reset(), void (this.state = tb));
    },
    process: function process(a) {},
    getTouchAction: function getTouchAction() {},
    reset: function reset() {}
  }, i(aa, Y, {
    defaults: {
      pointers: 1
    },
    attrTest: function attrTest(a) {
      var b = this.options.pointers;
      return 0 === b || a.pointers.length === b;
    },
    process: function process(a) {
      var b = this.state,
          c = a.eventType,
          d = b & (ob | pb),
          e = this.attrTest(a);
      return d && (c & Ha || !e) ? b | sb : d || e ? c & Ga ? b | qb : b & ob ? b | pb : ob : tb;
    }
  }), i(ba, aa, {
    defaults: {
      event: "pan",
      threshold: 10,
      pointers: 1,
      direction: Pa
    },
    getTouchAction: function getTouchAction() {
      var a = this.options.direction,
          b = [];
      return a & Na && b.push(lb), a & Oa && b.push(kb), b;
    },
    directionTest: function directionTest(a) {
      var b = this.options,
          c = !0,
          d = a.distance,
          e = a.direction,
          f = a.deltaX,
          g = a.deltaY;
      return e & b.direction || (b.direction & Na ? (e = 0 === f ? Ia : 0 > f ? Ja : Ka, c = f != this.pX, d = Math.abs(a.deltaX)) : (e = 0 === g ? Ia : 0 > g ? La : Ma, c = g != this.pY, d = Math.abs(a.deltaY))), a.direction = e, c && d > b.threshold && e & b.direction;
    },
    attrTest: function attrTest(a) {
      return aa.prototype.attrTest.call(this, a) && (this.state & ob || !(this.state & ob) && this.directionTest(a));
    },
    emit: function emit(a) {
      this.pX = a.deltaX, this.pY = a.deltaY;
      var b = $(a.direction);
      b && (a.additionalEvent = this.options.event + b), this._super.emit.call(this, a);
    }
  }), i(ca, aa, {
    defaults: {
      event: "pinch",
      threshold: 0,
      pointers: 2
    },
    getTouchAction: function getTouchAction() {
      return [jb];
    },
    attrTest: function attrTest(a) {
      return this._super.attrTest.call(this, a) && (Math.abs(a.scale - 1) > this.options.threshold || this.state & ob);
    },
    emit: function emit(a) {
      if (1 !== a.scale) {
        var b = a.scale < 1 ? "in" : "out";
        a.additionalEvent = this.options.event + b;
      }

      this._super.emit.call(this, a);
    }
  }), i(da, Y, {
    defaults: {
      event: "press",
      pointers: 1,
      time: 251,
      threshold: 9
    },
    getTouchAction: function getTouchAction() {
      return [hb];
    },
    process: function process(a) {
      var b = this.options,
          c = a.pointers.length === b.pointers,
          d = a.distance < b.threshold,
          f = a.deltaTime > b.time;
      if (this._input = a, !d || !c || a.eventType & (Ga | Ha) && !f) this.reset();else if (a.eventType & Ea) this.reset(), this._timer = e(function () {
        this.state = rb, this.tryEmit();
      }, b.time, this);else if (a.eventType & Ga) return rb;
      return tb;
    },
    reset: function reset() {
      clearTimeout(this._timer);
    },
    emit: function emit(a) {
      this.state === rb && (a && a.eventType & Ga ? this.manager.emit(this.options.event + "up", a) : (this._input.timeStamp = ra(), this.manager.emit(this.options.event, this._input)));
    }
  }), i(ea, aa, {
    defaults: {
      event: "rotate",
      threshold: 0,
      pointers: 2
    },
    getTouchAction: function getTouchAction() {
      return [jb];
    },
    attrTest: function attrTest(a) {
      return this._super.attrTest.call(this, a) && (Math.abs(a.rotation) > this.options.threshold || this.state & ob);
    }
  }), i(fa, aa, {
    defaults: {
      event: "swipe",
      threshold: 10,
      velocity: .3,
      direction: Na | Oa,
      pointers: 1
    },
    getTouchAction: function getTouchAction() {
      return ba.prototype.getTouchAction.call(this);
    },
    attrTest: function attrTest(a) {
      var b,
          c = this.options.direction;
      return c & (Na | Oa) ? b = a.overallVelocity : c & Na ? b = a.overallVelocityX : c & Oa && (b = a.overallVelocityY), this._super.attrTest.call(this, a) && c & a.offsetDirection && a.distance > this.options.threshold && a.maxPointers == this.options.pointers && qa(b) > this.options.velocity && a.eventType & Ga;
    },
    emit: function emit(a) {
      var b = $(a.offsetDirection);
      b && this.manager.emit(this.options.event + b, a), this.manager.emit(this.options.event, a);
    }
  }), i(ga, Y, {
    defaults: {
      event: "tap",
      pointers: 1,
      taps: 1,
      interval: 300,
      time: 250,
      threshold: 9,
      posThreshold: 10
    },
    getTouchAction: function getTouchAction() {
      return [ib];
    },
    process: function process(a) {
      var b = this.options,
          c = a.pointers.length === b.pointers,
          d = a.distance < b.threshold,
          f = a.deltaTime < b.time;
      if (this.reset(), a.eventType & Ea && 0 === this.count) return this.failTimeout();

      if (d && f && c) {
        if (a.eventType != Ga) return this.failTimeout();
        var g = this.pTime ? a.timeStamp - this.pTime < b.interval : !0,
            h = !this.pCenter || H(this.pCenter, a.center) < b.posThreshold;
        this.pTime = a.timeStamp, this.pCenter = a.center, h && g ? this.count += 1 : this.count = 1, this._input = a;
        var i = this.count % b.taps;
        if (0 === i) return this.hasRequireFailures() ? (this._timer = e(function () {
          this.state = rb, this.tryEmit();
        }, b.interval, this), ob) : rb;
      }

      return tb;
    },
    failTimeout: function failTimeout() {
      return this._timer = e(function () {
        this.state = tb;
      }, this.options.interval, this), tb;
    },
    reset: function reset() {
      clearTimeout(this._timer);
    },
    emit: function emit() {
      this.state == rb && (this._input.tapCount = this.count, this.manager.emit(this.options.event, this._input));
    }
  }), ha.VERSION = "2.0.8", ha.defaults = {
    domEvents: !1,
    touchAction: gb,
    enable: !0,
    inputTarget: null,
    inputClass: null,
    preset: [[ea, {
      enable: !1
    }], [ca, {
      enable: !1
    }, ["rotate"]], [fa, {
      direction: Na
    }], [ba, {
      direction: Na
    }, ["swipe"]], [ga], [ga, {
      event: "doubletap",
      taps: 2
    }, ["tap"]], [da]],
    cssProps: {
      userSelect: "none",
      touchSelect: "none",
      touchCallout: "none",
      contentZooming: "none",
      userDrag: "none",
      tapHighlightColor: "rgba(0,0,0,0)"
    }
  };
  var ub = 1,
      vb = 2;
  ia.prototype = {
    set: function set(a) {
      return la(this.options, a), a.touchAction && this.touchAction.update(), a.inputTarget && (this.input.destroy(), this.input.target = a.inputTarget, this.input.init()), this;
    },
    stop: function stop(a) {
      this.session.stopped = a ? vb : ub;
    },
    recognize: function recognize(a) {
      var b = this.session;

      if (!b.stopped) {
        this.touchAction.preventDefaults(a);
        var c,
            d = this.recognizers,
            e = b.curRecognizer;
        (!e || e && e.state & rb) && (e = b.curRecognizer = null);

        for (var f = 0; f < d.length;) {
          c = d[f], b.stopped === vb || e && c != e && !c.canRecognizeWith(e) ? c.reset() : c.recognize(a), !e && c.state & (ob | pb | qb) && (e = b.curRecognizer = c), f++;
        }
      }
    },
    get: function get(a) {
      if (a instanceof Y) return a;

      for (var b = this.recognizers, c = 0; c < b.length; c++) {
        if (b[c].options.event == a) return b[c];
      }

      return null;
    },
    add: function add(a) {
      if (f(a, "add", this)) return this;
      var b = this.get(a.options.event);
      return b && this.remove(b), this.recognizers.push(a), a.manager = this, this.touchAction.update(), a;
    },
    remove: function remove(a) {
      if (f(a, "remove", this)) return this;

      if (a = this.get(a)) {
        var b = this.recognizers,
            c = r(b, a);
        -1 !== c && (b.splice(c, 1), this.touchAction.update());
      }

      return this;
    },
    on: function on(a, b) {
      if (a !== d && b !== d) {
        var c = this.handlers;
        return g(q(a), function (a) {
          c[a] = c[a] || [], c[a].push(b);
        }), this;
      }
    },
    off: function off(a, b) {
      if (a !== d) {
        var c = this.handlers;
        return g(q(a), function (a) {
          b ? c[a] && c[a].splice(r(c[a], b), 1) : delete c[a];
        }), this;
      }
    },
    emit: function emit(a, b) {
      this.options.domEvents && ka(a, b);
      var c = this.handlers[a] && this.handlers[a].slice();

      if (c && c.length) {
        b.type = a, b.preventDefault = function () {
          b.srcEvent.preventDefault();
        };

        for (var d = 0; d < c.length;) {
          c[d](b), d++;
        }
      }
    },
    destroy: function destroy() {
      this.element && ja(this, !1), this.handlers = {}, this.session = {}, this.input.destroy(), this.element = null;
    }
  }, la(ha, {
    INPUT_START: Ea,
    INPUT_MOVE: Fa,
    INPUT_END: Ga,
    INPUT_CANCEL: Ha,
    STATE_POSSIBLE: nb,
    STATE_BEGAN: ob,
    STATE_CHANGED: pb,
    STATE_ENDED: qb,
    STATE_RECOGNIZED: rb,
    STATE_CANCELLED: sb,
    STATE_FAILED: tb,
    DIRECTION_NONE: Ia,
    DIRECTION_LEFT: Ja,
    DIRECTION_RIGHT: Ka,
    DIRECTION_UP: La,
    DIRECTION_DOWN: Ma,
    DIRECTION_HORIZONTAL: Na,
    DIRECTION_VERTICAL: Oa,
    DIRECTION_ALL: Pa,
    Manager: ia,
    Input: x,
    TouchAction: V,
    TouchInput: P,
    MouseInput: L,
    PointerEventInput: M,
    TouchMouseInput: R,
    SingleTouchInput: N,
    Recognizer: Y,
    AttrRecognizer: aa,
    Tap: ga,
    Pan: ba,
    Swipe: fa,
    Pinch: ca,
    Rotate: ea,
    Press: da,
    on: m,
    off: n,
    each: g,
    merge: ta,
    extend: sa,
    assign: la,
    inherit: i,
    bindFn: j,
    prefixed: u
  });
  var wb = "undefined" != typeof a ? a : "undefined" != typeof self ? self : {};
  wb.Hammer = ha, "function" == typeof define && define.amd ? define(function () {
    return ha;
  }) : "undefined" != typeof module && module.exports ? module.exports = ha : a[c] = ha;
}(window, document, "Hammer");