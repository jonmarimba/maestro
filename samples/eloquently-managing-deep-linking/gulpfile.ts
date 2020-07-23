import { series } from "gulp";
import { BurpConfig, BurpProcessor } from "burp-brightscript";
import { MaestroProjectProcessor, createMaestroConfig } from 'maestro-cli-roku';

const gulp = require('gulp');
const gulpClean = require('gulp-clean');
const outDir = './build';
const rokuDeploy = require('roku-deploy');

let args = {
  host: process.env.ROKU_HOST || '192.168.16.3',
  username: process.env.ROKU_USER || 'rokudev',
  password: process.env.ROKU_PASSWORD || 'aaaa',
  rootDir: './build',
  files: ['**/*'],
  outDir: './out',
  retainStagingFolder: true
};

export function clean() {
  console.log('Doing a clean at ' + outDir);
  return gulp.src(['out', 'build'], { allowEmpty: true }).pipe(gulpClean({ force: true }));
}

export function createDirectories() {
  return gulp.src('*.*', { read: false })
    .pipe(gulp.dest('./build'))
    .pipe(gulp.dest('./out'));
}

export function addDevLogs(cb) {
  let config: BurpConfig = {
    "sourcePath": "build",
    "globPattern": "**/*.brs",
    "replacements": [
      {
        "regex": "(^.*(m\\.)*(logInfo|logError|logVerbose|logDebug)\\((\\s*\"))",
        "replacement": "$1#FullPath# "
      },
      {
        "regex": "(^.*(m\\.)*(logMethod)\\((\\s*\"))",
        "replacement": "$1#FullPath# "
      }
    ]
  }
  const processor = new BurpProcessor(config);
  processor.processFiles();
  cb();
}

export async function deploy(cb) {
  await rokuDeploy.publish(args);
}

async function compile(cb) {
  let config = createMaestroConfig({
    "filePattern": [
      "**/*.bs",
      "**/*.brs",
      "**/*.xml",
    ],
    "sourcePaths": ["src"],
    "outputPath": "build",
    "logLevel": 4,
    "nonCheckedImports": ['source/rLog/rLogMixin.brs',
      'source/tests/rooibosDist.brs',
      'source/tests/rooibosFunctionMap.brs'
    ]
  });
  let processor = new MaestroProjectProcessor(config);
  await processor.processFiles();
}

exports.build = series(clean, createDirectories, compile);
exports.prePublish = series(exports.build, addDevLogs)
