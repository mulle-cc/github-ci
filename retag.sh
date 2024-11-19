#! /bin/sh

git tag -d v5
git push origin :v5

git tag v5 &&
git push && 
git push --tags

