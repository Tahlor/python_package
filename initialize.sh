#!/bin/bash
#
# ./create.sh PACKAGE_NAME USER TOKEN EMAIL
PACKAGE_NAME=${1-new_package}
USER=${2-tahlor}
TOKEN=${3-$GITHUB_TOKEN}
EMAIL=${4-taylor.archibald@byu.edu}

# Remove old git
rm .git -rf

# Rename files

# find and replace in the files
find . -type f -name "*" -exec sed -i "s@python_package@${PACKAGE_NAME}@g" {} \;
find . -type f -name "*" -exec sed -i "s|taylornarchibald@gmail.com|${EMAIL}|g" {} \;
find . -type f -name "*" -exec sed -i "s@tahlor@${USER}@g" {} \;
find . -type f -name "*" -exec sed -i "s@version=.*@version='0.0.1'@g" {} \;

# initialize new git
curl -u $USER:$GITHUB_TOKEN https://api.github.com/user/repos -d '{"name":"$new_package"}'

git init
git commit -m "first commit"
git branch -M master
git remote add origin git@github.com:$USER/${PACKAGE_NAME}.git
git push -u origin main

