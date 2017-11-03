//  HeyzapAds.js
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

  var SERVICE = "HeyzapAds";
  var Common = cordova.require("heyzap-cordova.Common");

  /**
   * Additional options to pass in to HeyzapAds.start
   * @param {Object} [options] options An object where the keys are valid options in the HeyzapAds.Options object. (i.e. { disableAutomaticPrefetch: true } )
   *
   * @memberOf HeyzapAds
   */
  var Options = function HeyzapAds_Options(options) {
    if (typeof(options) === 'object' && Object.keys(options).length !== 0) {

      for (var option in options) {
        if (typeof(this[option]) === 'boolean' && typeof(options[option]) === 'boolean') {
          this[option] = options[option];
        }
      }
    }
  };

  /**
   * Flag to indicate no special options are being used
   * @type {Boolean}
   */
  Options.prototype.none = true;

  /**
   * Flag to disable automatic fetching for interstitial ads. Useful for cases
   * where there are resource constraints or for cases where a mediation or waterfall
   * is being used
   * @type {Boolean}
   */
  Options.prototype.disableAutomaticPrefetch = false;

  /**
   * Flag only to be used for tracking app installs by an advertiser. Showing of ads is disabled.
   * @type {Boolean}
   */
  Options.prototype.installTrackingOnly = false;

  /**
   * Flag to indicate app is being distributed with the Amazon Appstore
   * @type {Boolean}
   */
  Options.prototype.amazon = false;

  /**
   * Disable mediation, even if third party networks are present.
   * This is not required, but is recommended for developers not using mediation. If
   * you're mediating Heyzap through someone (e.g. AdMob), it is *strongly* recommended that you 
   * disable Heyzap's mediation to prevent any potential conflicts.
   * @type {Boolean}
   */
  Options.prototype.disableMediation = false;

  /**
   * [iOS ONLY] Set this to `true` to disable recording of In-App Purchase data
   * @type {Boolean}
   */
  Options.prototype.disableAutomaticIAPRecording = false;

  /**
   * Main Heyzap SDK Object
   * @type {Object}
   *
   * @module HeyzapAds
   */
  var HeyzapAds = {

    /**
     * Supported SDK-wide events. For individual ad type events,
     * see the invidual objects representing each ad type (i.e. HeyzapAds.IncentivizedAd.Events)
     * @type {Object}
     */
    Events: {
      NETWORK_CALLBACK: 'networkCallbacks'
    },

    /**
     * Start Heyzap Ads. This needs to called as early as possible in the application lifecycle.
     * @param  {!string} publisherId Publisher ID on your Heyzap Dashboard
     * @param  {!HeyzapAds.Options} [options] options to pass to start method
     * 
     * @return {Promise} An ES-6 style promise if the native call succeeded or failed.
     * @throws {TypeError} If the above parameters do not match their types
     * 
     */
    start: function HeyzapAds_start(publisherId, options) {

      if (typeof(publisherId) !== "string") {
        throw new TypeError('"publisherId" must be a string');
      }

      if (typeof(options) !== 'undefined' && !(options instanceof HeyzapAds.Options)) {
        throw new TypeError('"Options" must be an instance of HeyzapAds.Options');
      }

      return Common.exec(SERVICE, 'start', publisherId, options);
    },

    /**
     * Presents a new view that displays integration information and allows fetch/show testing
     * of various supported ad networks
     * 
     * @return {Promise} An ES-6 style promise if the native call succeeded or failed.
     */
    showMediationTestSuite: function HeyzapAds_showMediationTestSuite() {
      return Common.exec(SERVICE, 'mediationTestSuite');
    },

    /**
     * Returns an object of developer-settable data or an empty object if no data is available
     * 
     * @return {Promise} An ES-6 style promise if the native call succeeded or failed. The success callback will have the remote data object
     */
    fetchRemoteData: function HeyzapAds_getRemoteData() {
      return Common.exec(SERVICE, 'remoteData');
    },

    /**
     * Report an In-App Purchase to Heyzap
     * Note that this does *not* have to be called on iOS unless
     * the SDK is started with the 'HeyzapAds.Options.disableAutomaticIAPRecording' option enabled
     * or the In-App Purchase is not through the iOS appstore
     * 
     * @param  {string} productId   Unique identifier of the product
     * @param  {string} productName Common name of the product
     * @param  {number} price       Price of the product in USD
     * 
     * @return {Promise} An ES-6 style promise if the native call succeeded or failed.
     */
    onIAPComplete: function HeyzapAds_onIAPComplete(productId, productName, price) {
      if (typeof(productId) !== 'string') {
        throw new TypeError('"productId" must be a string.');
      }

      if (typeof(productName) !== 'string') {
        throw new TypeError('"productName" must be a string.');
      }

      if (typeof(price) !== 'number') {
        throw new TypeError('"price" must be a number.');
      }

      return Common.exec(SERVICE, 'onIAPComplete', productId, productName, price);
    },

    /**
     * Add an event listener for an event for a particular service
     *
     * @param {string} type Name of event
     * @param {function} listener Event listener
     *
     * @throws {TypeError} If the parameters do not match their types
     */
    addEventListener: Common.partial(Common.addEventListener, SERVICE),

    Options: Options,

    InterstitialAd: cordova.require('heyzap-cordova.ads.InterstitialAd'),

    VideoAd: cordova.require('heyzap-cordova.ads.VideoAd'),

    IncentivizedAd: cordova.require('heyzap-cordova.ads.IncentivizedAd'),

    BannerAd: cordova.require('heyzap-cordova.ads.BannerAd')
  };

  Common.registerEventsForService(SERVICE, HeyzapAds.Events, false);

  module.exports = HeyzapAds;
})();
