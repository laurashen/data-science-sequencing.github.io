---
layout: page
mathjax: true
permalink: /lectures/lecture0/
---

## Course Outline


1. **Overview of the problems discussed in the course** (1 lecture)

	a. Problems in computational biology including genome assembly in different flavours, RNA-seq, Chip-seq, ATAC-seq, and other assays

	b. Single cell versions of various assays

	c. A discussion about the statistical and algorithmic challenges that are faced in these problems

2. **High throughput sequencing** (1 lecture)

	a. Sequencing technologies (short read technologies like Illumina, long read technologies like Pacific Biosciences and Oxford Nanopore, linked read technologies like 10x)

	b.	Base calling

3. **De novo Genome Assembly** (3-4 lectures)

	a. Dense read formulation: Necessary and sufficient conditions (informational view)

	b. Algorithms for assembly: de Bruijn graph based algorithms, Overlap graph based algorithms

	c. Errors and biases

4. **Read alignment** (3 lectures)

	a. Dynamic programming

	b. Hash-based seed-and-extend

	c. FM-index and Burrows-Wheeler transform

	d. Suffix arrays

	e. Minhash

	f. Applications such as spliced alignment, and alignments used in practical cases like DAligner, and Minimap.

5. **Variant calling**  (1 lecture)

	a. SNV calling

	b. Structural variant calling

6. **Phasing and Imputation** (2 lectures)

	a. Imputation algorithms

	b. Phasing algorithms

7. **RNA-Seq assembly** (2 lectures)

	a. Formulation

	b. Algorithms

8. **RNA-Seq quantification** (2 lectures)

	a. EM algorithm

9. **Single-cell RNA-Seq analysis** (3 lectures)

	a. Differential expression

	b. Cell Differentiation

	c. Visualisation

	d. Trend Analysis

10. **Genome Compression** (1 lecture)

Guest lecture by [Stephen Turner](http://www.pacb.com/people/stephen-turner-phd/), Co-founder and Chief Technology Officer, [Pacific Biosciences](http://www.pacb.com/) on 13 April 2016.

## Useful Resources

1. Lawrence Hunter, [Molecular Biology for Computer Scientists](http://compbio.ucdenver.edu/hunter/01-Hunter.pdf) - An crisp write-up on the basics of biology which motivate, and provide insights into problems we discuss in class. This is written in a non-biologist friendly manner.

3. Eric Lander, [Fundamentals of Biology, MIT Open Course Ware]( http://ocw.mit.edu/courses/biology/7-01sc-fundamentals-of-biology-fall-2011/) - Lectures covering the basics of biology. Very friendly to non-biologists.

2. [Ben Langmead's lecture notes](http://www.langmead-lab.org/teaching-materials/) - Covers many topics that we cover in class. Some very nice video lectures and example code in ipython notebooks.

3. [Bioinformatics algorithms by Compeau and Pevzner](http://bioinformaticsalgorithms.com/index.htm) - Covers many topics that we cover in this class. Video lectures are also available on the book site.

-----------------

[This lecture as a pdf](/lectures/lecture0.pdf)
