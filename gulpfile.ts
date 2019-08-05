import { series } from "gulp";
import { BurpConfig, BurpProcessor } from "burp-brightscript";
import { RooibosProcessor, createProcessorConfig } from "rooibos-cli";
import { MaestroProjectProcessor, createMaestroConfig } from 'maestro-cli-roku';

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
  return gulp.src(['out',
    'build',
    'samples/todo/src/source/maestro',
    'samples/todo/src/components/maestro'
  ], { allowEmpty: true }).pipe(gulpClean({ force: true }));
}

export function createDirectories() {
  return gulp.src('*.*', { read: false })
    .pipe(gulp.dest('./build'))
    .pipe(gulp.dest('./out'));
}

/**
 * This target is used for CI
 */
export async function prepareFrameworkTests(cb) {
  await rokuDeploy.prepublishToStaging(args);
  
  let config = createProcessorConfig({
    "projectPath": "out/.roku-deploy-staging",
    "testsFilePattern": [
      "**/tests/**/*.brs",
      "!**/rooibosDist.brs",
      "!**/rooibosFunctionMap.brs",
      "!**/TestsScene.brs"
    ]
  });
  let processor = new RooibosProcessor(config);
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
    'framework/src/source/maestro/**/*',
    'framework/src/components/maestro/**/*',
    'framework/src/source/rLog/**/*',
    'framework/src/components/rLogComponents/**/*'
  ], { base: './framework/src/' })
    .pipe(zip(`maestro${pkg.version}.zip`))
    .pipe(gulp.dest('./dist'));
}

function bundleNoRLog() {
  return gulp.src([
    'framework/src/source/maestro/**/*',
    'framework/src/components/maestro/**/*',
  ], { base: './framework/src/' })
    .pipe(zip(`maestro${pkg.version}-noRLog.zip`))
    .pipe(gulp.dest('./dist'));
}

function bundleCompiled() {
  return gulp.src([
    'build/source/maestro/**/*',
    'build/components/maestro/**/*',
    'build/source/rLog/**/*',
    'build/components/rLogComponents/**/*'
  ], { base: './build' })
    .pipe(zip(`maestro${pkg.version}-compiled.zip`))
    .pipe(gulp.dest('./dist'));
}

function bundleNoRLogCompiled() {
  return gulp.src([
    'build/source/maestro/**/*',
    'build/components/maestro/**/*',
  ], { base: './build' })
    .pipe(zip(`maestro${pkg.version}-noRLog-compiled.zip`))
    .pipe(gulp.dest('./dist'));
}


export function copyToSamples(cb) {
  let maestroSourcePath = 'framework/src/source/maestro';
  let maestroComponentsPath = 'framework/src/components/maestro';

  ['todoXMLBindings', 'todo', 'eloquently-managing-deep-linking'].forEach((sampleName) => {
    fs.copySync(maestroSourcePath, `samples/${sampleName}/src/source/maestro`);
    fs.copySync(maestroComponentsPath, `samples/${sampleName}/src/components/maestro`);
  });

  cb();
}

export function updateVersion(cb) {
  fs.writeFileSync("docs/version.txt", pkg.version); 
  cb();
}

exports.build = series(clean, createDirectories, compile, copyToSamples);
exports.prePublishTests = series(exports.build, prepareFrameworkTests, addDevLogs)
exports.runTests = series(exports.prePublishTests, zipTests, deployTests)
exports.dist = series(exports.build, doc, bundle, bundleNoRLog, bundleCompiled, bundleNoRLogCompiled, updateVersion);
