---
layout: index
title: Shogen
tagline: Finding shortest genome segments that regulate metabolic pathways.
---

# Identification of Functional Gene Units
Integrating heterogeneous knowledge is necessary to elucidate the regulations in biological systems. In particular, such an integration is widely used to identify functional units, that are sets of genes that can be triggered by the same external stimuli, as biological stresses, and that are linked to similar responses of the system. Although several models and algorithms shown great success for detecting functional units on well-known biological species, they fail in identifying them when applied to more exotic species, such as extremophiles, that are by nature unrefined. Shortest Genome Segments (SGS) is a new model of functional units with a predictive power that is comparable to existing methods but overcomes this crucial limitation. In contrary to existing methods, SGS are stable in (i) computational time and (ii) ability to predict functional units when one deteriorates the biological knowledge, which simulates cases that occur for exotic species. 


### Installation 

You can install shogen by running:

	$ pip install --user shogen
On Linux the executable script can then be found in ``~/.local/bin``

and on MacOS the script is under ``/Users/YOURUSERNAME/Library/Python/2.7/bin``.

### Usage

Typical usage is:
	
	$ shogen.py [options] genomefile metabolismfile catalysationfile queries
	
	Options:
	  -h, --help   show this help message and exit
	  -k K, --k=K  Number of ranked  shortest genome segments (Default to 5)
	  -l L, --l=L  maximum length of a genome segment (Default to 200)


### Samples

Sample files for finding functional gene units in e. coli are available here:
      [genome.txt](http://bioasp.github.io/downloads/samples/ecoli_K12data/genome.txt) [metabolism.sbml](http://bioasp.github.io/downloads/samples/ecoli_K12data/metabolism.txt) [catalyze.txt](http://bioasp.github.io/downloads/samples/ecoli_K12data/catalyze.txt) [queries.txt](http://bioasp.github.io/downloads/samples/ecoli_K12data/queries.txt)


### Related publications

An ASP application in integrative biology: identification of functional gene units. (2013). 12th International Conference on Logic Programming and Nonmonotonic Reasoning. [DOI](http://dx.doi.org/10.1007/978-3-642-40564-8_21)
