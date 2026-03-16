#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v7
git push origin :v7

git tag v7 &&
git push origin &&
git push --tags
