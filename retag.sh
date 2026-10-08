#! /bin/sh

git tag -d v13
git push origin :v13

git tag v13 &&
git push && 
git push --tags

