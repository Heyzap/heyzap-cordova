//  CDVListener.java
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

import android.util.Log;
import com.heyzap.sdk.ads.BannerAdView;
import com.heyzap.sdk.ads.HeyzapAds;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class CDVListener implements HeyzapAds.OnStatusListener, HeyzapAds.OnIncentiveResultListener, HeyzapAds.BannerListener, HeyzapAds.NetworkCallbackListener {
    private static final String TAG = "CDVListener";
    CallbackContext context = null;

    public CDVListener(final CallbackContext context) {
        this.context = context;
    }

    // NetworkCallbackListener
    private static final String NETWORK_CALLBACK = "networkCallbacks";

    @Override
    public void onNetworkCallback(String network, String callback) {
        JSONArray data = new JSONArray();
        data.put(network);
        data.put(callback);
        dispatchCallback(NETWORK_CALLBACK, data);
    }

    // BannerListener
    private static final String ERROR_CALLBACK = "error";
    private static final String LOADED_CALLBACK = "loaded";
    private static final String CLICKED_CALLBACK = "clicked";

    @Override
    public void onAdError(BannerAdView bannerAdView, HeyzapAds.BannerError bannerError) {
        JSONArray data = new JSONArray();
        data.put(bannerError.getErrorMessage());
        dispatchCallback(ERROR_CALLBACK, data);
    }

    @Override
    public void onAdLoaded(BannerAdView bannerAdView) {
        dispatchCallback(LOADED_CALLBACK);
    }

    @Override
    public void onAdClicked(BannerAdView bannerAdView) {
        dispatchCallback(CLICKED_CALLBACK);
    }

    // OnIncentiveResultListener
    private static final String COMPLETE_CALLBACK = "complete";
    private static final String INCOMPLETE_CALLBACK = "incomplete";

    @Override
    public void onComplete(String tag) {
        dispatchCallback(COMPLETE_CALLBACK, tag);
    }

    @Override
    public void onIncomplete(String tag) {
        dispatchCallback(INCOMPLETE_CALLBACK, tag);
    }

    // OnStatusListener
    private static final String SHOW_CALLBACK = "show";
    private static final String HIDE_CALLBACK = "hide";
    private static final String SHOW_FAILED_CALLBACK = "show_failed";
    private static final String AVAILABLE_CALLBACK = "available";
    private static final String FETCH_FAILED_CALLBACK = "fetch_failed";
    private static final String AUDIO_STARTED_CALLBACK = "audio_started";
    private static final String AUDIO_FINISHED_CALLBACK = "audio_finished";

    @Override
    public void onShow(String tag) {
        dispatchCallback(SHOW_CALLBACK, tag);
    }

    @Override
    public void onClick(String tag) {
        dispatchCallback(CLICKED_CALLBACK, tag);
    }

    @Override
    public void onHide(String tag) {
        dispatchCallback(HIDE_CALLBACK, tag);
    }

    @Override
    public void onFailedToShow(String tag) {
        dispatchCallback(SHOW_FAILED_CALLBACK, tag);
    }

    @Override
    public void onAvailable(String tag) {
        dispatchCallback(AVAILABLE_CALLBACK, tag);
    }

    @Override
    public void onFailedToFetch(String tag) {
        dispatchCallback(FETCH_FAILED_CALLBACK, tag);
    }

    @Override
    public void onAudioStarted() {
        dispatchCallback(AUDIO_STARTED_CALLBACK);
    }

    @Override
    public void onAudioFinished() {
        dispatchCallback(AUDIO_FINISHED_CALLBACK);
    }

    private void dispatchCallback(String callbackId) {
        dispatchCallback(callbackId, new JSONArray());
    }

    private void dispatchCallback(String callbackId, String tag) {
        JSONArray data = new JSONArray();
        if (tag != null && !tag.equals("null")) {
            data.put(tag);
        }
        dispatchCallback(callbackId, data);
    }

    private void dispatchCallback(String callbackId, JSONArray data) {
        if (context != null) {
            JSONArray callbackData = new JSONArray();
            callbackData.put(callbackId);

            for (int i = 0; i < data.length(); i++) {
                try {
                    callbackData.put(data.get(i));

                } catch (JSONException e) {
                    Log.e(TAG, "Could not add data to callback.");
                    e.printStackTrace();
                }
            }

            PluginResult result = new PluginResult(PluginResult.Status.OK, callbackData);
            result.setKeepCallback(true);
            context.sendPluginResult(result);
        }
    }
}
