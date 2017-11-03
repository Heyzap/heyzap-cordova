//  CDVBannerAd.java
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
import android.view.Gravity;
import com.heyzap.sdk.ads.BannerAdView;
import com.heyzap.sdk.ads.HeyzapAds.CreativeSize;
import com.heyzap.sdk.ads.HeyzapAds.BannerOptions;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;

import com.heyzap.sdk.ads.BannerAd;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

public class CDVBannerAd extends CDVHeyzapAbstractPlugin {
    private static final String TAG = "CDVBannerAd";

    private static final String POSITION_BOTTOM = "bottom";
    private static final String FACEBOOK_SIZE_PROPERTY = "facebookBannerSize";
    private static final String ADMOB_SIZE_PROPERTY = "admobBannerSize";

    private HashMap<String, CreativeSize> bannerSizes = new HashMap<String, CreativeSize>();

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        // Facebook banner sizes
        bannerSizes.put("320_50", CreativeSize.BANNER_320_50);
        bannerSizes.put("HEIGHT_50", CreativeSize.BANNER_HEIGHT_50);
        bannerSizes.put("HEIGHT_90", CreativeSize.BANNER_HEIGHT_90);

        // AdMob banner sizes
        bannerSizes.put("STANDARD", CreativeSize.BANNER);
        bannerSizes.put("LARGE", CreativeSize.LARGE_BANNER);
        bannerSizes.put("FULL_SIZE", CreativeSize.FULL_BANNER);
        bannerSizes.put("LEADERBOARD", CreativeSize.LEADERBOARD);
        bannerSizes.put("SMART", CreativeSize.SMART_BANNER);
    }

    public void show(final JSONArray args, final CallbackContext callbackContext) {
        String jsonPosition = args.optString(0, POSITION_BOTTOM);
        BannerOptions options = getOptions(args.optJSONObject(1));
        String tag = args.optString(2);

        int position = Gravity.TOP;

        if (jsonPosition.equals(POSITION_BOTTOM)) {
            position = Gravity.BOTTOM;
        }

        BannerAdView currentBannerAdView = BannerAd.getCurrentBannerAdView();

        if (currentBannerAdView != null && currentBannerAdView.getParent() != null) {
            callbackContext.success("A banner is already showing");

        } else {
            BannerAd.display(cordova.getActivity(), position, tag, options);
            callbackContext.success();
        }
    }

    public void hide(final JSONArray args, final CallbackContext callbackContext) {
        BannerAd.hide();
        callbackContext.success();
    }

    public void destroy(final JSONArray args, final CallbackContext callbackContext) {
        BannerAd.destroy();
        callbackContext.success();
    }

    public void dimensions(final JSONArray args, final CallbackContext callbackContext) {
        BannerAdView currentBannerAdView = BannerAd.getCurrentBannerAdView();

        if (currentBannerAdView != null && currentBannerAdView.getParent() != null) {
            JSONObject dimensions = new JSONObject();

            try {
                dimensions.put("x", currentBannerAdView.getLeft());
                dimensions.put("y", currentBannerAdView.getTop());
                dimensions.put("width", currentBannerAdView.getWidth());
                dimensions.put("height", currentBannerAdView.getHeight());

            } catch (JSONException e) {
                String message = "Could not get current banner ad dimensions: " + e.getMessage();

                Log.e(TAG, message);
                e.printStackTrace();

                callbackContext.error(message);
                return;
            }

            callbackContext.success(dimensions);
        }
    }

    @Override
    public void setListener(CDVListener listener) {
        BannerAd.setBannerListener(listener);
    }

    private BannerOptions getOptions(JSONObject jsonOptions) {
        BannerOptions options = new BannerOptions();

        if (jsonOptions != null) {
            CreativeSize facebookBannerSize = bannerSizes.get(jsonOptions.optString(FACEBOOK_SIZE_PROPERTY));
            if (facebookBannerSize != null) {
                options.setFacebookBannerSize(facebookBannerSize);
            }

            CreativeSize admobBannerSize = bannerSizes.get(jsonOptions.optString(ADMOB_SIZE_PROPERTY));
            if (admobBannerSize != null) {
                options.setAdmobBannerSize(admobBannerSize);
            }
        }

        return options;
    }
}
