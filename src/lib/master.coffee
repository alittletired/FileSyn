io = require('socket.io')
appConfig= require('/appConfig')
master=false
exports.getConnSlaves=()->
  ({'server':slave.endpoint,watch:slave.watchList}  for own slaveid, slave of master.sockets.sockets )

exports.listen = (server)->
    console.log  " 作为"+appConfig.runAs+"运行"
    exports.master = master = io.listen(server, {'log level': 0})
    master.sockets.on 'connection', (socket)->
      address= socket.handshake.address
      socket.endpoint=address.address+":"+address.port
      socket.watchList=[]
      console.log socket.endpoint+ " 成功连接"

      socket.on 'syncAll', (project)->
        checkTimeOut(project)
        synedcount=  0
        totalSalves=(slaveid for own slaveid, slave of master.sockets.sockets when slave.isSlave and not slave.disconnected and slave.id != socket.id)
        totalSalves=totalSalves.length
        for own slaveid, slave of master.sockets.sockets when slave.isSlave and not slave.disconnected and slave.id != socket.id
          slave.emit 'sync', project,(data)->
            socket.send  data.result  if data.event!='notExist'
            if data.event=='notExist' or data.event=='synced'
              synedcount++
            if synedcount==totalSalves
              socket.emit 'syncEnd','所有服务器同步完成'

      socket.on 'master', (watchs)->
        socket.isSlave=true
        socket.watchList=watchs if watchs

      socket.on "disconnect", ->
        console.log socket.endpoint + "已经断开连接"

      socket.on 'message', (data)->
          console.log data
