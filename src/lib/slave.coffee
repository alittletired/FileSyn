sync = require('../lib/sync')
helper = require('./helper')
path =require 'path'
exec = require('child_process').exec
client = require('socket.io-client')
fs = require('fs')
appConfig= require('../appConfig')
mail= require('../lib/mail')
wait = (milliseconds, func)-> return setTimeout(func, milliseconds)
syncErrors={}
return if not appConfig.masterHost
isConnect = false
slave = client.connect(appConfig.masterHost + ":" + appConfig.port)
console.log "正在连接"+appConfig.masterHost + ":" + appConfig.port
slave.on 'connect', ->
  console.log "已与服务器建立连接:"+appConfig.masterHost + ":" + appConfig.port
  isConnect = true
  global.slave = slave
  slave.emit 'master',appConfig.watch||[]

  slave.on 'sync', (project,fn) ->
      console.log "接收到同步指令"+project
      sync project, (data)->
        fn(data)
        #console.log  JSON.stringify(data)

  slave.on 'message', (msg) ->
      console.log msg

  slave.on 'syncEnd', (msg) ->
    console.log msg

  slave.on 'syncedResult', (msg) ->
    console.log '开始同步 '+ msg.result if  msg.event =='syncing'
    console.log '同步成功 '+ msg.result if  msg.event =='synced'
    console.log '同步失败 '+ msg.result if  msg.event =='syncedError'
    syncErrors[msg.project].push(msg.result)  if  msg.event =='syncedError'
    if  msg.event =='syncEnd'
      console.log msg.result
      return syncErrors[msg.project].length==0
      for project in appConfig.watch
        mail.sendMail({html:syncErrors[msg.project].join('<br />')})   if project==msg.project

  slave.on 'execCommand',(cmd,fn)->
    exec cmd, (error, stdout, stderr)->
      fn '执行失败 '+  error if error
      fn '执行成功 '+ stdout if not error

  slave.on 'disconnect', ->
      isConnect = false
      reconnct()




slave.on 'error', (data) ->
    console.log "无法连接服务器"+appConfig.masterHost + ":" + appConfig.port
    reconnct()

reconnct = ->
    return if isConnect
    slave.socket.reconnect()
    setTimeout reconnct, 30000
#防止提交过于频繁，监视项目,5分钟提交一次

watchDir = (projectInfo,realpath)->
    realpath= realpath or    ( projectInfo.root + projectInfo.dir)
    #console.log    realpath
    watcher= fs.watch realpath, (event, filename)->
        if(filename == ".git")
            return;
        console.log "监视到 #{filename} 变动,事件 #{event}，#{appConfig.watchInterval} 分钟后将同步..."
        onWatchDirChange projectInfo
    watcherDict[projectInfo.dir].push(watcher)
    fs.readdir realpath,(err, files)->
      return if err
      for  rawfile in    files
        continue if rawfile=='.git'

        file = path.join(realpath, rawfile)

        fs.stat file,  (err, stat) ->

          if !err && stat&& stat.isDirectory()
            watchDir  projectInfo ,file

watcherDict={}
onWatchDirChange=(projectInfo)->
  watcher.close() for watcher in  watcherDict[projectInfo.dir]
  watcherDict[projectInfo.dir]=[]
  wait 1000 * 60 * appConfig.watchInterval,->
    console.log "\n监视服务器,文件上传中，请等待...\n"
    cmd=helper.exec('push', projectInfo.project)
    cmd.on 'close', (code)->
      return console.log '自动同步失败，请检查原因\n ' if code != 0
      console.log "文件自动上传完毕，发送同步指令...\n"
      syncErrors[projectInfo.project.toLowerCase()]=[]
      slave.emit("syncAll", projectInfo.project.toLowerCase())
      watchDir projectInfo


return if not appConfig.watch
for project in appConfig.watch
    projectInfo= appConfig.getProjectInfo(project)

    return if not projectInfo.exists
    console.log "监视项目#{project},文件夹#{projectInfo.root}#{projectInfo.dir}"
    watcherDict[projectInfo.dir]=[]
    watchDir(projectInfo)



