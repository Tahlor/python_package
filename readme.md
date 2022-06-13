# python_package

To create a new repo, copy this repo to a new folder with the name of the new repo and run `initialize.sh`.

# Install
pip3 install git+ssh://git@github.com/tahlor/python_package --upgrade




# Replace
find . -type f -name "*" -exec sed -i "s@python_package@python_package2@g" {} \;
