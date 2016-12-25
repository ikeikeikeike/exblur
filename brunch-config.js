exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    // javascripts: {
      // joinTo: "js/app.js",

      // order: {
        // before: [
          // "web/static/vendor/js/jquery.min.js",
          // "web/static/vendor/js/bootstrap.min.js",
          // "web/static/vendor/js/scripts.js"
        // ]
      // }

      // To use a separate vendor.js bundle, specify two files path
      // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
      // joinTo: {
      //  "js/app.js": /^(web\/static\/js)/,
      //  "js/vendor.js": /^(web\/static\/vendor)|(deps)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // https://github.com/brunch/brunch/tree/master/docs#concatenation
      // order: {
      //   before: [
      //     "web/static/vendor/js/jquery-2.1.1.js",
      //     "web/static/vendor/js/bootstrap.min.js"
      //   ]
      // }

    javascripts: {
      joinTo: "js/app.js",
      order: {
        before: [
          "bower_components/jquery/dist/jquery.min.js",
          "bower_components/underscore/underscore-min.js",
          "bower_components/bootstrap/dist/js/bootstrap.min.js",
        ]
      }
    },
    stylesheets: {
      joinTo: {
        'css/app.css': /^(web\/static\/css|bower_components)/
      },
      order: {
        before: [
          "bower_components/bootstrap/dist/css/bootstrap.min.css",
          "bower_components/slick-carousel/slick/slick-theme.css",
          "bower_components/font-awesome/css/font-awesome.min.css",
          // "bower_components/bootstrap/dist/css/bootstrap-theme.css",
        ]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }

    // javascripts: {
      // joinTo: "js/app.js",
    // },
    // stylesheets: {
      // joinTo: "css/app.css"
    // },
    // templates: {
      // joinTo: "js/app.js"
    // }

    // javascripts: {
      // joinTo: {
        // 'js/app.js': /^(web\/static\/js|bower_components)/
      // },
    // },
    // stylesheets: {
      // joinTo: {
        // 'css/app.css': /^(web\/static\/css|bower_components)/
      // }
    // },
    // templates: {
      // joinTo: 'js/app.js'
    // }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "deps/phoenix/web/static",
      "deps/phoenix_html/web/static",
      "web/static",
      "test/static",
      "bower_components/bootstrap/dist/css",
      "bower_components/slick-carousel/slick/slick-theme.css",
      "bower_components/font-awesome/css/font-awesome.min.css",
      // "bower_components/bootstrap/dist",
      // "bower_components/jquery/dist",
      // "bower_components/typeahead.js/dist",
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    },
    afterBrunch: [
      'mkdir -p priv/static/fonts',
      'cp -f bower_components/bootstrap/fonts/* priv/static/fonts',

      'mkdir -p priv/static/flags',
      'cp -pRf bower_components/flag-icon-css/flags/* priv/static/flags',

      'cp -f bower_components/slick-carousel/slick/fonts/* priv/static/css/fonts',
      'cp -f bower_components/slick-carousel/slick/ajax-loader.gif priv/static/css/',

      'cp -f bower_components/font-awesome/fonts/* priv/static/fonts',
    ]
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true
  }
};
