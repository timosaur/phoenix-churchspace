exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js"

      // To use a separate vendor.js bundle, specify two files path
      // http://brunch.io/docs/config#-files-
      // joinTo: {
      //  "js/app.js": /^(web\/static\/js)/,
      //  "js/vendor.js": /^(web\/static\/vendor)|(deps)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // order: {
      //   before: [
      //     "web/static/vendor/js/jquery-2.1.1.js",
      //     "web/static/vendor/js/bootstrap.min.js"
      //   ]
      // }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        before: ["web/static/css/app.scss"]
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
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
      "node_modules/bootstrap-sass/assets/javascripts",
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [
        /web\/static\/vendor/,
        "node_modules/sidr/dist/jquery.sidr.min.js",
      ]
    },
    sass: {
      options: {
        includePaths: [
          "node_modules/bootstrap-sass/assets/stylesheets",
        ],
      },
      precision: 8,
    },
    copycat: {
      "css/font": [
        "node_modules/summernote/dist/font",
      ],
      "fonts": [
        "node_modules/bootstrap-sass/assets/fonts/bootstrap",
      ],
    },
  },

  modules: {
    autoRequire: {
      "js/app.js": [
        "web/static/js/app",
      ],
    }
  },

  npm: {
    enabled: true,
    styles: {
      summernote: ["dist/"],
    },
    static: [
      "node_modules/sidr/dist/jquery.sidr.min.js",
      "node_modules/summernote/dist/summernote.min.js",
    ],
    globals: {
      $: "jquery",
      jQuery: "jquery",
    }
  }
};
