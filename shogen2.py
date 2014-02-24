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
from __shogen2__ import query, utils, sbml


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

    print '\nReading genome from ',genome_string,'...',
    genome, genedict, revdictg = utils.read_genome(genome_string)
    print 'done.'
    #print genome
    #print genedict

    print '\nReading metabolic network from ',metabolism_string,'...',
    metabolism = sbml.readSBMLnetwork(metabolism_string)
    print 'done.'
    #print metabolism
    
    print '\nReading catalysation information from ',catalysation_string,'...',
    catalysis = utils.read_catalysis(catalysation_string, genedict)
    print 'done.'

    
    instance=genome.union(metabolism).union(catalysis)
    inst=instance.to_file("instance.lp")
    
    
    print "read queries ...", 
    couples = utils.readcouples(couple_string)
    print "done.", len(couples)
    
    couples.to_file("couples.lp")

    print "filter queries ...",    
    filter_couples = query.filter_couples(couples,inst,length)
    print "done.",len(filter_couples)

    
    new_couples = []
    for a in couples :
      new_couples.append([a.arg(0), a.arg(1)] )
    
    for s,e in new_couples: 
      print "\n"+str(k)+" best gene units catalyzing pathway from reaction",s,"to",e
      ret = query.get_sgs(inst, s, e, length, k, revdictg)
    os.unlink(inst)
    utils.clean_up()
