sync = require('../lib/sync')
helper = require('./helper')
client = require('socket.io-client')
fs = require('fs')
appConfig= require('/appConfig')
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
        console.log   data.result

  slave.on 'message', (msg) ->
      console.log msg

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

watchDir = (projectInfo)->
    watcher= fs.watch projectInfo.root + projectInfo.dir, (event, filename)->
        if(filename == ".git")
            return;
        console.log "监视到 #{filename} 变动,事件 #{event}，#{appConfig.watchInterval} 分钟后将同步..."
        watcher.close()
        setTimeout (->
            console.log "\n监视服务器,文件上传中，请等待...\n"
            cmd=helper.exec('push', project)
            cmd.on 'close', (code)->
                return console.log '自动同步失败，请检查原因\n ' if code != 0
                console.log "文件自动上传完毕，发送同步指令...\n"
                slave.emit("syncAll", project.toLowerCase())
                watchDir projectInfo
        ), 1000 * 60 * appConfig.watchInterval


return if not appConfig.watch
for project in appConfig.watch
    projectInfo= appConfig.getProjectInfo(project)
    console.log "监视项目#{project},文件夹#{projectInfo.root}#{projectInfo.dir}"
    return if not projectInfo.exists
    watchDir(projectInfo)



