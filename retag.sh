#! /bin/sh

git tag -d v4
git push origin :v4

git tag v4 &&
git push && 
git push --tags

