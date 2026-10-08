#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v13
git push origin :v13

git tag v13 &&
git push origin &&
git push --tags
