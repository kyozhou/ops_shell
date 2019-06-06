#!/bin/bash

echo "start..."
oldRepo=$1
newRepo=$2

baseDir=`echo ~/temp`
mkdir $baseDir

cd $baseDir & git clone git@git.mirahome.net:$oldRepo $baseDir/repo_temp
cd $baseDir/repo_temp
git push --mirror $newRepo
rm -rf $baseDir/repo_temp
