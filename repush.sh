#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v12
git push origin :v12

git tag v12 &&
git push origin &&
git push --tags
