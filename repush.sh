#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v9
git push origin :v9

git tag v9 &&
git push origin &&
git push --tags
