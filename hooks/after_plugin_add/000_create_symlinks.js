module.exports = function(ctx) {
  var fs = require('fs');

  // Re-create symlinks in ios SDK:
  var pluginDir = ctx.opts.plugin.dir + '/src/ios/sdk/HeyzapAds.framework/';

  console.log('[Heyzap] - Re-creating symlinks in iOS frameworks.');

  var createSymLink = false;

  var LINKS = {
    Headers: 'Versions/A/Headers',
    HeyzapAds: 'Versions/A/HeyzapAds',
    'Versions/Current': 'Versions/A',
  };

  for (var link in LINKS) {
    var createSymLink = false;

    try {
      createSymLink = !fs.lstatSync(pluginDir + link).isSymbolicLink();
    } catch (e) {
      createSymLink = true; // file/folder doesn't exist, create symlink
    }

    if (createSymLink) {
      fs.symlinkSync(pluginDir + LINKS[link], pluginDir + link);
    }
  }
};
