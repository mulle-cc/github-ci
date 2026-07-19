#! /bin/sh


git add -u &&
git commit -m "${1:-fix}" || exit 1

git tag -d v10
git push origin :v10

git tag v10 &&
git push origin &&
git push --tags
