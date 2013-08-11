request = require 'request'
request = require '../lib/slave'
sync = require './sync'
client = require 'socket.io-client'
exports.get = (req, res)->
    project = req.params.id
    slave.res = res
    slave.emit("syncAll", project)
    sync.get(req, res, false)







