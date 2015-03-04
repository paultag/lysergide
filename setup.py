#!/usr/bin/env python

from setuptools import setup

long_description = open('README.md', 'r').read()

setup(
    name="lysergide",
    version="0.1",
    packages=['lysergide',],  # This is empty without the line below
    package_data={'lysergide': ['*.hy'],},
    author="Paul Tagliamonte",
    author_email="paultag@gmail.com",
    long_description=long_description,
    description='does some stuff with things & stuff',
    license="Expat",
    url="",
    platforms=['any']
)
