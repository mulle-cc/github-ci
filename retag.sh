#! /bin/sh

git tag -d v8
git push origin :v8

git tag v8 &&
git push && 
git push --tags

