// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import "bootstrap-sass"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
import {loadEditor} from './editor';
import {loadSidebar} from './sidebar';

// Initialize page-specific JS
//
// Run after document ready, expects JQuery.
$(function() {

  switch ($('body').data('js-path')) {

    case 'event/new.html':
    case 'event/edit.html':
    case 'post/new.html':
    case 'post/edit.html':
      loadEditor(document.getElementById('editor'),
                 document.getElementById('editor-input'));
      break;

    case 'event/show.html':
    case 'post/show.html':
      loadSidebar();
      break;

  }

});
