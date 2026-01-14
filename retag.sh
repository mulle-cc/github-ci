#! /bin/sh

git tag -d v6
git push origin :v6

git tag v6 &&
git push && 
git push --tags

