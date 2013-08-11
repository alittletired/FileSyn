{print} = require 'sys'
appConfig = require '../appConfig'
helper = require '../lib/helper'
fs = require 'fs'

clone = (project)->
    projectInfo= appConfig.getProjectInfo(project)
    fs.mkdirSync(projectInfo.root + projectInfo.dir) if not projectInfo.exists
    cmd=helper.exec("clone", project)
    cmd.on 'close', (code)->
        return print '操作失败，请检查原因\n ' if code != 0
        print "操作成功！！\n"
        process.exit()

module.exports = clone

helper.getName clone if  process.argv[1].endsWith("clone") or process.argv[1].endsWith("clone.js")


#setx path "%path%;d:\web\fliesyn\bin;"