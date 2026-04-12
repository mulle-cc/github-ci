#! /bin/sh

git tag -d v9
git push origin :v9

git tag v9 &&
git push && 
git push --tags

