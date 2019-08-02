import { series } from "gulp";
import { BurpConfig, BurpProcessor } from "burp-brightscript";
import { RooibosProcessor } from "rooibos-preprocessor";
import { MaestroProjectProcessor, createMaestroConfig } from 'maestro-cli';

import * as fs from 'fs-extra';
import * as path from 'path';

const gulp = require('gulp');
const gulpClean = require('gulp-clean');
const outDir = './build';
const rokuDeploy = require('roku-deploy');
const cp = require('child_process');
const pkg = require('./package.json');
const zip = require('gulp-zip');

let args = {
  host: process.env.ROKU_HOST || '192.168.16.3',
  username: process.env.ROKU_USER || 'rokudev',
  password: process.env.ROKU_PASSWORD || 'aaaa',
  rootDir: './build',
  files: ['**/*'],
  outDir: './out',
  retainStagingFolder: true
};

function setEnvTest(args) {
  args.files = ['src/**/*'];
}

export function clean() {
  console.log('Doing a clean at ' + outDir);
  return gulp.src(['out', 'build'], { allowEmpty: true }).pipe(gulpClean({ force: true }));
}

export function createDirectories() {
  return gulp.src('*.*', { read: false })
    .pipe(gulp.dest('./build'))
    .pipe(gulp.dest('./out'));
}

/**
 * This target is used for CI
 */
export async function prepareTests(cb) {
  let processor = new RooibosProcessor('build/source/tests', 'build', 'build/source/tests');
  processor.processFiles();

  cb();
}

export async function deployTests(cb) {
  setEnvTest(args);
  await rokuDeploy.publish(args);
}

export async function zipTests(cb) {
  setEnvTest(args);
  await rokuDeploy.zipPackage(args);
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

export function doc(cb) {
  let task = cp.exec('./node_modules/.bin/jsdoc -c jsdoc.json -t node_modules/minami -d docs');
  return task;
}

async function compile(cb) {
  let config = createMaestroConfig({
    "filePattern": [
      "**/*.bs",
      "**/*.brs",
      "**/*.xml"
    ],
    "processingExcludedPaths": [
      'components/rLogComponents/**/*.*',
      'source/rLog/**/*.*',
      'source/tests/rooibosDist.brs',
      'source/tests/rooibosFunctionMap.brs'
    ],
    "sourcePath": "/Users/georgecook/Documents/h7ci/hope/maestro/framework/src",
    "outputPath": "build",
    "logLevel": 4,
    "nonCheckedImports": ['source/rLog/rLogMixin.brs',
      'source/tests/rooibosDist.brs',
      'source/tests/rooibosFunctionMap.brs'
    ]
  });
  let processor = new MaestroProjectProcessor(config);
  await processor.processFiles();
  cb();
}

function bundle() {
  return gulp.src([
    'build/source/maestro/**/*',
    'build/components/maestro/**/*',
    'build/source/rLog/**/*',
    'build/components/rLogComponents/**/*'
  ], { base: './build' })
    .pipe(zip(`maestro${pkg.version}.zip`))
    .pipe(gulp.dest('./dist'));
}

function bundleNoRLog() {
  return gulp.src([
    'build/source/maestro/**/*',
    'build/components/maestro/**/*',
  ], { base: './build' })
    .pipe(zip(`maestro${pkg.version}-noRLog.zip`))
    .pipe(gulp.dest('./dist'));
}

exports.build = series(clean, createDirectories, compile);
exports.prePublishTests = series(exports.build, prepareTests, addDevLogs)
exports.runTests = series(exports.prePublishTests, zipTests, deployTests)
exports.dist = series(exports.build, doc, bundle, bundleNoRLog);
