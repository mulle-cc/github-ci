#! /bin/sh

git tag -d v7
git push origin :v7

git tag v7 &&
git push && 
git push --tags

