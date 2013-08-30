fs = require("fs")
path = require 'path'
defaultConfig = {
"debug": false,
"logger": true,
"masterHost": "http://42.121.119.196",
"projectRoot": "d:\\web\\",
"port": 8656,
"runAs": "slave",
"watchInterval": 5,
"remoteGit": "http://administrator:yftech258456@42.121.119.196:8655/",
"projects":
    "filesyn":
        {"root": "d:\\web\\", "dir": "filesyn"}
}

configfile = path.join __dirname, 'config', 'config.json'
if fs.existsSync(configfile)
  config = require './config/config.json'
  for key,val of config
    defaultConfig[key] = val
defaultConfig.config=defaultConfig.config||{}
defaultConfig.getProjectInfo = (project)->
    project = project.toLowerCase()
    if defaultConfig.projects[project]
        repo=defaultConfig.projects[project];
        projectInfo= {root: repo.root, dir: repo.dir or project,project:project}
    else
        projectInfo={root: defaultConfig.projectRoot, dir: project,project:project}


    projectInfo.exists =-> fs.existsSync(projectInfo.root + projectInfo.dir)
    return projectInfo

module.exports = defaultConfig
global.appConfig=defaultConfig