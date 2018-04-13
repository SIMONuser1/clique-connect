//
//
// smooth-scroll.js
//
// Initialises the prism code highlighting plugin
import SmoothScroll from 'smooth-scroll'
/* global SmoothScroll */

const mrSmoothScroll = new SmoothScroll('a[data-smooth-scroll]', {
  offset: $('body').attr('data-smooth-scroll-offset') || 0,
});

export default mrSmoothScroll;
