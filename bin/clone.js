// Generated by CoffeeScript 1.6.3
var appConfig, clone, fs, helper, print;

print = require('sys').print;

appConfig = require('../appConfig');

helper = require('../lib/helper');

fs = require('fs');

clone = function(project) {
  var cmd, projectInfo;
  projectInfo = appConfig.getProjectInfo(project);
  if (!projectInfo.exists) {
    fs.mkdirSync(projectInfo.root + projectInfo.dir);
  }
  cmd = helper.exec("clone", project);
  return cmd.on('close', function(code) {
    if (code !== 0) {
      return print('操作失败，请检查原因\n ');
    }
    print("操作成功！！\n");
    return process.exit();
  });
};

module.exports = clone;

if (process.argv[1].endsWith("clone") || process.argv[1].endsWith("clone.js")) {
  helper.getName(clone);
}
