// Generated by CoffeeScript 1.6.2
var client, request, sync;

request = require('request');

request = require('../lib/slave');

sync = require('./sync');

client = require('socket.io-client');

exports.get = function(req, res) {
  var project;

  project = req.params.id;
  slave.res = res;
  slave.emit("syncAll", project);
  return sync.get(req, res, false);
};