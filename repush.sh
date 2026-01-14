#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v6
git push origin :v6

git tag v6 &&
git push origin &&
git push --tags
