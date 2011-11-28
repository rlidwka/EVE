/*!
* eve 0.0.1
*
* Copyright (c) 2011 Hidden
* Released under the MIT, BSD, and GPL Licenses.
*
* Date: 2011-09-22
*/

var eve = exports;
var validator = require("./validator.js");
var type = require("./type.js");

var number = require("./number.js");
var number = require("./string.js");
var number = require("./date.js");
var number = require("./object.js");

/**
* Library version.
*/

eve.version = '0.0.1';

/**
* Basic validator
*/

eve.validator = validator;

/**
* Schema type
*/

eve.type = type;