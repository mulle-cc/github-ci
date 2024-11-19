#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v5
git push origin :v5

git tag v5 &&
git push origin &&
git push --tags
