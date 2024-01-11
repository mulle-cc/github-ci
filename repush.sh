#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v4
git push origin :v4

git tag v4 &&
git push origin &&
git push --tags
