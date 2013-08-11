http = require 'http'
fs = require 'fs'
path = require 'path'
master = require './lib/master'
express = (require 'express')
app = express()
global.appConfig=require './appConfig'

app.use express.favicon()

app.use asset, express.static(__dirname + '/assets' + asset) for asset in ['/css', '/img', '/js', '/html']

app.get '/', (req, res)->
  res.end "server is ok"
app.get '/status', (req, res)->
  res.writeHead 200, {'Content-Type': 'text/html;charset=utf-8'}
  slaves=master.getConnSlaves()
  slave1=[]
  slaves=(JSON.stringify slave for slave in slaves)
  res.end "当前服务器：<br />"+slaves.join('<br />')

app.get '/api/:action/:id?', (req, res)->
    res.setHeader("Content-Type", 'text/javascript;charset=utf-8');
    action = require './api/' + req.params.action.toLowerCase()
    action.get(req, res);


app.use (err, req, res, next) ->
    console.error err.stack
    return res.send({ error: 'Not found' }) if req.accepts('json')
    return res.render('404', { url: req.url }) if req.accepts('html')
    return res.type('txt').send('Not found')

server = http.createServer(app)
require('./lib/master').listen(server) if  appConfig.runAs =="master"
server.listen(appConfig.port)
console.log "同步服务正在运行，请不要关闭..."

#从机
require('./lib/slave')


