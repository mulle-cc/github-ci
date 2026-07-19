#! /bin/sh

git tag -d v10
git push origin :v10

git tag v10 &&
git push && 
git push --tags

