---
layout: page
mathjax: true
permalink: /lectures/lecture11/
---
## Lecture 11: Alignment - Dynamic Programming and Indexing

Monday 25 April 2016

_Scribed by the course staff_



## Topics

In the last lecture, we introduced the alignment problem where we want to compute the overlap between two strings. Today we will talk about a dynamic programming approach to computing the overlap between two strings and various methods of indexing a long genome to speed up this computation.

1.	<a href='#review'>Review of alignment</a>
2.	<a href='#dp'>Dynamic programming</a>
3.  <a href='#index'>Genome indexing</a>
    - <a href='#noerr'>Error free case</a>
    - <a href='#lowerr'>Low error case</a>
    - <a href='#higherr'>High error case</a>  
    - <a href='#practice'>Indexing in practice</a>  


## <a id='review'></a>Review of alignment

When working with reads, we are generally interested in two types of alignment problems.

1. Reference-based SNP/variant calling, where reads are aligned to a reference. We are often interested in computing the alignment for a billion reads to a long reference genome.
2. De novo assembly, where reads are aligned to each other

To compute the optimal alignment between to genomic sequences (or more generally strings), we can find the minimal edit distance between the two sequences. We note that for both of the above problems, a lot of computation is repeated using the same data. As a recap, the figure below finds the minimal edit distance alignment between two strings X = 'GCGTATGTG' and Y = 'GCTATGCG'. Recall that for the standard edit distance problem, we assign a substitution, deletion, or insertion equal penalties.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture11/Figure1.png" width="40%">
	<div class="figcaption">An edit distance example.</div>
</div>

To go from X to Y, we need at least one deletion and one substitution. Therefore the edit distance is 2.

## <a id='dp'></a>Dynamic programming

Dynamic programming is the strategy of reducing a bigger problem into multiple smaller problem such that solving the smaller problems will result in solving the bigger problem. First, we need to define the "size" of a problem. For edit distance, we let $$(i,j)$$ represent the problem of computing the edit distance between $$X^i$$ and $$Y^j$$. $$X^i$$ is the length-$$i$$ prefix of the string $$X$$, and $$Y^j$$ is the length $$j$$ prefix of string $$Y$$. If we let $$m$$ represent the length of $$X$$ and $$n$$ represent the length of $$Y$$, then the edit distance between $$X$$ and $$Y$$ is the solution to problem $$(m,n)$$. The claim is: if we can solve all the $$(i,j)$$ problems for $$0 \leq i \leq m$$ and $$0 \leq j \leq n$$, then we will efficiently obtain a solution for problem $$(m,n)$$.

Let $$D(i,j)$$ equal the edit distance between $$X^i$$ and $$Y^j$$. Suppose we are looking at $$X^3$$ = 'GCG' and $$Y^2$$ = 'GC'. The edit distance between these two is 1. To express this as even smaller problems, we need a key insight: problem $$(i,j)$$ can be solved directly using the solutions from 3 subproblems:

1. $$(i-1,j)$$, where we advance $$X$$ by one character and put an empty symbol in $$Y$$.
2. $$(i,j-1)$$, where we advance $$Y$$ by one character and put an empty symbol in $$X$$
3. $$(i-1,j-1)$$, where we advance both $$X$$ and $$Y$$ by 1 character.

