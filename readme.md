# Install
pip3 install git+ssh://git@github.com/Tahlor/python_package --upgrade

# Replace
find . -type f -name "*" -exec sed -i "s@python_package@python_package2@g" {} \;
