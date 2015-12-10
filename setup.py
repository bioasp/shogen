# Copyright (c) 2014, Sven Thiele <sthiele78@gmail.com>
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

                         
setup(
  name             = 'shogen',
  version          = '2.0.0',
  url              = 'http://pypi.python.org/pypi/shogen/',
  license          = 'GPLv3+',
  description      = 'Finding shortest genome segments that regulate metabolic pathways',
  long_description = open('README.rst').read(),
  author           = 'Sven Thiele',
  author_email     = 'sthiele78@gmail.com',
  packages         = ['__shogen__'],
  package_dir      = {'__shogen__' : 'src'},
  package_data     = {'__shogen__' : ['encodings/*.lp']},
  scripts          = ['shogen.py'],
  install_requires = ['pyasp == 1.4' ]
)
