// import "bootstrap";
import $ from 'jquery';
import './bootstrap/alert';
import './bootstrap/button';
import './bootstrap/carousel';
import './bootstrap/collapse';
import './bootstrap/dropdown';
import './bootstrap/modal';
import './bootstrap/popover';
import './bootstrap/scrollspy';
import './bootstrap/tab';
import './bootstrap/tooltip';
import './bootstrap/util';
import './mrare/background-images';
import './mrare/prism';
import './mrare/smooth-scroll';
import './mrare/sticky';
import './mrare/util';
import './mrare/video';
import './mrare/wizard';
import './algolia';

$(function() {
  if($.fn.cloudinary_fileupload !== undefined) {
    $("input.cloudinary-fileupload[type=file]").cloudinary_fileupload();
  }
});
