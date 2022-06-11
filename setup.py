#!/usr/bin/env python

from setuptools import setup
try:
    from pypandoc import convert
    read_md = lambda f: convert(f, 'rst')
except ImportError:
    print("warning: pypandoc module not found, could not convert Markdown to RST")
    read_md = lambda f: open(f, 'r').read()

import os

with open('requirements.txt') as f:
    requirements = f.read().splitlines()
print(requirements)

setup(name='general_tools',
      version='0.0.34',
      description='General tools',
      long_description= "" if not os.path.isfile("README.md") else read_md('README.md'),
      author='Taylor Archibald',
      author_email='taylor.archibald@medic.life',
      url='https://github.com/NewVistas/medic-data-generic',
      setup_requires=['pytest-runner',],
      tests_require=['pytest','python-coveralls'],
      packages=['general_tools'],
      install_requires=[
          *requirements,
      ],
     )
