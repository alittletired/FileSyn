path = require 'path'
fs = require 'fs'
dateformat = require 'dateformat'
{spawn} = require 'child_process'
helper = require './helper'
module.exports = (project, fn)->
    emit=(event, msg)->
        fn({event:event,project: project, result: msg})
        console.log project+msg
    projectInfo=appConfig.getProjectInfo(project)
    return emit("notExist", "项目不存在") if not projectInfo.exists()
    emit "syncing", project
    cmd = helper.exec('pull', project)
    cmd.on "close", (code)->
      if (code != 0)
        retrycmd = helper.exec('pull', project)
        retrycmd.on "close",(retryCode)->
          if (code!=0)
            return emit "syncedError", cmd.error
          now=new Date()
          return emit "synced",  dateformat(now, 'yyyy-mm-dd HH:MM:ss')
      now=new Date()
      return emit "synced",  dateformat(now, 'yyyy-mm-dd HH:MM:ss')





