---
layout: page
mathjax: true
permalink: /lectures/lecture12/
---

## Lecture 12 : Haplotype Assembly

Monday 25 April 2016

_Scribed by Chayakorn Pongsiri  and revised by the course staff_

1. 	<a href='#SNP'>Single Nucleotide Polymorphisms</a>  
    - <a href='#calling'>SNP Calling</a>  
2. 	<a href='#phasing'>Haplotype Assembly</a>  
    - <a href='#comp'>The computational problem</a>  
    - <a href='#conv'>Convolutional codes and the Viterbi algorithm</a>  

###  <a id='SNP'></a>Single Nucleotide Polymorphisms (SNP)
Single Nucleotide Polymorphisms (SNPs) are mutations that occur over evolution.
A simplistic view of these would be to think of them as around 100,000 positions
where variation occurs in the human genome.


#### <a id='calling'></a> SNP Calling



SNP calling is a technique that is used to identify SNPs in the sample genome.
The main computational approach taken here is given reads from a genome,
we first map the reads to various positions on the genome using alignment
methods discussed in the last lecture. Some reads map into locations with
no variation with respect to the reference.

At a high level, the pipeline can be seen as follows:
<div class="fig figcenter fighighlight">
  <img src="/assets/lecture12/Figure1.png" width="99%">
	<div class="figcaption">The haplotype phasing pipeline.</div>
</div>


The main statistical problem to be distinguish errors in reads from difference
in the underlying genome. Usually we have very high coverage in this case.
That is every position in the genome is covered by many reads. Thus the test
to see if a reads disagreeing with the reference are due to errors or due
to the individual's genome being different is a simple statistical test.


##### SNP calling in diploid organisms

If an organism had only one copy of every chromosome, the SNP calling problem
would reduce to just taking the majority of the base of reads aligned to
every position. However, humans have two copies of every chromosome; one maternal
and the other paternal.

During sequencing, we fragment the DNA material, so the sequencer cannot
distinguish between the paternal and maternal DNA. When we map these reads to the
locations, we do not have as clean a picture. We represent variation in each position as a 1
and no variation as a 0.  In each position,
we have 4 possibilities:

1. No variation: 00  
2. Both copies are different from the reference: 11  
3. One of the copies is the reference and and the other is the variation. This
gives us 10 or 01.  

We note that we assume here that there is only one variant at each position.
This is a reasonable approximation to reality here.


Positions with 00 and 11 are called **homozygous** positions. Positions
with 10 or 01 are called **heterozygous** positions. We note that the
reference genome is neither the paternal nor the maternal genome, but
the genome of an un-related human (or more precisely the mixture of genomes
of a few individuals). We note that as any two human haplotypes are 99.9% similar,
the mapping problem can be solved quite easily.



After mapping the reads, we can tell between certain possibilities.
We can measure (estimate) the number of variations: 0, 1, or 2.
From the SNP calling, I can estimate the number of variations at each position.
One case is harder though: we cannot tell between the two heterozygous cases
(01 vs 10). Distinguishing these two is important because many diseases are
**multiallelic**. That is, multiple positions determine a disease. Also the
diseases depend upon the proteins produced in an individual. This depends upon
the SNPs present on the same chromosome rather than those on different
chromosomes.


### <a id='phasing'></a> Haplotype Assembly

**Haplotype phasing** is the problem of inferring information about the variations
in each of the two chromosomes (haplotypes).
To solve this problem, there are many  methods.

First, we focus on a class of methods focused on getting better
data (rather than better statistical methods).
Let’s say we have two variants, SNP1 and SNP2.
The distance between the two are on the order of
$$\approx$$ 1000 bp (i.e. they’re pretty far apart).
To do haplotype phasing,
one needs some information that allows us to connect the two SNPs so that
one can infer which variants lie on the same chromosome.
The Illumina reads are typically 100-200bp long. Thus finding a
single read that spans the two positions.


However, there do exist multiple technologies that provide this long-range
information. We discuss two of these:  


