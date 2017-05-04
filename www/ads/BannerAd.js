//  BannerAd.js
//
//  Copyright 2015 Heyzap, Inc. All Rights Reserved
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

(function() {
  "use strict";

  var SERVICE = "BannerAd";
  var Common = cordova.require("heyzap-cordova.Common");

  /**
   * Options for Banner ads  
   * @param {Object} [options] options An object where the keys are valid options in the HeyzapAds.Options object. (i.e. { facebookBannerSize: HeyzapAds.BannerAd.Options.FacebookBannerSize.HEIGHT_90 } )
   * 
   * @memberOf HeyzapAds.BannerAd.Options
   */
  var Options = function BannerAd_Options(options) {
    if (typeof(options) === 'object' && Object.keys(options).length !== 0) {

      for (var option in options) {
        if (typeof(this[option]) === 'string' && typeof(options[option]) === 'string') {
          this[option] = options[option];
        }
      }
    }
  };

  /**
   * Sizes to use for Facebook banners
   * @type {Object}
   */
  Options.FacebookBannerSize = {
    /**
     * A fixed size 320x50 pt. banner.
     * @type {String}
     */
    SIZE_320_50: '320_50',

    /**
     * A banner 50 pts in height and flexible width that expands to the width of the screen
     * This is the default value for Facebook banners
     * @type {String}
     */
    HEIGHT_50: 'HEIGHT_50',

    /**
     * A banner 90 pts in height and flexible width that expands to the width of the screen
     * @type {String}
     */
    HEIGHT_90: 'HEIGHT_90'
  };

  /**
   * This size to use for AdMob banners.
   * Note: Some of AdMob's banner heights vary by device size
   * @type {Object}
   */
  Options.AdMobBannerSize = {
    /**
     * 320x50 Size banner
     * This is the default size for AdMob banners
     * @type {String}
     */
    STANDARD: 'STANDARD',

    /**
     * 320x100 Size banner
     * @type {String}
     */
    LARGE: 'LARGE',

    /**
     * 468x60 Size banner
     * Note: This size is available for tablets only
     * @type {String}
     */
    FULL_SIZE: 'FULL_SIZE',

    /**
     * 728x90 Size banner
     * Note: This size is available for tablets only
     * @type {String}
     */
    LEADERBOARD: 'LEADERBOARD',

    /**
     * Flexible width banner
     * @type {String}
     */
    SMART: 'SMART'
  };

  /**
   * Banner size for facebook banners
   * Defaults to HeyzapAds.BannerAd.Options.FacebookBannerSize.HEIGHT_50
   * @type {string}
   */
  Options.prototype.facebookBannerSize = Options.FacebookBannerSize.HEIGHT_50;

  /**
   * Banner size for AdMob banners
   * Defaults to HeyzapAds.BannerAd.Options.AdMobBannerSize.REGULAR
   * @type {string}
   */
  Options.prototype.admobBannerSize = Options.AdMobBannerSize.STANDARD;

  /**
   * Object responsible for handling Banner Ads
   * @type {Object}
   *
   * @memberOf HeyzapAds
   */
  var BannerAd = {
    Events: {
      LOADED: 'loaded',
      ERROR: 'error',
      CLICKED: 'clicked'
    },

    POSITION_TOP: 'top',
    POSITION_BOTTOM: 'bottom',

    /**
     * Display a banner ad
     * @param  {!string} position The position of the banner ad on the screen
     * Can be either HeyzapAds.BannerAd.POSITION_TOP or HeyzapAds.BannerAd.POSITION_BOTTOM
     * @param  {HeyzapAds.BannerAd.Options} [options] options  Additional Banner Ad options
     * @param  {string} [tag] tag      
     * @return {Promise} An ES-6 style promise if the native call succeeded or failed.
     */
    show: function BannerAd_show(position, options, tag) {
      if (position !== BannerAd.POSITION_TOP && position !== BannerAd.POSITION_BOTTOM) {
        throw new TypeError('"postion" must be either BannerAd.POSITION_TOP or BannerAd.POSITION_BOTTOM');
      }

      if (typeof(options) === 'string') {
        tag = options;
        options = null;
      }

      if (typeof(tag) !== 'undefined' && typeof(tag) !== 'string') {
        throw new TypeError('"tag" must be a string');
      }

      return Common.exec(SERVICE, 'show', position, options, tag);
    },

    /**
     * Hide a banner ad
     * @return {Promise} An ES-6 style promise if the native call succeeded or failed.
     */
    hide: function BannerAd_hide() {
      return Common.exec(SERVICE, 'hide');
    },

    /**
     * Completely remove a banner ad
     * @return {Promise} An ES-6 style promise if the native call succeeded or failed.
     */
    destroy: function BannerAd_destroy() {
      return Common.exec(SERVICE, 'destroy');
    },

    /**
     * Get the dimensions of a currently displayed banner ad
     * @return {Promise} An ES-6 style promise if the native call succeeded or failed.
     */
    dimensions: function BannerAd_dimensions() {
      return Common.exec(SERVICE, 'dimensions');
    },

    /**
     * Add an event listener for Banner Ads
     *
     * @param {string} type Name of event
     * @param {function} listener Event listener
     *
     * @throws {TypeError} If the parameters do not match their types
     */
    addEventListener: Common.partial(Common.addEventListener, SERVICE),

    Options: Options
  };

  Common.registerEventsForService(SERVICE, BannerAd.Events, false);

  module.exports = BannerAd;
})();
