
Installation
------------


You can install shogen by running::

	$ pip install --user shogen

On Linux the executable script can then be found in ``~/.local/bin``

and on MacOS the script is under ``/Users/YOURUSERNAME/Library/Python/2.7/bin``.

Usage
-----

Typical usage is::
	
	$ shogen.py [options] genomefile metabolismfile.sbml catalysationfile queries
	
	Options:
	  -h, --help   show this help message and exit
	  -k K, --k=K  Number of ranked  shortest genome segments (Default to 5)
	  -l L, --l=L  maximum length of a genome segment (Default to 200)
	  
	  
	  
Samples
-------

Sample files for finding functional gene units in e. coli are available here:
      genome.txt_ metabolism.sbml_ catalyze.txt_ queries.txt_

.. _genome.txt: http://bioasp.github.io/downloads/samples/ecoli_K12data/genome.txt
.. _metabolism.sbml: http://bioasp.github.io/downloads/samples/ecoli_K12data/metabolism.sbml
.. _catalyze.txt: http://bioasp.github.io/downloads/samples/ecoli_K12data/catalyze.txt
.. _queries.txt: http://bioasp.github.io/downloads/samples/ecoli_K12data/queries.txt
