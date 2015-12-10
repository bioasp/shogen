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
import os
from pyasp.asp import *



def read_genome(genome_string) :
  instance = TermSet()
  genome_f = open(genome_string, "r")
  genome   = genome_f.read().replace('\r\n','\n').split()
  dictg    = {} # Dictionnary for the genes
  revdictg = [0]
  g        = 0 # Counter to define the matchings between real names and ASP names

  for line in genome :
    g          += 1
    dictg[line] = g   
    revdictg.append(line)
    instance.add(Term('gene', [g])) 
  
  genome_f.close()
  return instance, dictg, revdictg

def read_catalysis(catalysation_string, gene_dict) :
    
  instance    = TermSet()
  catalysis_f = open(catalysation_string, "r")
  i           = 0
  catalyzis   = catalysis_f.readlines()

  for line in catalyzis :
    cat = line.replace('\r\n','\n').split()
  
    if gene_dict.has_key(cat[1]) :
      instance.add(Term('cat', [gene_dict[cat[1]],"\""+cat[0]+"\""]))

  catalysis_f.close()
  return instance


def readcouples(couple_string) :
  couples   = TermSet()
  couples_f = open(couple_string, "r")
  bla       =  couples_f.read().replace('\r\n','\n').splitlines()

  for line in bla :
    link = line.split()
    couples.add(Term('pair', ["\""+link[0]+"\"","\""+link[1]+"\""]))
    
  couples_f.close()
  return couples
 
  
def clean_up() :
  if os.path.isfile("parser.out")          : os.remove("parser.out")
  if os.path.isfile("asp_py_lextab.py")    : os.remove("asp_py_lextab.py")
  if os.path.isfile("asp_py_lextab.pyc")   : os.remove("asp_py_lextab.pyc")
  if os.path.isfile("asp_py_parsetab.py")  : os.remove("asp_py_parsetab.py")
  if os.path.isfile("asp_py_parsetab.pyc") : os.remove("asp_py_parsetab.pyc")

