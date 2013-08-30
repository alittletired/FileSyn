fs = require 'fs'
{print} = require 'sys'
helper = require '../lib/helper'
client = require('socket.io-client')
appConfig = require '../appConfig'

publish = (project)->
    project = project.toLowerCase()
    print "\n文件上传中，请等待...\n"
    gitscript=helper.exec('push', project)
    return if not gitscript
    gitscript.on 'close', (code)->
        return print '发布失败，请检查原因\n ' if code != 0
        print "文件上传完毕，发送同步指令...\n"
        localSlave= client.connect(appConfig.masterHost + ":" + appConfig.port)
        localSlave.on 'connect', ->
          localSlave.on 'syncedResult', (msg) ->
            console.log '开始同步 '+ msg.result if  msg.event =='syncing'
            console.log '同步成功 '+ msg.result if  msg.event =='synced'
            console.log '同步失败 '+ msg.result if  msg.event =='syncedError'
            if  msg.event =='syncEnd'
              console.log msg.result
              localSlave.disconnect()
              process.exit()


        localSlave.emit("syncAll", project.toLowerCase())
        localSlave.on 'error', (data) ->
            console.log "无法连接服务器"

module.exports = publish

helper.getName publish if  process.argv[1].endsWith("publish") or process.argv[1].endsWith("publish.js")

