path = require 'path'
fs = require 'fs'
dateformat = require 'dateformat'
{spawn} = require 'child_process'
helper = require './helper'
module.exports = (project, fn)->
    emit=(event, msg)->
        fn({event:event,project: project, result: msg})
    projectInfo=appConfig.getProjectInfo(project)
    return emit("notExist", "项目不存在") if not projectInfo.exists()
    emit "syncing", "开始同步 #{project}"
    cmd = helper.exec('pull', project)
    cmd.on "close", (code)->
      if (code != 0)
        return emit "synced", "同步失败！！！\n" + cmd.error
      now=new Date()
      return emit "synced", "同步成功  " + dateformat(now, 'yyyy-mm-dd HH:MM:ss')




