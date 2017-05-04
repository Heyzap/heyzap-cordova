//  CDVIncentivizedAd.java
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

package com.heyzap.cordova.ads;

import android.app.Activity;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;

import com.heyzap.sdk.ads.IncentivizedAd;

public class CDVIncentivizedAd extends CDVHeyzapAbstractPlugin {
    private static final String TAG = "CDVIncentivizedAd";

    public void fetch(final JSONArray args, final CallbackContext callbackContext) {
        String tag = args.optString(0);


        if (tag.isEmpty()) {
            IncentivizedAd.fetch();
        } else {
            IncentivizedAd.fetch(tag);
        }

        callbackContext.success();
    }

    public void show(final JSONArray args, final CallbackContext callbackContext) {
        String tag = args.optString(0);

        if (tag.isEmpty()) {
            displayIfAvailable(callbackContext);
        } else {
            displayIfAvailable(callbackContext, tag);
        }
    }

    @Override
    public void setListener(CDVListener listener) {
        IncentivizedAd.setOnStatusListener(listener);
        IncentivizedAd.setOnIncentiveResultListener(listener);
    }

    private void displayIfAvailable(final CallbackContext callbackContext) {
        if (IncentivizedAd.isAvailable()) {
            IncentivizedAd.display(cordova.getActivity());
            callbackContext.success();

        } else {
            callbackContext.error("Incentivized ad is not available.");
        }
    }

    private void displayIfAvailable(final CallbackContext callbackContext, String tag) {
        if (IncentivizedAd.isAvailable(tag)) {
            IncentivizedAd.display(cordova.getActivity(), tag);
            callbackContext.success();

        } else {
            callbackContext.error("Incentivized ad is not available");
        }
    }
}
