sync = require('../lib/sync')
exports.get = (req, res, autoend = true) ->
    project = req.params.id
    send= (evt, msg)->
        switch evt
            when "syncing" then res.write '正在同步本地\n'
            else
                if msg
                    result=  msg.result or msg
                    if autoend then  res.end result else res.write result

    sync(project, null, send)


