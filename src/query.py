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
import os
import tempfile
from pyasp.asp import *

root       = __file__.rsplit('/', 1)[0]
filter_prg = root + '/encodings/filter_couples.lp'
sgs_prg    = root + '/encodings/sgs.lp'


class GenePrinter:
  def __init__(self,dictg):
    self.dictg = dictg
  def write(self,count, termset):
    print(str(count),": ",sep='',end='')
    for t in termset:
      if t.pred() == "ugene" :
        print(self.dictg[int(t.arg(0))],end=' ')
      else:
        print(t)
    print(" ")


def filter_couples(couple_facts, instance, pmax):
    pmaxfact = String2TermSet('pmax('+str(pmax)+')')
    pmaxf    = pmaxfact.to_file()
    couplesf = couple_facts.to_file()    
    prg      = [filter_prg, instance, pmaxf, couplesf]
    solver   = GringoClasp()
    models   = solver.run(prg,collapseTerms=True, collapseAtoms=False)
    os.unlink(pmaxf)
    os.unlink(couplesf)
    return models[0]



def get_sgs(instance, s, e, pmax, k, dictg):
# grounding is the problem (takes long)
    startfact   = String2TermSet('start('+str(s)+')')
    goalfact    = String2TermSet('end('+str(e)+')')
    pmaxfact    = String2TermSet('pmax('+str(pmax)+')')
    details     = TermSet(startfact.union(goalfact).union(pmaxfact))
    details_f   = details.to_file()
    count       = 0
    min         = 1
    geneprinter = GenePrinter(dictg)

    while count < k :
      prg      = [sgs_prg, instance, details_f ]
      goptions = ' --const pmin='+str(min)
      coptions = '--opt-heu --opt-strategy=1 --heu=vsids'
      solver   = GringoClasp(gringo_options=goptions,clasp_options=coptions)
      optima   = solver.run(prg, collapseTerms=True, collapseAtoms=False)
      if len(optima) :
        count += 1
        min   = optima[0].score[0]
        print("length:",min)
        geneprinter.write(count,optima[0])

        prg      = [sgs_prg , instance, details_f, exclude_sol([optima[0]]) ]
        goptions = '--const pmin='+str(min)
        coptions = '--opt-heu --opt-strategy=1 --opt-mode=optN --opt-bound='+str(min)
        solver   = GringoClasp(gringo_options=goptions,clasp_options=coptions)
        solutions = solver.run(prg, collapseTerms=True, collapseAtoms=False)
        for i in solutions :
          count += 1
          geneprinter.write(count,i)

        os.unlink(prg[3])
        min+=1
      else :
        os.unlink(details_f)
        return

    os.unlink(details_f)

  
