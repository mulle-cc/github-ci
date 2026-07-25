#! /bin/sh

git tag -d v11
git push origin :v11

git tag v11 &&
git push && 
git push --tags

