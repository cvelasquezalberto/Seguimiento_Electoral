/*global $*/
'use strict';

var home = {
  cache: function cache() {//this.$item = $('.item');
  },
  render: function render() {//home.$item.each(function (i) {
    //});
  },
  run: function run() {//$(window).on('ready resize', home.render);
  },
  init: function init() {//this.cache();
    //this.render();
    //this.run();
  }
};
$(document).ready(function () {
  home.init();
});