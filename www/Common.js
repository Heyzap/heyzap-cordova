//  Common.js
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

  var Promise = require('heyzap-cordova.Promise');

  var Common = {
    listeners: {},

    error: function Common_throwError(err) {
      return Promise.reject(err);
    },

    exec: function Common_exec(service, action) {
      var args = Array.prototype.slice.call(arguments, 2);

      return new Promise(function(resolve, reject) {
        cordova.exec(
          function(success) {
            resolve(success);
          },

          function(error) {
            reject(error);
          },
          service,
          action,
          args
        );
      });
    },

    partial: function Common_partial(method) {
      var extraArgs = Array.prototype.slice.call(arguments, 1);
      return function() {
        var args = Array.prototype.slice.call(arguments);
        method.apply(null, extraArgs.concat(args));
      };
    },


    /**
     * Register events for a service (e.g. events for Incentivized Ads)
     * @param  {String} service                      Name of cordova service
     * @param  {Object} events                       An object where are values are the names of the events that the cordova service will fire
     *
     * @private
     */
    registerEventsForService: function Common_registerEventsForService(service, events, nativeEventHandlerRegistered) {

      var eventListeners = {};

      for (var key in events) {
        eventListeners[events[key]] = [];
      }

      Common.listeners[service] = {
        eventListeners: eventListeners,
        nativeEventHandlerRegistered: nativeEventHandlerRegistered || false
      };
    },

    /**
     * Add an event listener for an event for a particular service.
     * Registers a native event listeners for the cordova service if there isn't
     * one set already
     * @param {string} service  Name of cordova service (i.e. CDVHeyzapAds)
     * @param {string} type     Name of event
     * @param {function} listener Event listener
     *
     * @throws {TypeError} If the parameters do not match their types
     * @private
     */
    addEventListener: function Common_addEventListener(service, type, listener) {

      if (typeof(listener) !== 'function') {
        throw new TypeError('"listener" must be a function');
      }

      var serviceEventInfo = Common.listeners[service];
      if (!serviceEventInfo) {
        return;
      }

      var eventListeners = serviceEventInfo.eventListeners;

      if (!(eventListeners[type] instanceof Array)) {
        throw new Error('type: "' + type + '" is not a recognized event.');
      }

      eventListeners[type].push(listener);

      if (!serviceEventInfo.nativeEventHandlerRegistered) {
        cordova.exec(
          Common.partial(Common.dispatchEvent, service),
          function(error) {
            console.error('[HeyzapAds - ' + service + '] - Could not register native event listener', error);
          },
          service,
          'addEventListener',
          []
        );
      }
    },

    /**
     * Dispatch an event that is sent by a native event listener to registered JavaScript event listeners
     * @param  {string} service Name of cordova service (i.e. 'CDVHeyzapAds')
     * @param  {*[]} data Any additional data that the native event listeners passed back
     * The first element in data must be the name of the event.
     *
     * @private
     */
    dispatchEvent: function Common_dispatchEvent(service, data) {

      // A crash occurs on iOS without the timeout when a break point is set in the event handler
      // Crash message: "Multiple locks on web thread not allowed! Please file a bug. Crashing now"
      // See https://github.com/forcedotcom/SalesforceMobileSDK-iOS/issues/252 for more info
      window.setTimeout(function() {
        var serviceEventInfo = Common.listeners[service];

        if (!serviceEventInfo || data == null || data.length === 0) {
          return;
        }

        var event = data.shift();

        if (event === "OK") {
          serviceEventInfo.nativeEventHandlerRegistered = true;
          return;
        }

        var eventListeners = serviceEventInfo.eventListeners;

        if (eventListeners[event] instanceof Array) {

          for (var i = 0; i < eventListeners[event].length; i++) {
            try {
              eventListeners[event][i].apply(null, data);

            } catch(e) {
              console.error('[HeyzapAds - ' + service + '] Error dispatching event: "' + event + '" for callback: ' + eventListeners[event][i], e);
            }
          }
        }
      }, 0);
    }
  };

  module.exports = Common;
})();
