io = require('socket.io')
appConfig= require('../appConfig')
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
        synedcount=  0
        totalSalves={}
        for own slaveid, slave of master.sockets.sockets when slave.isSlave and not slave.disconnected and slaveid!= socket.id
          totalSalves[slaveid] =  slave
          do(slave) ->
            slave.emit 'sync', project,(data)->
              return if   not   totalSalves[slave.id]
              if data.event!='notExist'
                data.result=   slave.endpoint+' '+ data.result
                socket.emit 'syncedResult',data
              console.log data.result
              if data.event!='syncing'
                delete  totalSalves[slave.id]
              c=(val.endpoint for own key,val of totalSalves)
              if c.length>0
                console.log  "还存在"+ c.join(' ')
                return
              return socket.emit 'syncedResult',{result:'所有服务器同步完成',project:project,event:'syncEnd'}

      socket.on 'master', (watchs)->
        socket.isSlave=true
        socket.watchList=watchs if watchs
      socket.on 'execCommand',(data)->
        return  socket.send '没有权限' if data.validcode!='D910F6E3665320D6A5CA6C15399BA902'
        return  socket.send '消息为空' if not  data.cmd
        return  socket.send '没有选择服务器' if   data.endpoints==null or data.endpoints.length==0
        for own slaveid, slave of master.sockets.sockets
          for endpoint in  data.endpoints
            if slave.endpoint ==  endpoint
              slave.emit  'execCommand', data.cmd,(msg)->
                console.log  slave.endpoint+ msg
                socket.send slave.endpoint+ msg
              break

      socket.on "disconnect", ->
        console.log socket.endpoint + "已经断开连接"

      socket.on 'message', (data)->
          console.log data
