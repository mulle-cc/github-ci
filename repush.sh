#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v11
git push origin :v11

git tag v11 &&
git push origin &&
git push --tags
