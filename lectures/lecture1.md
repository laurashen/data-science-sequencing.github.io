---
layout: page
mathjax: true
permalink: /lectures/lecture1/
---
## Lecture 1: Introduction

Monday 28 March 2016

_Scribed by Anja Brandon and revised by the course staff_

-----------------

### Topics

1. <a href='#what'> What is high-throughput sequencing? </a>  
  - <a href='#seq'> Sequencing methods
2. <a href='#ds-or-hts'> Data science of high-throughput sequencing </a>  
  - <a href='#tools'> Tools used </a>
3. <a href='#examples'> Two example problems </a>  
  - <a href='#assembly'> _de novo_ DNA assembly </a>  
  - <a href='#scrnaseq'> Single-cell RNA-seq analysis </a>

----------------

### What is high-throughput sequencing? <a id='what'></a>

The main object of interest in this course
is the [genome](https://en.wikipedia.org/wiki/Genome) of a
organism, which is made of
[_deoxyribonucleic acid_](https://ghr.nlm.nih.gov/handbook/basics/dna) (DNA).
All computational methods we discuss will
be related to deducing the sequence of the genome
or some property closely related to the genome. High-throughput sequencing refers to modern technologies used to identify the sequence of a segment (or "strand") of DNA. Only 15 years ago, sequencing technologies were around 6 orders
of magnitude slower than they are today in terms of both cost and throughput.

The first major sequencing project was the
[Human Genome Project](https://www.genome.gov/10001772).
A big consortium began collaborative efforts in 1990 to
sequence the entire human genome.
They released their first draft in 2003, which cost $2.7 billion and 13 years of
work by labs around the world. In 2015, the cost of sequencing a genome was approximately $1000. This is testament to how far the technology has
evolved. As shown below,
the cost of DNA sequencing has been falling
at a rate faster than Moore's law over the last
15 years.


<!-- ![Cost of DNA sequencing over the years](/assets/lecture1/HTS_cost.png){: width="99%"} -->


<div class="fig figcenter fighighlight">
  <img src="/assets/lecture1/HTS_cost.png" width="80%">
  <div class="figcaption">Cost of DNA sequencing over the years.</div>
</div>

DNA is a very important biomolecule,
but it’s only one of many important biomolecules.
Other important biological molecules include
[ribonucleic acids](https://en.wikipedia.org/wiki/RNA) (RNA)
and [proteins](https://en.wikipedia.org/wiki/Protein).
Some innovative bio-chemistry has allowed the
use of DNA sequencing technology for measuring properties of
various other biological molecules (and there are even proposals on how to use DNA sequencing for
[detecting dark matter](http://arxiv.org/abs/1206.6809)).

High-throughput sequencing can be thought of as a tool (e.g. a microscope)
that can be used to measure a variety of quantities. The basic paradigm (shown below) is to reduce the estimation problem of
interest to a DNA sequencing problem, which can be handled
using high-throughput sequencing. This is similar in principle
to the reduction used to solve many mathematical problems
or to show NP-hardness of various problems.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture1/star_seq_paradigm.png" width="99%">
  <div class="figcaption">The *-seq paradigm: Convert the problem of interest to a DNA sequencing problem.</div>
</div>

For the biochemist, the challenge is in determining how to convert the problem of
interest to a problem which can be tackled
using high-throughput sequencing. This is similar to how biologists design experiments such that the results can
be observed under a microscope. For the computational biologist, the challenge is in performing the relevant type of
inference on the
data observed using high-throughput sequencing.
Some important sequencing assays are:

- RNA-Seq: RNA is an important intermediate product for producing protein from DNA.
While every cell in an organism has the same DNA, an individual cell's RNA content may be very different. RNA in cells can also vary depending on temporal and environmental factors. RNA-Seq is an assay that "measures" RNA, and
this was the first assay in which high-throughput
sequencing was used to measure a molecule other than
DNA. The assay was developed in 2008 by
[Mortazavi _et al_](http://www.nature.com/nmeth/journal/v5/n7/abs/nmeth.1226.html).

- ChIP-Seq: Different cells express different RNA because of _epigenetic_ factors or molecules that influence how the genome is packed in the cell. DNA in cells
are bound to proteins called histones, and for different cells, different parts of the genome are bound to histones. DNA wrapped around histones are harder to access and are not converted to RNA. ChIP-Seq is
an assay which was developed measure the
regions of the genome that are bound to histones. This assay was developed in 2007 by
[Johnson _et al_.](http://science.sciencemag.org/content/316/5830/1497).
Another recent assay called
[ATAC-seq](http://www.nature.com/nmeth/journal/v10/n12/full/nmeth.2688.html)
measures regions of the genome that are _not_ bound to histones.

- Hi-C-Seq: This assay measures the 3D
structure of molecules and was developed by
[Belton _et al_.](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3874846/)
in 2012.

One of the most interesting and important problems in genomics is
predicting _phenotype_ (physical characteristics
such as a person's height or a person's favorite color)
from _genotype_ (DNA sequence).
In medicine, understanding the relationship between phenotype and genotype can allow researchers to predict a patient's susceptibility
to certain diseases by sequencing the patient's genome. A big success-story here is the
discovery that presence of a particular mutation in the
gene [BRCA1](http://www.cancer.gov/about-cancer/causes-prevention/genetics/brca-fact-sheet)
increases the risk of breast cancer to around
45%.

Another important application of high-throughput sequencing is
[cancer](http://cancergenome.nih.gov/cancergenomics/whatisgenomics/whatis).
Cancer is a "disease of the genome." It is caused
by rearrangements of the genome, which are sometimes very large.
By sequencing cancer cells, one gets information about
the nature of the cancer-causing mutation and can
tailor treatment.

[Non-invasive pre-natal testing](http://www.mayoclinic.org/tests-procedures/noninvasive-prenatal-testing/home/ovc-20187358)
for genetic birth defects
is another powerful application of
high-throughput sequencing. Traces of fetal DNA can be found
in the blood of the mother. The main idea here
is to sequence the maternal blood and
infer fetal genetic birth defects from the sequence.
High-throughput sequencing has been used successfully for detecting
[Down syndrome](http://www.mayoclinic.org/diseases-conditions/down-syndrome/basics/tests-diagnosis/con-20020948).

#### Sequencing methods <a id='seq'></a>

Science is progressed by the
invention of measuring methods.
High-throughput Sequencing is one such measurement
tool; however,
high-throughput Sequencing is different
from many measurement tools because it
has a significant computational component. High-throughput
sequencing (also called
[_shotgun sequencing_](https://en.wikipedia.org/wiki/Shotgun_sequencing))
takes the DNA
sequence as input, breaks it into smaller fragments or _reads_, and
returns a noisy version of these smaller fragments. We note that the length of reads range from 50-50000
while the human genome is of length 3 billion. Fortunately,
these small noisy subsequences also contain information
about the genome. While a single read contains very little
information about the entire sequencing,  a
typical experiment generates a few million reads
(and hence is called "high-throughput"). Extraction of the information contained within reads requires clever
computational processing, and this is the flavor of problems
we will discuss in this class. We also note that the sequencing process can be very noisy. Each of the reads can be potentially different from the original subsequence of the DNA the read came
from.

The sequencing revolution arose due to the rapid evolution of sequencing
technologies. Sequencing began with
[Fred Sanger](https://en.wikipedia.org/wiki/Frederick_Sanger),
who first came up with
[Sanger sequencing](https://en.wikipedia.org/wiki/Sanger_sequencing) technology.
This was a relatively low-throughput technology and was the dominant technology
until the late 1990s.
[Second generation sequencing](http://genomesunzipped.org/2010/09/basics-second-generation-sequencing.php)
was pioneered by [Illumina](http://www.illumina.com/technology/next-generation-sequencing.html)
and is currently the dominant technology. Recent developments in Illumina sequencing have
allowed scientists perform
[single-cell sequencing](https://en.wikipedia.org/wiki/Single_cell_sequencing) or the sequencing of individual cells.
Companies like
[PacBio](http://www.pacb.com/smrt-science/smrt-sequencing/)
and [Oxford Nanopore](https://nanoporetech.com/applications/dna-nanopore-sequencing) have led recent developments in third and fourth generation
sequencing technologies.

High-throughput sequencing is a fast changing area with new technologies
emerging constantly. All these technologies give us reads, but each
uses different chemical processes to generate the reads. There are two
main properties of reads that are important from a computational perspective:

1. _Read lengths_: The longer the reads are the more information they contain.
Ideally, a read is simply the entire genome. Unfortunately, a read of such length is not achievable by chemistry today or in the foreseeable future.
Illumina reads are around 100bp-200bp long, and
PacBio reads are over 10000 bp long. While PacBio reads are longer than Illumina
reads, they are still much shorter than genome lengths.  
2. _Error rates and types of errors_: Illumina has relatively low error rates of 1-2%, and errors here are mostly substitution errors (_i.e._ a base being
replaced by some other base). PacBio reads have higher error rates
of 10-15%, and errors here are insertions and deletions.

The figure below shows some characteristics of different sequencing technologies.
<div class="fig figcenter fighighlight">
  <img src="/assets/lecture1/Figure5_different_sequencing_technologies.png" width="99%">
  <div class="figcaption">Characteristics of different sequencing technologies.</div>
</div>

### Data science of high-throughput sequencing <a id='ds-or-hts'></a>

The success of high-throughput sequencing is mainly due to
the creative use of read data to solve various problems. For this course, data science problems can be categorized into one of three types:

1. _Data processing_:
- Assembly or _de novo_ assembly: Recovering the original genome from short noisy reads.  
- Variant calling: Individuals of the same species have very similar genomes.
For example, any two humans share 99.8% of their genetic material. Because a reference human genome is available,
scientists are often interested in the differences of an individual's genome
from this reference genome. Variant calling is the problem of inferring these differences.  
- Phasing: The chromosomes in humans (and other higher animals) come in pairs but
are crushed and sequenced together. Often scientists want to separate the sequence
on the two chromosomes. This is called the phasing problem.  
- Quantification: RNA is an important biological molecule in cells, as discussed
above. There are potentially 10000s types of RNA molecules observed in an individual cell. Quantification is a counting problem; scientists are interested
in estimating how many copies of each type of RNA are in a cell or population of cells.

2. _Data management_: With large databases, natural problems that arise include
- Privacy
- Compression

3. _Data utilization_: Here we use the data to make useful inferences. These problems include  
- Single-cell analysis: Properties like diversity in cell populations are inferred from single-cell datasets.
- [Genome Wide Association Studies](https://en.wikipedia.org/wiki/Genome-wide_association_study)
(GWAS): This problem looks at the association between genomes and
various characteristics of individuals.  
- Multi-omics data analysis: Methods for combining DNA, RNA, and
protein measurements to make predictions.

These different problems are illustrated below:
<div class="fig figcenter fighighlight">
  <img src="/assets/lecture1/Figure4_problem_collage.png" width="70%">
  <div class="figcaption">Data science of High-throughput sequencing.</div>
</div>

#### Tools used <a id='tools'></a>

When working with high-throughput sequencing data, we first attempt to model the data. This usually involves many assumptions which are
not true in practice. While inaccurate, these models are used to come up with initial interesting algorithms. As real data often does
not satisfy these assumptions, some additional effort is required to get working algorithms even when the modeling is reasonable. Some tools we will use in this course are:

- Combinatorial algorithms: Problems like genome assembly involve working on
combinatorial objects like graphs, and combinatorial algorithms naturally follow.
- Statistical Signal Processing: Because the data is noisy, we need signal processing techniques for dealing with the noise.  
- Information Theory: When performing inference, this gives a sense of how much data is necessary to achieve "good" estimates.
- Machine Learning

### Two Example Applications <a id='examples'></a>

In this section, we discuss two representative problems that will be
covered in this course.

#### DNA-assembly<a id='assembly'></a>

The DNA sequencing machine outputs an analog signal (e.g. light intensities
or electric signals). We want to process this
signal to get the sequence. In essence, one could think of the DNA as a message,
the sequencer as a bad channel, and the base caller and assembler as the
decoder. This abstraction is shown below:

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture1/Figure6_DNA_decoding.png" width="70%">
  <div class="figcaption">DNA assembly as a message decoding problem.</div>
</div>

This abstraction gives us multiple avenues of exploring potential problems.
The extraction of digital information (discrete bases) from analog signals is a statistical signal processing problem. This involves various stochastic models with many parameters which need to be estimated.
Furthermore, one often has to account for
signals from adjacent bases interfering with one another. This intersymbol
interference is also a signal processing problem.

We can also consider the problem of assembling the genome from the reads obtained
after processing the analog signals. We want to first obtain an estimate of the number of reads necessary to be able to assemble with
reasonable accuracy. Using tools from information theory, we can
identify bottlenecks and design principles to deal with them, allowing us to
design efficient algorithms to overcome these bottlenecks. By efficient
here we mean linear in the number of reads.
In general, the size of data makes any super-linear algorithm unfeasible
in most cases; however, there are cases where smart algorithm design
and low level optimized software allows one to use algorithms that are quadratic in the number of reads.

#### Single-cell RNA quantification and analysis<a id='scrnaseq'></a>

As discussed above, RNA is another important biological molecule.
There exists around 10000 RNA sequences (or _transcripts_) floating in each cell,
each of which are 1000-10000 bp long. There may be many copies of the same
certain transcripts. Biologists are interested in the problem of _quantifying_ or estimating the number of each RNA transcript in a cell.

Biologists and chemists have figured out ways to convert RNA back into DNA
(mainly using an enzyme _reverse transcriptase_), and then sequence the DNA
to get reads using shotgun sequencing. The computational problem is trying
to estimate the number of transcripts of each type from these reads.

One often uses the reference of known transcripts observed in an organism: the  _transcriptome_. Despite there existing a reference, many transcripts have common subsequences and therefore one can not always be sure of where
a read originates from. A good algorithm for solving this problem is
[expectation-maximization](https://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm) (EM).

In a bulk experiment, a biologist crushes the 100s of millions of cells in a tissue together. After shotgun sequencing, the biologist obtains a mixture of the RNA
of all cells in the tissue. The transcript counts (or abundances) obtained
are therefore an estimate of the sum over all cells. Recent technologies have allowed biologists to sequence biological samples such as tissue at the single-cell resolution. Single-cell technologies allow researchers to observe the   diversity of cells within a cell population. Relevant problems here include clustering relevant features to uncover cell types.

-----------------

[Slides](/lectures/lecture1_slides.pdf)

-----------------

[This lecture as a pdf.](/assets/lecture1/lecture1.pdf)
