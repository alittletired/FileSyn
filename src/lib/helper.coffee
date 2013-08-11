appConfig = require '../appConfig'
path = require "path"
{print} = require 'sys'
readline = require('readline')
{spawn, exec} = require 'child_process'
fs = require 'fs'
readline = require('readline')

exec = (cmdName, project, argv)->
    if not project
        print "项目名称不能为空"
        return false
    projectInfo=appConfig.getProjectInfo(project)
    params=[project, projectInfo.root, projectInfo.dir, appConfig.remoteGit, projectInfo.root.split(':')[0] + ":"]
    params.push arg for arg in argv if argv?
    cmd = spawn path.join(__dirname, "../cmd/#{cmdName}.cmd"), params
    cmd.stdout.on 'data', (data) -> print data.toString()
    cmd.stderr.on 'data', (data) ->
        print data.toString()
        cmd.error = data
    return cmd

exports.exec = exec
exports.getName = (callback)->
    args = process.argv.splice(2)
    if(args[0])
        callback.apply(this,args)
    else
        rl = readline.createInterface({input: process.stdin, output: process.stdout})
        rl.question "请输入项目名称：        ", (p)->
            rl.close()
            callback p


String.prototype.endsWith = (str, caseInsensitive = true)->
    reg= new RegExp str.replace(/[$%()*+.?\[\\\]{|}]/g, "\\$&") + "$", if caseInsensitive then "i" else ""
    return reg.test this

String.prototype.startsWith = (str, caseInsensitive = true)->
    reg= new RegExp "^" + str.replace(/[$%()*+.?\[\\\]{|}]/g, "\\$&"), if caseInsensitive then "i" else ""
    return reg.test this