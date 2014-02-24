#!python
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
from optparse import OptionParser
from __shogen__ import query, utils, sbml


if __name__ == '__main__':
    usage = "usage: %prog [options] genomefile metabolismfile catalysationfile queries" 
    parser = OptionParser(usage)

    parser.add_option("-k", "--k", dest="k", type="int", default=5,
                      help="Number of ranked  shortest genome segments (Default to 5)", metavar="K")
    
    parser.add_option("-l", "--l", dest="l", type="int", default=200,
                      help="maximum length of a genome segment (Default to 200)", metavar="L")
    
    #parser.add_option("-s", action="store_true", dest="SEARCHTYPE",
                      #help="compute  shortest dna segments")                  
    #parser.add_option("-c", action="store_true", dest="compress_only",
                      #help="If set only a compressed graph is computed and stored compressed_graph.txt")
                      
    (options, args) = parser.parse_args()

    if len(args) != 4 :
        parser.error("incorrect number of arguments")
         
    genome_string = args[0]
    metabolism_string = args[1]
    catalysation_string = args[2]
    couple_string =  args[3]
   
    k = options.k
    length = options.l

    print "read instance files ...",
    instance, dictg, revdictr, dictr, oldcouples = utils.createInstance(genome_string,metabolism_string,catalysation_string) 
    print "done."

    inst=instance.to_file()
    instance.to_file("inst.lp")
    print "create instance ...",
    ksip_instance = query.get_ksip_instance(inst,length)
    print "done.",len(ksip_instance)
 
    kinst=ksip_instance.to_file()
    
    print "read queries ...", 
    couples, revdictr = utils.readcouples(couple_string, dictr, revdictr)
    print "done.", len(couples)
        
    print "filter queries ...",    
    filter_couples = query.filter_couples(couples,kinst)
    print "done.",len(filter_couples)
       
    new_couples = []
    for a in filter_couples :
      new_couples.append([int(a.arg(0)), int(a.arg(1))] )
      
    print "create sgs instance ...",
    sgs_instance = query.get_sgs_instance(inst,length)
    print "done.",len(sgs_instance)
    sgs_instance_f = sgs_instance.to_file()
      
      
    for s,g in new_couples: 
      print "\n"+str(k)+" best gene units catalyzing pathway from reaction",revdictr[s],"to",revdictr[g]
      query.get_k_sgs(sgs_instance_f, s, g, length, k, dictg, revdictr)
    os.unlink(sgs_instance_f)
	    
    os.unlink(inst)
    utils.clean_up()
