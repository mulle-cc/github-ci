#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v8
git push origin :v8

git tag v8 &&
git push origin &&
git push --tags
