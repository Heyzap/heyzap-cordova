# Cordova SDK Advanced Features

Manual Fetching
--------------------------------

In some scenarios, you may wish to disable automatic fetching of the ad from the ad server. Reasons for manual fetching could be if you are putting Heyzap into a waterfall with other ad networks, using a mediation network, or are worried about the performance or bandwidth impact of Heyzap ads.

To put the Heyzap SDK into manual mode, start the SDK (as shown in Step 1) with the following option:
```javascript
HeyzapAds.start(
  "<PUBLISHER_KEY>",
  new HeyzapAds.Options({disableAutomaticPrefetch: true})

).then(function() {
  // Start fetching ads

}, function(error) {
  // Handle Error
});
```

Then when fetching an ad, do the following:
```javascript
HeyzapAds.InterstitialAd.fetch().then(function() {
  // Native call succeeded

}, function(error) {
  // Handle Error
});
```

After succesfully fetching an ad, you will receive an `Events.AVAILABLE` callback (see the [callbacks section](#callbacks) below), whereby it is safe to show an ad:

```javascript
HeyzapAds.InterstitialAd.addEventListener(
  HeyzapAds.InterstitialAd.Events.AVAILABLE,
  
  function(tag) {
    HeyzapAds.InterstitialAd.show();
  });
```

***Important***: It is highly recommended to fetch as far in advance of showing an ad as possible. For example, you may want to fetch an ad when a level starts, or after a previous ad has been shown.

### Additional Options
Here are some additional options that can be passed in when starting Heyzap:
- `installTrackingOnly` - Flag only to be used for tracking app installs by an advertiser. Showing of ads is disabled.
- `amazon` - Flag to indicate app is being distributed with the Amazon Appstore.
- `disableMediation` - Disable mediation, even if third party networks are present.
  - This is not required, but is recommended for developers not using mediation. 
  - If you're mediating Heyzap through someone (e.g. AdMob), it is *strongly* recommended that you disable Heyzap's mediation to prevent any potential conflicts.
- `disableAutomaticIAPRecording` (**iOS Only**) - disable automatic recording of In-App Purchase data.

Tags
----------------

Tags are a powerful tool which enable you to monitor the performance of ads in a particular location or logical section of your app. If an ad with a particular tag underperforms or you later find is too annoying to your users, you can turn it off from the dashboard, saving you the hastle of resubmitting your app to the App Store. In addition, you do not need to setup tag names prior to writing code: as soon as we see a new tag, we will show you the stats in your app's dashboard.

Before you can show an ad with a tag, you must fetch the ad at the earliest point to when you know you will need to show that ad.

In the following example, we fetch an ad that will be shown after the game's level is complete:
```javascript
HeyzapAds.InterstitialAd.fetch("post-level").then(function() {
  // Native call succeeded

}, function(error) {
  // Handle Error
});
```

Then, when you want to display the "post-level" ad, do so by passing the same "post-level" string to `show`:
```javascript
HeyzapAds.InterstitialAd.show("post-level").then(function() {
  // Native call succeeded

}, function(error) {
  // Handle Error
});
```

If you want to find out if an ad with a particular tag is ready to display, the `Events.AVAILABLE` callback (see the [callbacks section](#callbacks) below) will pass back the tag that is available:

```javascript
HeyzapAds.InterstitialAd.addEventListener(
  HeyzapAds.InterstitialAd.Events.AVAILABLE,
  
  function(tag) {
    if (tag == "post-level") {
      HeyzapAds.InterstitialAd.show("post-level");
    }
  });
```
Callbacks
----------------
You may need to know when an ad has shown, has been hidden, or the user clicked on an ad (and is about to leave your app). You can attach a listener to the object to receive callbacks for when these events occur:

```javascript
HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.AUDIO_STARTED,
  function() {
    // Pause any music
  });
```

`InterstitialAd`, `VideoAd` and `IncentivizedAd` define six different events:

```javascript
HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.SHOW,
  function(tag) {
    // The ad was successfully shown.
  });

HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.HIDE,
  function(tag) {
    // The ad successfully finished showing and is now off the screen.
  });

HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.CLICKED,
  function(tag) {
    // The ad was clicked/tapped
    // The user might be switched to the browser or an app store.
  });

HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.SHOW_FAILED,
  function(tag, error) {
    // The ad could not be shown successfully.
  });

HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.FETCH_FAILED,
  function(tag, error) {
    // The ad could not be fetched.
  });

HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.AUDIO_STARTED,
  function() {
    // The ad will start playing audio.
    // Mute any music in the background.
  });

HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.AUDIO_FINISHED,
  function(tag) {
    // The ad stop playing audio.
    // Resume any previously muted music.
  });

HeyzapAds.VideoAd.addEventListener(HeyzapAds.VideoAd.Events.AVAILABLE,
  function(tag) {
    // An ad is available for display.
  });
```

In addition to the above callbacks, `IncentivizedAd` has two more callbacks:
```javascript
HeyzapAds.IncentivizedAd.addEventListener(HeyzapAds.IncentivizedAd.Events.COMPLETE,
  function(tag) {
    // The rewarded ad was successfully completed, give the user their reward.
  });

HeyzapAds.IncentivizedAd.addEventListener(HeyzapAds.IncentivizedAd.Events.INCOMPLETE,
  function(tag) {
    // The rewarded ad was not completed successfully.
  });

```

`BannerAd` has the following three callbacks
```javascript
HeyzapAds.BannerAd.addEventListener(HeyzapAds.BannerAd.Events.LOADED,
  function() {
    // The ad is loaded.
  });

HeyzapAds.BannerAd.addEventListener(HeyzapAds.BannerAd.Events.CLICKED,
  function() {
    // The ad was clicked/tapped on.
    // The user might be switched to the browser or an app store.
  });

HeyzapAds.BannerAd.addEventListener(HeyzapAds.BannerAd.Events.ERROR,
  function(error) {
    // The ad could not be shown/fetched.
  });
```

Banner Dimensions
-------------------

The dimensions of the currently shown banner can be obtained by calling `BannerAd.dimensions`:
```javascript
HeyzapAds.BannerAd.dimensions().then(function(dimensions) {
  console.log("Banner dimensions: width=" + dimensions.width + " height=" + dimensions.height);

}, function(error) {
  // Handle Error
});
```

Banner Sizes
--------------
By default, banners will be sized appropriately for a phone or non-tablet device. If you want to customize the banner size for each banner network, you can pass in an optional `BannerAd.Options` object:

```javascript
HeyzapAds.BannerAd.show(
  HeyzapAds.BannerAd.POSITION_TOP,

  new HeyzapAds.BannerAd.Options({
    facebookBannerSize: HeyzapAds.BannerAd.Options.FacebookBannerSize.HEIGHT_90
    admobBannerSize: HeyzapAds.BannerAd.Options.AdMobBannerSize.LARGE
  })

).then(function() {
  // Native call succeeded

}, function(error) {
  // Handle Error
})
```

The following banner sizes are supported for Facebook Audience Network:
- `FacebookBannerSize.SIZE_320_50`: A fixed size 320x50 pt. banner.
- `FacebookBannerSize.HEIGHT_50`: A banner 50 pts in height and flexible width that expands to the width of the screen. This is the default size for Facebook banners.
- `FacebookBannerSize.HEIGHT_90`: A banner 90 pts in height and flexible width that expands to the width of the screen.

The following banner sizes are supported for AdMob:
- `AdMobBannerSize.STANDARD`: 320x50 Size banner. This is the default size for AdMob banners.
- `AdMobBannerSize.LARGE`: 320x100 Size banner.
- `AdMobBannerSize.FULL_SIZE`: 468x60 Size banner. Note: This size is available for tablets only.
- `AdMobBannerSize.LEADERBOARD`: 728x90 Size banner. Note: This size is available for tablets only.
- `AdMobBannerSize.SMART`: Flexible width banner.

Remote Data
---------------------------------
To configure data to send to your app via our SDK, go to [your Dashboard](https://developers.heyzap.com/dashboard/publisher/revenue), select a game, and then choose "Publisher Settings" from the navigation menu on the left. By setting up your own JSON blob under the setting "Remote Data JSON", you can send any data you need to your app through our SDK. The code below shows how to access this custom data via the SDK.

```javascript
HeyzapAds.fetchRemoteData().then(function(remoteData) {
  // Do something with the data here

}, function(error) {
  // Handle Error
});
```

### Example use case: Variable rewards for incentivized ads
If you'd like to be able to change the in-app currency type and/or amount that you will give users after they successfully complete an incentivized video ad, you can just set up this Remote Data object with something like this:
```json
{
    "incentivized_reward":
    {
        "currency":"Gems",
        "amount":10
    }
}
```

__Note__: The top-level object of whatever JSON blob you choose to save on your Dashboard should be a JSON object (`{}`) and not a JSON array (`[]`).

In-App Purchase Tracking
------------------------

### Automatic Tracking
For iOS, the SDK tracks In-App Purchases by default. For android, manual tracking is required.

If an _In App Purchase Ad Timeout_ is set in the app's [Publisher Settings](https://developers.heyzap.com/dashboard/mediation), then the SDK will automatically disable all banner, interstitial and video ads for the duration of the timeout.

### Manual Tracking
To disable automatic in-app purchase tracking for iOS, start the SDK with the `disableAutomaticIAPRecording` option:

```javascript
HeyzapAds.start(
  "<PUBLISHER_KEY>",
  new HeyzapAds.Options({disableAutomaticIAPRecording: true})

  ).then(function() {
    // Start fetching ads

  }, function(error) {
    // Handle Error
  });
```

The `onIAPComplete` method can then be called to track specific in-app purchases:

```javascript
HeyzapAds.onIAPComplete("com.product.id", "Product Name", 12.36).then(function() {
  // Native call succeeded

}, function(error) {
  // Handle Error
});
```

Install-Tracking Only
---------------------------------

If you are integrating the ads-only SDK to provide install attribution, start the sdk with the `installTrackingOnly` option:

```javascript
HeyzapAds.start(
  "<PUBLISHER_KEY>",
  new HeyzapAds.Options({installTrackingOnly: true})

).then(function() {
  // Native call succeeded

}, function(error) {
  // Handle Error
});
```

Test Devices
---------------------------------

Advertisers are able to target certain countries on Heyzap's network. Depending on which country you live in, there may be a limited number of advertisers targetting you, and video ads may not be available at all in your country. 

For testing purposes, you can set your own device to receive ads from all advertisers on your App Settings page, which can be found on the [Revenue dashboard](https://developers.heyzap.com/dashboard/publisher/revenue) for your app.

<hr>
<strong>More Information:</strong>

[To go back to basic Cordova SDK setup, click here](setup_and_requirements.md).
