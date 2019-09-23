'use strict';

var GLOBALS = {
  MEDIA_MOBILE: 768,
  MEDIA_TABLET: 1025,
  MEDIA_FILTERS: 1200
};
$(document).ready(function () {//GLOBALS.method();
});
"use strict";

/*global $, GLOBALS, window, document */
var modal = function () {
  'use strict';

  var overlay = $('#modal-overlay'),
      initialscroll = 0,
      main = $('.main'),
      footer = $('.footer'),
      open = function open(select) {
    var box = $(select);

    if (overlay.length <= 0) {
      overlay = $('<div id="modal-overlay" class="overlay"></div>').appendTo($('body'));
    }

    overlay.fadeIn(250, function () {
      box.fadeIn(350);
      initialscroll = $(window).scrollTop();

      if (window.innerWidth < GLOBALS.MEDIA_MOBILE) {
        main.addClass('hidden-block');
        footer.addClass('hidden-block');
        $(window).scrollTop(0);
      }
    });
  },
      close = function close(select) {
    animateClose($(select));
  },
      closeButton = function closeButton() {
    $('.modal__close').on('click', function (e) {
      e.preventDefault();
      var box = $(this).closest('.modal');
      animateClose(box);
    });
  },
      animateClose = function animateClose(obj) {
    obj.fadeOut(250, function () {
      overlay.fadeOut(300);
      main.removeClass('hidden-block');
      footer.removeClass('hidden-block');
      $(window).scrollTop(initialscroll);
    });
  },
      autoOpen = function autoOpen() {
    $('[data-modal]').on('click', function (e) {
      e.preventDefault();
      open($(this).attr('data-modal'));
    });
  };

  return {
    open: open,
    close: close,
    closeButton: closeButton,
    autoOpen: autoOpen
  };
}();

$(document).ready(function () {
  'use strict';

  modal.closeButton();
  modal.autoOpen();
});
/*global $, window, document*/
'use strict';

var test = function () {
  var render = function render() {// code here
  };

  var init = function init() {
    render();
  }; // public methods


  return {
    init: init,
    render: render
  };
}();

$(document).ready(function () {
  test.init();
});