Since we are interested in the _minimal_ edit distance, $$D(i,j) = \min\{D(i-1,j)+1, D(i-1,j-1) + 1, D(i-1,j-1)+ \delta(X^i,Y^j)\}$$ where $$\delta(X^i,Y^j)$$ represents an indicator function for whether the $$i$$th character of $$X$$ is different from the $$j$$th character of $$Y$$ ($$\delta = 1$$ if they're different, 0 otherwise).

We can think of solving this problem as filling in the entries of a table where the columns correspond to the empty string $$\emptyset$$ plus the characters in $$X$$, and the rows corerspond to the empty string plus the characters in $$Y$$. Please see the figure below for the filled out table corresponding to the first example in this lecture.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture11/Figure2.png" width="80%">
	<div class="figcaption">Computation of the minimal edit distance between two strings using dynamic programming.</div>
</div>

Note that the $$(m,n)$$th entry (bottom-right corner) indeed has the minimal edit distance between the two strings. After filling out the dynamic programming table, we can trace a path back from the bottom-right entry to the top-left entry along the smallest values to obtain our alignment shown in the first figure in this lecture.

Each computation requires looking up at most 3 entries of the table. Therefore the complexity of this algorithm is $$O(MN)$$. For read-overlap graph assembly, we have $$N$$ reads each of length $$L$$. Using this edit distance approach, we will need $$O(N^2L^2)$$ operations to perform assembly. With $$N$$ possibly the order of $$10^8$$ or $$10^9$$ for a sequencing experiment, this operation is quite expensive.

For variant calling, we want to align $$N$$ reads to a reference genome of length $$G$$. Computing the edit distance between a read and the genome is $$O(LG)$$. The runtime is $$O(NLG) = O(CG^2)$$ where $$C$$ is the coverage depth. $$G$$ can be large ($$3*10^9 for the human genome)  and therefore this operation is also quite expensive.

## <a id='index'></a>Genome indexing

The genome is very long, so alignment algorithms that require a search along the entire genome (for every read) seem suboptimal. We can use an index to store the context of the genome to make the search more efficient, reducing the amortized cost.

### <a id='noerr'></a> Error free case

We first consider the idealistic case. Suppose each read is error-free;  the reads come directly from the genome. Every read has a location in this genome, and we want to find this location fast. We can build a sorted list of $$L$$-mers (each read is length $$L$$) such that we can easily look up the genome indices of specific $$L$$-mers. We build the list by extracting all length $$L$$ sequences from the genome and ordering the sequences in lexicographical order. For each new read coming in, we can quickly search for the corresponding $$L$$-mer key in the list, obtaining its location in the genome.

Since the list is at most length $$G$$, doing a binary search on the list is $$O(\log G)$$. Note that the complexity of building the index is $$O(G)$$, but we only have to build this index once. Looking up $$N$$ reads is $$O(N \log G)$$. Overall, the total cost is $$O(G + N \log G)$$, much better than $$O(G^2)$$.

Rather than using a sorted list, we could also use a hash table. This results in $$O(1)$$ lookup for new reads, but keeping the entire hash table in memory is more expensive.

### <a id='lowerr'></a> Low error case

We now look at the regime where the errors are relatively low (e.g. less than 1%, in the case of Illumina reads). Recall from last lecture that when the error is low, we typically get 0-2 errors per length-100 read. We will see many legnth-20 subsequences which are error free. So instead of making a sorted list with $$L$$-mers, we can create a sorted list of $$20$$-mers. With this strategy, $$20$$-mers with errors will map to a random location or no location at all. This is not an issue, however, because if 20 is a reasonably large number, then most random reads will map to no location in the genome.

### <a id='higherr'></a> High error case

If the error rate is high, we can use the same approach as the low-error case by reducing the size of the $$k$$ corresponding to the $$k$$-mer used for indexing. If the error is high enough (15% in the case of PacBio reads), $$k$$ will need to be small to ensure a high probability of errors mapping to no location on the genome. With a smaller $$k$$, we also expect more collisions in our table, since the set of unique $$k$$-mers is smaller. More collisions results in a more expensive alignment procedure.

Instead, we can perform [_minhashing_](https://en.wikipedia.org/wiki/MinHash) in this regime to efficiently find length-$$k$$ regions of the genome similar to a given $$k$$-mer.

### <a id='higherr'></a> Indexing in practice

In the low-error case, tools used in practice use shorter subsequences as potentially error-free fingerprints for locking down potential alignment locations. Some methods such as [pseudoalignment](http://tinyheero.github.io/2015/09/02/pseudoalignments-kallisto.html) can also take the intersection of a few location sets corresponding to $$k$$-mers within a read.

The *seed-and-extend* concept is based on this fingerprinting approach. We starting by finding seed locations using $$20$$-mers, for example, and then we extend the bases on both sides of this seed.

Read overlap graph approaches typically require $$O(N^2)$$ operations where $$N = 10^8$$ or $$10^9$$. We can use the fingerprinting idea to alleviate some of the cost. We can build a table where the keys are $$k$$-mers and values are the reads containing a particular $$k$$-mer. We build this table by scannign through all the reads and applying a hash function. Now, for each read, we want to find a bunch of other reads that may align to the query read. Using this hash strategy gives us far less "candidate" reads per read, saving significant computation. The actual savings will depend on the number of repeats, but the cost reduces from $$O(N^2)$$ to $$O(cN)$$ for some constant $$c \ll N$$.
