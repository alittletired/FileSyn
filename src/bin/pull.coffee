{print} = require 'sys'
helper = require '../lib/helper'

pull = (project)->
    cmd=helper.exec('pull', project)
    cmd.on 'close', (code)->
        return print '操作失败，请检查原因\n ' if code != 0
        print "操作成功！！\n"
        process.exit()

module.exports = pull

helper.getName pull if  process.argv[1].endsWith("pull") or process.argv[1].endsWith("pull.js")
