#!/bin/bash

git remote -v
git fetch origin master
git branch -a
git diff --name-only origin/master -- > difflist.txt
cat difflist.txt
grep '.sl$' difflist.txt > changed_items.txt
sed -i -e 's/\//\./g' changed_items.txt
sed -i -e 's/test\.//g' changed_items.txt
sed -i -e 's/content\.//g' changed_items.txt
sed -i -e 's/\.sl//g' changed_items.txt
cat changed_items.txt