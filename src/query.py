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
import tempfile
from pyasp.asp import *

root = __file__.rsplit('/', 1)[0]

prepro_prg =      root + '/encodings/preprocess.lp'
length_prg =    root + '/encodings/sgs.lp'

convert_prg =   root + '/encodings/convert.lp'
convert_sds_prg =   root + '/encodings/convert_sds.lp'
ksip_prg =      root + '/encodings/ksip.lp'
filter_prg =      root + '/encodings/filter_couples.lp'
filter2_prg =      root + '/encodings/filter2_couples.lp'


class ASPrinter:
  def write(self,count, termset):
    print count,":",termset
  
class EdgePrinter:
  def __init__(self,dictg,revdictr):
    self.dictg = dictg
    self.revdictr = revdictr
  def write(self,count, termset):
    print str(count)+":",
    for t in termset: 
      if t.pred() == "fedge" :
        print "("+self.dictg[int(t.arg(0).arg(0))]+","+self.revdictr[int(t.arg(0).arg(1))]+")-"+str(t.arg(2))+"->("+self.dictg[int(t.arg(1).arg(0))]+","+self.revdictr[int(t.arg(1).arg(1))]+")",
      if t.pred() == "zwoop" :
	print "zwoop("+self.dictg[int(t.arg(0).arg(0))]+","+self.revdictr[int(t.arg(0).arg(1))]+")->("+self.dictg[int(t.arg(1).arg(0))]+","+self.revdictr[int(t.arg(1).arg(1))]+")",
    print " "
    
class GenePrinter:
  def __init__(self,dictg,revdictr):
    self.dictg = dictg
    self.revdictr = revdictr
  def write(self,count, termset):
    print str(count)+":",
    for t in termset: 
      if t.pred() == "ugene" :
	print self.dictg[int(t.arg(0))],
      else:
	print t  
    print " "
    
def filter_couples(couple_facts, instance):
    prg = [filter_prg, instance, couple_facts.to_file()]
    solver = GringoClasp()
    models = solver.run(prg,nmodels=0,collapseTerms=True, collapseAtoms=False)
    os.unlink(prg[2])
    return models[0]
  
def bla(instance, s, e, pmax, k, dictg):
    startfact = String2TermSet('start('+str(s)+')')
    goalfact = String2TermSet('goal('+str(e)+')')
    pmaxfact = String2TermSet('pmax('+str(pmax)+')')
    details = startfact.union(goalfact).union(pmaxfact)
    details_f = details.to_file("details.lp")
    
    prg = [filter2_prg, instance, details_f]
    
    #goptions='--const min=0'
    goptions=''
    coptions='--opt-heu --opt-hier --heu=vsids --quiet=1,1'
    solver = GringoClaspOpt(gringo_options=goptions,clasp_options=coptions)
    models = solver.run(prg, nmodels=0, collapseTerms=True, collapseAtoms=True)
    os.unlink(details_f)
    return models 
     
 
def get_ksip_instance(instance, pmax):

    pmaxfact = String2TermSet('pmax('+str(pmax)+')')
  
    inst=pmaxfact.to_file() 
    prg = [convert_prg , instance, inst ]

    solver = GringoClasp()
    solution = solver.run(prg,1,collapseTerms=False, collapseAtoms=False)
    os.unlink(inst)
    return solution[0] 
  
def get_sgs_instance(instance, pmax):

    pmaxfact = String2TermSet('pmax('+str(pmax)+')')
  
    inst=pmaxfact.to_file() 
    prg = [convert_sds_prg , instance, inst ]

    solver = GringoClasp()
    solution = solver.run(prg,1,collapseTerms=False, collapseAtoms=False)
    os.unlink(inst)
    return solution[0] 
  
    
def preprocess(instance, start, goal, pmax):
    startfact = String2TermSet('start('+str(start)+')')
    goalfact = String2TermSet('goal('+str(goal)+')')
    pmaxfact = String2TermSet('pmax('+str(pmax)+')')
    details = startfact.union(goalfact).union(pmaxfact)
    details_f = details.to_file() 
    prg = [prepro_prg , instance, details_f ]

    solver = GringoClasp()
    solution = solver.run(prg,1)
    
    os.unlink(details_f)
    return solution[0] 
    
    
def get_k_sgs(instance, start, end, pmax, k, dictg, revdictr):
    startfact = String2TermSet('start('+str(start)+')')
    endfact = String2TermSet('end('+str(end)+')')
    pmaxfact = String2TermSet('pmax('+str(pmax)+')')
    
    details = startfact.union(endfact).union(pmaxfact)

    
    details_f=details.to_file() 
    count=0
    min=1
    geneprinter = GenePrinter(dictg, revdictr)
    
    #while len(solutions) < k :
    while count < k : 
      prg = [length_prg , instance, details_f ]
      goptions=' --const pmin='+str(min)
      coptions='--opt-heu --opt-hier --heu=vsids'
      #coptions='--opt-heu --heu=vsids'
      solver = GringoClaspOpt(gringo_options=goptions,clasp_options=coptions)
      #solver = GringoUnClasp(gringo_options=goptions,clasp_options=coptions)
      #print "search1 ...",
      optima = solver.run(prg,collapseTerms=True,collapseAtoms=False)
   
      
      if len(optima) :
	count  += 1
	min= optima[0].score[0]
	
	print "length:",min
	geneprinter.write(count,optima[0])
	#min=optima[0][0]
	
	prg = [length_prg , instance, details_f, exclude_sol([optima[0]]) ]
	goptions='--const pmin='+str(min)
	coptions='--opt-heu --opt-hier --opt-all='+str(min)
	solver = GringoClasp(gringo_options=goptions,clasp_options=coptions)
	#print "search2 ...",
	sols = solver.run(prg,collapseTerms=True,collapseAtoms=False)  
	for i in sols :
	  count+=1
	  geneprinter.write(count,i)
	os.unlink(prg[3])
	min+=1
      else :
        os.unlink(details_f)
	return  
	
    os.unlink(details_f)
    return 

  