---
layout: page
mathjax: true
permalink: /assignments/assignment2/
---
## Assignment 2

posted Monday 2 May 2016  
due Monday 9 May 2016 at midnight

**Submission policy**: Report all plots and your code in [this iPython notebook](/assets/assignment2/ee372_assignment2.ipynb). Print your notebook as a PDF and attach it to the rest of your assignment. Turn in your assignment on the 2nd floor of Packard in the EE372 bin next to the kitchen area.

### Question I: Lander-Waterman and repeat statistics

In Question III of the last problem set, you aligned reads from an _E. coli_ sequencing experiment to the _E. coli_ genome using Bowtie, obtaining 617036 aligned reads (out of 644022 total reads). Download the set of aligned reads [here](/assets/assignment2/E.coli.alignments.EE372.bam) (the alignments are saved as a *.bam file). You can view the first 15 lines of the file using the command ```samtools view E.coli.alignments.EE372.bam | head -15```. Samtools is installed on Stanford's Corn server.

1. Refer to the documentation for the *.sam file format [here](https://samtools.github.io/hts-specs/SAMv1.pdf). Convert the *.bam file to a *.sam file using the ```samtools view``` command. What position does the first read align to?
2. The length of the _E. coli_ genome is 4639675. Write a function to compute the proportion of the genome by covered by the reads in a given *.sam file. What proportion of the genome is covered by the reads in E.coli.alignments.EE372.bam?
3. Subsample the *.sam file using the ```samtools view -s``` command. You should generate a new *.sam file for each subsampling. Using the function you wrote above, plot the proportion of the genome covered as a function of $$p$$, the proportion of reads kept. Interpret what you see (1-2 sentences).
4. Compute the triple repeat and interleaved statistics of the _E. coli_ genome (available [here](http://portal.nersc.gov/dna/microbial/assembly/uploads/dtse/Mock-Community/E.coli_K12_ATCC_700926.fasta)). Report the number of triple and interleaved repeats of length more than 200. Consider only the forward strand of the reference. _Hint_: Use the software MUMmer, which is also installed on Corn. The ```repeat-match``` command might be helpful.

You may also use [pysam](http://pysam.readthedocs.io/en/latest/api.html) for this problem.

### Question II: de Bruijn graph assembly

1. Give the 5-mer spectrum of TAAAAACCCCAAAAAG. How many different assemblies are consistent with the 5-mer spectrum?

2. The support of a $$k$$-mer spectrum is the $$k$$-mer spectrum with the value of all non-zero $$k$$-mers set to 1. Give the assembly of TAAAAACCCCAAAAAG from the support of its 5-mer spectrum. How many different assemblies are consistent with the support of this 5-mer spectrum?

3. Study the implementation of the de Bruijn graph assembler by Ben Langmead [here](http://nbviewer.jupyter.org/github/BenLangmead/comp-genomics-class/blob/master/notebooks/CG_deBruijn.ipynb). You should copy and paste the code from the top cell into your notebook as you will use a tweak of this  class to perform assembly. (You will need to make sure that the assembly is done using the k-mers of non-zero support. That is, even if a k-mer is seen twice one would add only an edge between the k-1 mers.) Note that you will need to pass a list of reads (strings) as the ```strIter``` argument when initializing an instance of the class (see ```__iter___```). You can use the ```eulerianWalkOrCycle``` method to obtain a list of $$k-1$$-mers corresponding to an Eulerian walk through the graph. Write a function that obtains the assembly from this list of $$k-1$$-mers (i.e. if the list is ['ABCD','BCDE'] with $$k=5$$, then your function should return 'ABCDE').

4. Write a function to generate random reads. The input should be the number of reads generated $$N$$ and the length $$L$$ of each read generated. The output should be $$N$$ random length-$$L$$ sequences of nucleotides. Generate a random length-100 genome.

5. Write a function to sample reads from a genome. The input should be the genome, the number of reads generated $$N$$, and the length $$L$$ of each read generated. Assuming that $$L = 10$$, how many reads do you need to achieve a coverage depth of 30? Generate this number of reads and give the assembly using your code from part 3.

6. Write a modified version of the previous function for sampling reads from a genome with error. Generate random length-10 reads with 5% error rate and a coverage of 30. Give the assembly using your code for part 3. What do you observe? You may want to rerun your code for 4-6 to make sure your observations are consistent.

### Question III: Alignment of random strings

1. Write a function that computes the edit distance between two strings using dynamic programming. You can use standard libraries such as  [editdistance](https://pypi.python.org/pypi/editdistance) to check the correctness of your function. The input should be two strings each of at least length 2. The output should be a float representing the edit distance between the two input strings.

2. How can you use the above function to perform alignment between two reads? If you have $$N$$ total reads each of length $$L$$, what is the runtime of this approach in terms of $$N$$ and $$L$$?

3. For $$L=10$$, generate two reads of length $$L$$ and compute their edit distance. Average your result over 100 runs to obtain an estimate of the average edit distance $$\hat{d}_L$$ of two randomly generated reads of length $$L$$. Repeat for $$L = 1, 100, 1000, 10000$$. Plot $$\hat{d}_L$$ as a function of $$L$$ with error bars. Do you observed any trends? What can you say about how well random strings align? (2-3 sentences).
