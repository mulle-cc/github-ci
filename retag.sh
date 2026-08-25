#! /bin/sh

git tag -d v12
git push origin :v12

git tag v12 &&
git push && 
git push --tags

