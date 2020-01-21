<p align="center">
  <img src="https://github.com/georgejecook/maestro/blob/master/docs/maestroLogo.png" alt="Maestro for roku" />
</p>
<h3 align="center">
A development platform for building roku channels in brighterscript
</h3>
<p align="center">
  <img src="images/exampleImage.png" alt="Maestro for roku" />
</p>

[![Build Status](https://travis-ci.org/georgejecook/maestro.svg?branch=master)](https://travis-ci.org/georgejecook/maestro)
[![GitHub](https://img.shields.io/github/release/georgejecook/maestro.svg?style=flat-square)](https://github.com/georgejecook/meastro/releases) 

# Control sample

This sample shows off some of the controls offered by maestro

## Links
 - **[Documentation](https://github.com/georgejecook/maestro/blob/master/docs/index.md)**
 - **[API documentatio](https://georgejecook.github.io/maestro)**
 - \#maestro channel on the [roku developer's slack](https://join.slack.com/t/rokudevelopers/shared_invite/enQtMzgyODg0ODY0NDM5LTc2ZDdhZWI2MDBmYjcwYTk5MmE1MTYwMTA2NGVjZmJiNWM4ZWY2MjY1MDY0MmViNmQ1ZWRmMWUzYTVhNzJiY2M)

## Using these samples

 - Download this repo
 - Run `npm install`
 - Run `gulp build`
 - `cd` into this sample's folder
 - Run `npm install`
 - Use the PrePublis gulp task, or add the following launch configurations and tasks

## Example launchConfig
Copy this into your `.vscode/launch.json`


 ```
     {
      "type": "brightscript",
      "request": "launch",
      "name": "Run",
      "preLaunchTask": "build",
      "internalConsoleOptions": "neverOpen",
      "envFile": "${workspaceFolder}/devScripts/.env",
      "host": "${env:ROKU_DEV_TARGET}",
      "password": "${env:ROKU_DEVPASSWORD}",
      "outDir": "${workspaceFolder}/out",
      "rootDir": "${workspaceFolder}/build",
      "sourceDirs": [
        "${workspaceFolder}/src"
      ],
      "consoleOutput": "normal",
      "stopOnEntry": false,
      "retainDeploymentArchive": true,
      "retainStagingFolder": true,
      "files": [
        "manifest",
        "source/**/*.*",
        "components/**/*.*",
        "images/**/*.*",
        "!**/tests/**/*.*"
      ],
      "enableDebuggerAutoRecovery": true,
      "stopDebuggerOnAppExit": true

 ```
## Example tasks

Copy this into your `.vscode/tasks.json`

 ```
 {
  // See https://go.microsoft.com/fwlink/?LinkId=733558
  // for the documentation about the tasks.json format
  // Note running gulptasks in vsce takes us away from the bs log window, so I always wrap my gulp command in shell
  // scripts, which I can prevent from doing that annoying behaviour

  "version": "2.0.0",
  "tasks": [
    {
      "label": "build",
      "type": "shell",
      "command": "${workspaceFolder}/devScripts/build.sh",
      "presentation": {
        "echo": true,
        "reveal": "silent",
        "focus": false,
        "panel": "shared",
        "showReuseMessage": false,
        "clear": true
      },
      "group": {
        "kind": "test",
        "isDefault": true
      }
    },
    {
      "label": "buildTests",
      "type": "shell",
      "command": "${workspaceFolder}/devScripts/buildTests.sh",
      "presentation": {
        "echo": true,
        "reveal": "silent",
        "focus": false,
        "panel": "shared",
        "showReuseMessage": false,
        "clear": true
      },
      "group": {
        "kind": "test",
        "isDefault": true
      }
    }
  ]
}
 ```
 