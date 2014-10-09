"use strict";

var translate_obj = require('../utils').translate;

module.exports = function translate () {

  return function translateMiddleWare(req, res, next){
    res.locals.translate = function(obj) {
      var langs = ( req.accept && req.accept.languages ) || [];
      var defaultLang = 'en';
      return translate_obj(obj, langs, defaultLang);
    };

    next();
  };
};
