//  CDVHeyzapAds.java
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

import org.apache.cordova.CallbackContext;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;

import android.util.Log;

import com.heyzap.sdk.ads.HeyzapAds;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;

public class CDVHeyzapAds extends CDVHeyzapAbstractPlugin {
    private static final String TAG = "CDVHeyzapAds";

    private HashMap<String, Integer> startOptions = new HashMap<String, Integer>();
    private static final String FRAMEWORK = "cordova";

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        startOptions.put("none", HeyzapAds.NONE);
        startOptions.put("disableAutomaticPrefetch", HeyzapAds.DISABLE_AUTOMATIC_FETCH);
        startOptions.put("installTrackingOnly", HeyzapAds.INSTALL_TRACKING_ONLY);
        startOptions.put("amazon", HeyzapAds.AMAZON);
        startOptions.put("disableMediation", HeyzapAds.DISABLE_MEDIATION);
    }

    public void start(final JSONArray args, final CallbackContext callbackContext) {

        String publisherID = args.optString(0);
        int options = getStartOptionsFromJSON(args.optJSONObject(1));

        if (!publisherID.isEmpty()) {
            HeyzapAds.framework = FRAMEWORK;
            HeyzapAds.start(publisherID, cordova.getActivity(), options);

        } else {
            String msg = "publisher ID is missing.";
            Log.w(TAG, msg);
            callbackContext.error(msg);
        }

        callbackContext.success();
    }

    public void mediationTestSuite(final JSONArray args, final CallbackContext callbackContext) {
        HeyzapAds.startTestActivity(cordova.getActivity());
        callbackContext.success();
    }

    public void remoteData(final JSONArray args, final CallbackContext callbackContext) {
        JSONObject data = HeyzapAds.getRemoteData();
        callbackContext.success(data);
    }

    public void onIAPComplete(final JSONArray args, final CallbackContext callbackContext) {
        String productId = args.optString(0);
        String productName = args.optString(1);
        int price = (int)(args.optDouble(2, 0) * 100);

        HeyzapAds.onPurchaseComplete(productName, productId, price);
        callbackContext.success();
    }

    @Override
    public void setListener(CDVListener listener) {
        HeyzapAds.setNetworkCallbackListener(listener);
    }

    private int getStartOptionsFromJSON(JSONObject jsOptions) {
        int options = HeyzapAds.NONE;

        if (jsOptions != null) {

            Iterator<String> keyIter = jsOptions.keys();

            while(keyIter.hasNext()) {
                String key = keyIter.next();
                if (jsOptions.optBoolean(key, false)) {
                    options = options | startOptions.get(key);
                }
            }
        }

        return options;
    }
}
