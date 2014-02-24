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
  genome = genome_f.read().replace('\r\n','\n').split()
  dictg = {} # Dictionnary for the genes
  revdictg = [0]
  g = 0 # Counter to define the matchings between real names and ASP names
  for line in genome :
    g+=1
    dictg[line] = g   
    revdictg.append(line)
    instance.add(Term('gene', [g])) 
  
  genome_f.close()
  return instance, dictg

def read_catalysis(catalysation_string, gene_dict) :
    
  instance = TermSet()
  catalysis_f = open(catalysation_string, "r")

  i=0
  catalyzis = catalysis_f.readlines()
  for line in catalyzis :
    cat = line.replace('\r\n','\n').split()
  
    if gene_dict.has_key(cat[1]) :
      instance.add(Term('cat', [gene_dict[cat[1]],"\""+cat[0]+"\""]))

  catalysis_f.close()
  return instance

  

def createInstance(genome_string,metabolism_string,catalysation_string) :

  instance = TermSet()

  igenome = open(genome_string, "r")
  genome = igenome.read().replace('\r\n','\n').split()
  dictg = {} # Dictionnary for the genes
  revdictg = [0]
  g = 0 # Counter to define the matchings between real names and ASP names
  for line in genome :
    g+=1
    dictg[line] = g   
    revdictg.append(line)
    instance.add(Term('gene', [g]))
    
  
  imetabolism = open(metabolism_string, "r")
  metabolism = imetabolism.read().replace('\r\n','\n').splitlines()
  dictr = {}# Dictionnary for the reactions
  revdictr = [0]
  r = 0 # Counter to define the matchings between real names and ASP names
  
  for line in metabolism :
    if line !="":
      link = line.split()
      if not dictr.has_key(link[0]) :
	r+=1
	dictr[link[0]] = r
	revdictr.append(link[0])
      if not dictr.has_key(link[1]) :
	r+=1
	dictr[link[1]] = r
	revdictr.append(link[1])
      instance.add(Term('redge', [dictr[link[0]],dictr[link[1]]]))

  #print("\t\t</nodes>\n")

  
  icatalyzis = open(catalysation_string, "r")

  catalyzistab=[]
  i=0
  catalyzis = icatalyzis.readlines()
  for line in catalyzis :
    cat = line.replace('\r\n','\n').split()
  
    if dictr.has_key(cat[0]) and dictg.has_key(cat[1]) :
      instance.add(Term('cat', [dictg[cat[1]],dictr[cat[0]]]))
      while i < dictr[cat[0]]+1 :
	catalyzistab.append([])
	i+=1
      catalyzistab[dictr[cat[0]]].append(dictg[cat[1]])  
    #else :
      #print "irrelevant gene or reaction",cat[1],cat[0]

  #print len(catalyzistab)      
  #exit(0)
      
  couplestab = []
  for i in range(len(catalyzistab)) :
    for j in range(len(catalyzistab))[(i+1):] :
      condition = True
      for g1 in catalyzistab[i] :
	for g2 in catalyzistab[j] :
	  if condition :
	    glen = len(dictg)
	    if min(abs(g1-g2),glen-abs(g1-g2)) <= 10 :
	      couplestab.append([i,j])
	      condition = False    
	      
  return instance, revdictg, revdictr, dictr, couplestab


def readcouples(couple_string, dictr, revdictr) :

  icouples = open(couple_string, "r")
  bla =  icouples.read().replace('\r\n','\n').splitlines()
  r = len(revdictr) # Counter to define the matchings between real names and ASP names
  couples = TermSet()
  for line in bla :
    link = line.split()
    if not dictr.has_key(link[0]) :# Dictionnary for the reactions
      r+=1
      dictr[link[0]] = r 
      revdictr.append(link[0])
    if not dictr.has_key(link[1]) :
      r+=1
      dictr[link[1]] = r
      revdictr.append(link[1])
    couples.add(Term('pair', [str(dictr[link[0]]),str(dictr[link[1]])]))
  return couples, revdictr

def readcouples_new(couple_string) :
  couples = TermSet()
  
  couples_f = open(couple_string, "r")
  bla =  couples_f.read().replace('\r\n','\n').splitlines()

  for line in bla :
    link = line.split()
    couples.add(Term('pair', ["\""+link[0]+"\"","\""+link[1]+"\""]))
    
  couples_f.close()
  return couples


def print_reactions(answer,dictr,dictg) :
  for a in answer:
    if a.pred() == "fedge" :
      print "\n   ",dictr[int(a.arg(0).arg(1))]+"("+dictg[int(a.arg(0).arg(0))]+")",
      print"->",
      print dictr[int(a.arg(1).arg(1))]+"("+dictg[int(a.arg(1).arg(0))]+")",
      print ": ",a.arg(2),
  print

  
def print_genes(answer, dictg) :
  for a in answer:
    if a.pred() == "cgene" :
      print dictg[int(a.arg(0))],
    if a.pred() == "ugene" :
      print dictg[int(a.arg(0))],
  print
  
   
  
def clean_up() :
  if os.path.isfile("parser.out"): os.remove("parser.out")
  if os.path.isfile("asp_py_lextab.py"): os.remove("asp_py_lextab.py")
  if os.path.isfile("asp_py_lextab.pyc"): os.remove("asp_py_lextab.pyc")
  if os.path.isfile("asp_py_parsetab.py"): os.remove("asp_py_parsetab.py")
  if os.path.isfile("asp_py_parsetab.pyc"): os.remove("asp_py_parsetab.pyc") 