// Generated by CoffeeScript 1.6.2
var appConfig, client, fs, helper, print, publish;

fs = require('fs');

print = require('sys').print;

helper = require('../lib/helper');

client = require('socket.io-client');

appConfig = require('../appConfig');

publish = function(project) {
  var gitscript;

  project = project.toLowerCase();
  print("\n文件上传中，请等待...\n");
  gitscript = helper.exec('push', project);
  if (!gitscript) {
    return;
  }
  return gitscript.on('close', function(code) {
    var localSlave;

    if (code !== 0) {
      return print('发布失败，请检查原因\n ');
    }
    print("文件上传完毕，发送同步指令...\n");
    localSlave = client.connect(appConfig.masterHost + ":" + appConfig.port);
    localSlave.on('connect', function() {
      localSlave.on('message', function(message) {
        return print(message);
      });
      localSlave.on('syncEnd', function(message) {
        print(message);
        localSlave.disconnect();
        return process.exit();
      });
      return localSlave.emit("syncAll", project);
    });
    return localSlave.on('error', function(data) {
      return console.log("无法连接服务器");
    });
  });
};

module.exports = publish;

if (process.argv[1].endsWith("publish") || process.argv[1].endsWith("publish.js")) {
  helper.getName(publish);
}
