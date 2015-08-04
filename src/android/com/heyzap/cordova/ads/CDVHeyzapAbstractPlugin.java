//  CDVHeyzapAbstractPlugin.java
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
import org.apache.cordova.CordovaPlugin;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import java.lang.reflect.*;

import android.util.Log;

abstract class CDVHeyzapAbstractPlugin extends CordovaPlugin implements ICDVHeyzapPlugin {
    private static final String TAG = "CDVHeyzapAbstractPlugin";

    private CDVListener listener;

    @Override
    public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {

        try {
            final Method actionMethod = this.getClass().getMethod(action, JSONArray.class, CallbackContext.class);

            if (actionMethod != null) {
                cordova.getThreadPool().execute(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            actionMethod.invoke(CDVHeyzapAbstractPlugin.this, args, callbackContext);

                        } catch (IllegalAccessException e) {
                            String msg = "Unable to Invoke action: " + action + ". Illegal Access Exception.";
                            Log.e(TAG, msg);
                            e.printStackTrace();

                            callbackContext.error(msg);

                        } catch (InvocationTargetException e) {
                            String msg = "Unable to Invoke action: " + action;
                            Log.e(TAG, msg);
                            e.printStackTrace();

                            callbackContext.error(msg);

                        } catch (Exception e) {
                            String msg = "Could not run Heyzap Ads Method - SDK Error: " + e.getMessage();
                            Log.e(TAG, msg);
                            e.printStackTrace();

                            callbackContext.error(msg);
                        }
                    }
                });

                return true;
            }

        } catch (NoSuchMethodException e) {
            Log.e(TAG, "Action: " + action + " was not found.");
        }

        return false;
    }

    public void addEventListener(final JSONArray args, final CallbackContext callbackContext) {

        JSONArray callbackData = new JSONArray();
        callbackData.put("OK");

        if (listener == null) {
            listener = new CDVListener(callbackContext);

            PluginResult result = new PluginResult(PluginResult.Status.OK, callbackData);
            result.setKeepCallback(true);
            callbackContext.sendPluginResult(result);

            setListener(listener);

        } else {
            callbackContext.success(callbackData);
        }
    }
}
