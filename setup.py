# Copyright (c) 2012, Sven Thiele <sthiele78@gmail.com>
#
# This file is part of shogen.
#
# shogen is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# shogen is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with shogen.  If not, see <http://www.gnu.org/licenses/>.
# -*- coding: utf-8 -*-
from setuptools import setup
import os
import sys
import platform
import distutils
import site
import sysconfig

from setuptools.command.install import install as _install



class install(_install):
    def run(self):
        _install.run(self)
                         
setup(cmdclass={'install': install},
      name='shogen2',
      version='1.0',
      url='http://pypi.python.org/pypi/shogen2/',
      license='GPLv3+',
      description='Finding shortest genome segments that regulate metabolic pathways',
      long_description=open('README').read(),
      author='Sven Thiele',
      author_email='sthiele78@gmail.com',
      packages = ['__shogen2__'],
      package_dir = {'__shogen2__' : 'src'},
      package_data = {'__shogen2__' : ['encodings/*.lp']},
      scripts = ['shogen2.py'],
      install_requires=[
        "pyasp >= 1.2"
      ]
)