- **Mate-pair reads** - During sequencing, with a special library
preparation step, one can get pairs of reads that we know come from the
same chromosome
(but they are far apart). They can be ~1000 bp apart, and we know the separation.
During sequencing, we have DNA fragments (a few thousand bp long).
The distance between the pair is not known, but its statistics are known.

- **Read clouds** - A fairly new library preparation technique pioneered
by [10x Genomics](http://www.10xgenomics.com/). This uses barcodes to label
reads, and is designed so that reads with the same bar-code come from the
same chromosome. The reads with the same bar-code are called a _read cloud_.
Each read cloud gets  a few hundred reads that are from a segment of length
50k-100k in the genome.

While in both these processes the separation of between the linked reads
is a random variable, one can compute it by aligning reads to a reference.

In practice, the main software used for haplotype assembly
are [HapCompass](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3375639/)
and [HapCut](http://bioinformatics.oxfordjournals.org/content/24/16/i153.short).
HapCut poses this as a max-cut problem and uses heuristics to solve that.
HapCompass on the other hand constructs a graph where each node is a SNP with
a observed and each edge indicates that two SNP values are seen in the same
read. It then poses this problem to finding max-weight spanning trees
on the graph. For read clouds, a software called [loupe](http://loupe.10xgenomics.com/loupe/)
was developed by 10x-Genomics. They provide a nice
[visualisation](http://loupe.10xgenomics.com/loupe/view/TkExMjg3OF9XR1MubG91cGU=/summary)
of the results [NA12878](https://catalog.coriell.org/0/Sections/Search/Sample_Detail.aspx?Ref=GM12878),
a human genome used as a reference in a lot of computational experiments.


#### <a id='comp'></a> The Computational Problem

Here we consider a simplified problem of haplotype assembly. We assume
we have the locations of the heterozygous positions in the genome, and only
consider reads linking positions these positions.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture12/chr.png" width="99%">
	<div class="figcaption">The haplotype phasing example.</div>
</div>


The above figure shows two chromosomes with heterozygote SNPs that we want to
tell which variations occur on the same chromosome.  
Let $$L_i$$ = parity between $$i^{\text{th}}$$ and $$(i+1)^{\text{th}}$$ SNP.
For example, from the picture, $$L_1 = 1, L_2 = 1, \text{ and }L_3 = 0.$$

The parities obtained between the two SNPs covered by the reads are given by
$$Y_A = 1, Y_B = 1, \text{ and } Y_C = 1.$$

However the observations are noisy. One can model this as each SNP observation
being flipped with some probability $$\epsilon $$ independent of all other
observations.
This leads to the following  model:

$$Y_A = L_2 \oplus Z_A$$  
$$Y_B = L_1 \oplus Z_B$$  
$$Y_C = L_2 \oplus L_3 \oplus Z_C,$$  


where $$Z_A, Z_B, Z_C \sim \text{Bernoulli}(\epsilon(1-\epsilon)) \ \ \ $$
model the noise in the observed parities.

Our goal is to find out what the sequence of $$L_i$$ is to identify
which variations occur on the same chromosome
(although we still cannot tell which are on the maternal chromosome, and
which are on the paternal chromosome).



#### <a id='conv'></a> Convolutional Code and Viterbi Algorithm

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture12/Figure2.png" width="40%">
	<div class="figcaption">Convolutional codes used with haplotype assembly.</div>
</div>
The transfromation from $$L's$$ to $$Y's$$ can be viewed as a
[convolutional code](https://en.wikipedia.org/wiki/Convolutional_code)
and the maximum-likelihood decoder is called the
[**Viterbi algorithm**](https://en.wikipedia.org/wiki/Viterbi_algorithm).

##### Complexity of the Viterbi Algorithm
The runtime of the Viterbi algorithm is linear in the number of SNPs
in the genome (around 100,000 in human genome) and proportional to $$2^{\text{mate-pair separation range}}$$.
The fact that the runtime is exponentially increasing with the mate-pair
separation range can introduce a problem when the range is long. However,
convolutional codes with constraint lengths (mate-pair separation
range) in the tens are routinely decoded in communication (using
various schemes that trim the state-space.)

---

- Figure 2 here is due to Chayakorn Pongsiri.
