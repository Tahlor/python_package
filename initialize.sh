#!/bin/bash
#
# ./create.sh PACKAGE_NAME GITHUB_USER TOKEN EMAIL

### repo not fully created?
### not pushing: git push --set-upstream origin master

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
FILE="$(basename "${SCRIPT_DIR}")"
echo $FILE

PACKAGE_NAME=${1:-$FILE}
OLD_PACKAGE_NAME=${2:-python_package}
GITHUB_USER=${3:-tahlor}
TOKEN=${4:-$GITHUB_TOKEN}
EMAIL=${5:-taylor.archibald@byu.edu}
PRIVATE=${6:-true}
RECREATE=${7:-true}

read -r -p "Package Name ($PACKAGE_NAME): " PACKAGE_NAME1
PACKAGE_NAME=${PACKAGE_NAME1:-$PACKAGE_NAME}
read -r -p "Github User ($GITHUB_USER): " GITHUB_USER1
GITHUB_USER=${GITHUB_USER1:-$GITHUB_USER}
read -r -p "GitHub Token ($TOKEN): " TOKEN1
TOKEN=${TOKEN1:-$TOKEN}
read -r -p "Email ($EMAIL): " EMAIL1
EMAIL=${EMAIL1:-$EMAIL}
read -r -p "Recreate GIT?: Y/n " RECREATE1
RECREATE=${RECREATE1:-$RECREATE}

case $RECREATE in
    [Yy]* ) RECREATE=true;;
    [Nn]* ) RECREATE=false;;
    * ) echo "Unrecognized response"; RECREATE=true;;
esac

PACKAGE_NAME=`echo "$PACKAGE_NAME" | sed -E -e 's/ /-/g'`
SAFE_PACKAGE_NAME=`echo "$PACKAGE_NAME" | sed -E -e 's/ |-/_/g'`


# Remove old git
if $RECREATE; then
    rm .git -rf
fi;

# Rename files
#package_files=$(ls . |grep .mp4)
exclude_git='-not -path *.git*'
exclude='-not -path *.git* -not -path *./initialize.sh'

for filename in `find . -type 'f,d' -name $OLD_PACKAGE_NAME $exclude_git`;
do
    new_file=`echo "$filename" | sed -e "s/${OLD_PACKAGE_NAME}/$PACKAGE_NAME/g"`
    if [ "$filename" != "$new_file" ]; then
        mv "$filename" "$new_file"
    fi
done

# find and replace in the files
find . -type f -name "*" $exclude_git -exec sed -i "s@${OLD_PACKAGE_NAME}@${PACKAGE_NAME}@g" {} \;
find . -type f -name "*" $exclude -exec sed -i "s|taylornarchibald@gmail.com|${EMAIL}|g" {} \;
find . -type f -name "*" $exclude -exec sed -i "s@tahlor@${GITHUB_USER}@g" {} \;
find . -type f -name "*" $exclude -exec sed -i "s@version=.*@version='0.0.1',@g" {} \;

echo $PACKAGE_NAME
echo $SAFE_PACKAGE_NAME
echo $GITHUB_USER
echo $EMAIL
echo $TOKEN

if $RECREATE; then
    # initialize new git
    curl -u $GITHUB_USER:$TOKEN https://api.github.com/user/repos -d "{\"name\":\"$SAFE_PACKAGE_NAME\", \"private\": $PRIVATE}"

    git init
    git add .
    git commit -m "first commit"
    git branch -M master
    git remote add origin git@github.com:$GITHUB_USER/${SAFE_PACKAGE_NAME}.git
    # Force push master in case it was recreated
    git push -uf origin master
    #git push --set-upstream origin master
fi
