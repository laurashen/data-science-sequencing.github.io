---
layout: page
mathjax: true
permalink: /Win2018/lectures/lecture1/
---
## Lecture 1: Introduction

Tuesday 9 January 2018

_Scribed by the course staff_

-----------------

### Topics

1. <a href='#what'> What is high-throughput sequencing? </a>  
  - <a href='#seq'> Sequencing methods
2. <a href='#ds-or-hts'> Data science of high-throughput sequencing </a>  
  - <a href='#tools'> Tools </a>  
  - <a href='#obj'> Objectives </a>
3. <a href='#examples'> Example problems </a>
  - <a href='#assembly'> _de novo_ DNA assembly </a>  
  - <a href='#align'> DNA Alignment</a>
  - <a href='#rnaseq'> RNA-seq quantification and analysis </a>
  - <a href='#downstream'> Downstream analysis </a>

----------------

<!---

### What is high-throughput sequencing? <a id='what'></a>

This course is about Data Science for High-throughput sequencing. The basic object of interest is the DNA or the genome, a sequence of four letters: A, C, T, G. The sequence could be very long. In the human, the sequence is made up of chromosomes, totaling about 3B chars. In bacteria, its on the order of millions, and surprisingly, in plants, the genome can be several billions of characters long.

The problem of sequencing is basically the problem of estimating the sequence ACTG of an organism. Sequencing has been around since the 80s starting with Sanger Sequence. In the 1990s, the NIH decided to fund a massive project for sequencing the human genome. A company called Solera arrived later in the game and provided competition for this government funded genome project. In the end, it was declared a tie, and the first draft of the genome was published in 2003. At the time, sequencing the genome was very expensive, roughly $1 per symbol. But something interesting happened in the 15 years afterwards.

The cool thing about technology is that once is proven possible, others will find cheaper, more efficient ways to solve the same problem. For HTS, this resulted in a huge speedup and a huge reduction in cost. Now, it takes a few hours or at most a day to sequence a genome for only $1000. This is a remarkable curve because there does not exist many technologies that produce this curve. We also see that these costs have plateaued in the recent 2 years.

Sequencing is basically the process of humans replicating nature. In nature, whenever a cell replicates, the DNA in the cell gets repeated; there is a process of copying DNA. Humans have designed machines mimicking this replication process.

The process of reading the genome is difficult. Instead of getting the entire genome at once, we instead break it up into several short fragments called **reads**. The length of a read depends on the sequencing technology, but the most common technology is pioneered by the company Illumina, resulting in reads of less than 200 characters long (much shorter than the length of any genome). However, we obtain many reads sampled quite densely across the genome. A lot of the sequencing problem is in estimating the genome from quite noisy data (i.e. noisy reads).

We will discuss the chemistry in more detail next lecture, but at a high level we read several parts of the genome in parallel, a very fast process.

### Microscope in the big data era

A microscope is a technology build to observe many different things. HTS is like a microscope in this sense: HTS allows us to make observations about many different things.

The sequencing started by sequencing the human genome: DNA. But humans have figured out how to sequence other (related) types of biomolecules as well, such as RNA. This results in one platform (HTS) that can be applied for different types of biomolecules. In a nutshell, we start with some biological measurement problem. The biochemist works hard to convert the biomolecule of interest into DNA, which we feed into a HTS machine. After obtaining noisy reads, the computational part comes in. Overall, we estimate something about biology given reads.

We will discuss the biochemistry briefly. We believe that knowing something about the chemistry so that when we design algorithms, we are cognizant of the physical systems we are designing these algorithms for.

Some quick math: We start with 3 billion bases ${A, C, T, G}$, the length of the genome $G$. Suppose each read has a length $L$ of 100 bases. The **coverage depth** is the average number of reads that cover a given character in the genome. To achieve a coverage depth $C$ of 30x, we would need $N=900,000,000$ reads.

$C = NL/G$

This gives us a sense of how big this data is. Therefore any algorithm that runs superlinearly in the amount of data will take too long for practical purposes here. In this course, when we say low complexity v. high complexity, we are talking about linear v. nonlinear.

Several HTS assays exist, allowing biologists to observe different kinds of data by reducing it to the same DNA-estimation problem. Examples of these assays include Hi-C-Seq, which measures 3D DNA structure, RNA-Seq, which measure RNA, and ChIP-Seq, which measures chromatic accessibility (epigenetics).

**RNA-Seq**: By observing RNA, we get a sense of function. Unlike DNA, which is the same in all cells, different cells and different types of cells express different RNA. Therefore RNA gives us a sense of the dynamic processes. Scientists have managed to harness the natural process of reverse transcription to create technologies for estimating the amount of RNA in cells.

**ChIP-Seq**: Different epigenetic markers (biomolecules that interact directly with the DNA) capture how the genome is regulated. Different proteins bind to parts of the genome, affecting that region's accessibility and hence how much that region is expressed. ChIP-Seq allows us to select out the parts of the genome which are around the binding protein.

**Hi-C-Seq**: In the simplest sense, DNA is a linear structure; however, in an actual cell the DNA is crunched up in some kind of 3D structure. A contact map gives us a sense of which regions of the genome (which  may be very far apart) are statistically likely to be interacting. Hi-C crosslinks regions DNA that are close in distance. After cutting the DNA around the crosslinked regions, we can build a contact map (and hence 3D structure) using HTS.

In summary, HTS can be applied for applications as diverse as functional genomics, population genetics, phenotype prediction, cancer, drug prediction, pathogen detection, and prenatal testing (cell-free DNA for noninvasive testing).

### HTS data science Problems

At the low level, we need to process the read data. We will talk about assembly, phasing, quantification, and variant calling.

Managing the data is another issue: compression and privacy

Utilizing the data downstream include problems such as genome-wide association studies (figuring gout which variation of the genome is correlation with a phenotype), multi-omics analysis, phylogenetic tree reconstruction, and single-cell analysis.

It turns out in that in the last few years, HTS technology has evolved to the point of allowing us to observe the RNA in individual cells (microfluidics).

**The goal of this course is to discuss fast, scalable, and statistically accurate inference algorithms.** --->

### <a id='what'></a>What is high-throughput sequencing?

The main object of interest in this course
is the [genome](https://en.wikipedia.org/wiki/Genome) of a
organism, which is made of
[_deoxyribonucleic acid_](https://ghr.nlm.nih.gov/handbook/basics/dna) (DNA).
All computational methods we discuss will
be related to deducing the sequence of the genome
or some property closely related to the genome. High-throughput sequencing (HTS) refers to modern technologies used to identify the sequence of a segment (or "strand") of DNA. Only 17 years ago, sequencing technologies were around 6 orders
of magnitude slower than they are today in terms of both cost and throughput.

The first major sequencing project was the
[Human Genome Project](https://www.genome.gov/10001772).
A big consortium began collaborative efforts in 1990 to
sequence the entire human genome.
The project was nominally completed in 2003, costing $2.7 billion and 13 years of
work by labs around the world. In 2017, the cost of sequencing a genome was approximately $1000. This is testament to how far the technology has
evolved. As shown below,
the cost of DNA sequencing has been falling
at a rate faster than Moore's law over the last
17 years.

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture1/HTS_cost.png" width="80%">
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

HTS can be thought of as a microscope
that can be used to measure a variety of quantities. The basic paradigm (shown below) is to reduce the estimation problem of
interest to a DNA sequencing problem, which can be handled
using HTS. This is similar in principle
to the reduction used to solve many mathematical problems
or to show NP-hardness of various problems.

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture1/star_seq_paradigm.png" width="99%">
  <div class="figcaption">The X-Seq paradigm: Convert the problem of interest to a DNA sequencing problem.</div>
</div>  

To get a sense of the scale of the data, consider the human genome $$G$$ which consists of 3 billion bases $$\{A, C, T, G\}$$. Suppose each read has a length $$L$$ of 100 bases. The _coverage depth_ is the average number of reads that cover a given base in the genome. To achieve a coverage depth $$C$$ of 30x, we would need $$N=900,000,000$$ reads since $$C = NL/G$$. Therefore any algorithm that runs superlinearly in the amount of data will take too long for practical purposes here. In this course, when we say low complexity v. high complexity, we are really talking about linear v. nonlinear.

For the biochemist, the challenge is in determining how to convert the problem of
interest to a problem which can be tackled
using HTS. This is similar to how biologists design experiments such that the results can
be observed under a microscope. For the computational biologist, the challenge is in performing the relevant type of
inference on the
data observed using HTS.
Some important sequencing assays are:

- RNA-Seq: RNA is an important intermediate product for producing protein from DNA.
While every cell in an organism has the same DNA, an individual cell's RNA content may be very different. RNA in cells can also vary depending on temporal and environmental factors. RNA-Seq is an assay that "measures" RNA, and
this was the first assay in which HTS was used to measure a molecule other than
DNA. The assay was developed in 2008 by
[Mortazavi _et al_](http://www.nature.com/nmeth/journal/v5/n7/abs/nmeth.1226.html).

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture1/rnaseq.png" width="70%">
  <div class="figcaption">RNA-Seq overview.</div>
</div>  

- ChIP-Seq: Different cells express different RNA because of _epigenetic_ factors or molecules that influence how the genome is packed in the cell. DNA in cells
are bound to proteins called histones, and for different cells, different parts of the genome are bound to histones. DNA wrapped around histones are harder to access and are not converted to RNA. ChIP-Seq is
an assay which was developed measure the
regions of the genome that are bound to histones. This assay was developed in 2007 by
[Johnson _et al_.](http://science.sciencemag.org/content/316/5830/1497).
Another recent assay called
[ATAC-seq](http://www.nature.com/nmeth/journal/v10/n12/full/nmeth.2688.html)
measures regions of the genome that are _not_ bound to histones.

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture1/chipseq.png" width="70%">
  <div class="figcaption">ChIP-Seq overview.</div>
</div>  

- Hi-C-Seq: This assay measures the 3D
structure of molecules and was developed by
[Belton _et al_.](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3874846/)
in 2012.

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture1/hicseq.png" width="70%">
  <div class="figcaption">Hi-C-Seq overview.</div>
</div>  

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

Another important application of HTS is
[cancer](http://cancergenome.nih.gov/cancergenomics/whatisgenomics/whatis).
Cancer is a "disease of the genome." It is caused
by rearrangements of the genome, which are sometimes very large.
By sequencing cancer cells, one gets information about
the nature of the cancer-causing mutation and can
tailor treatment.

[Non-invasive pre-natal testing](http://www.mayoclinic.org/tests-procedures/noninvasive-prenatal-testing/home/ovc-20187358)
for genetic birth defects
is another powerful application of
HTS. Traces of fetal DNA can be found
in the blood of the mother. The main idea here
is to sequence the maternal blood and
infer fetal genetic birth defects from the sequence.
HTS has been used successfully for detecting
[Down syndrome](http://www.mayoclinic.org/diseases-conditions/down-syndrome/basics/tests-diagnosis/con-20020948).

#### <a id='seq'></a>Sequencing methods

Science progresses by the
invention of measuring methods.
HTS is one such measurement
tool; however,
HTS is different
from many measurement tools because it
has a significant computational component. HTS (also called
[_shotgun sequencing_](https://en.wikipedia.org/wiki/Shotgun_sequencing))
takes the DNA
sequence as input, breaks it into smaller fragments or _reads_, and
returns a noisy version of these smaller fragments. We note that the length of reads range from 50-50000
while the human genome is of length 3 billion. Fortunately,
these small noisy subsequences also contain information
about the genome. While a single read contains very little
information about the entire sequencing,  a
typical experiment generates a few hundred million reads
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
is most heavily represented by [Illumina](http://www.illumina.com/technology/next-generation-sequencing.html)
and is currently the dominant technology. Recent developments in Illumina sequencing have
allowed scientists perform
[single-cell sequencing](https://en.wikipedia.org/wiki/Single_cell_sequencing) or the sequencing of individual cells.
Companies like
[PacBio](http://www.pacb.com/smrt-science/smrt-sequencing/)
and [Oxford Nanopore](https://nanoporetech.com/applications/dna-nanopore-sequencing) have led recent developments in third and fourth generation
sequencing technologies.

HTS is a fast changing area with new technologies
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
  <img src="/Win2018/assets/lecture1/Figure5_different_sequencing_technologies.png" width="99%">
  <div class="figcaption">Characteristics of different sequencing technologies.</div>
</div>

### <a id='ds-or-hts'></a>Data science of high-throughput sequencing

The success of HTS is mainly due to
the creative use of read data to solve various problems. For this course, data science problems can be categorized into one of three types:

1. _Data processing_:
- Assembly or _de novo_ assembly: Recovering the DNA or RNA from short noisy reads.  
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
  <img src="/Win2018/assets/lecture1/Figure4_problem_collage.png" width="70%">
  <div class="figcaption">Data science of High-throughput sequencing.</div>
</div>

#### <a id='tools'></a>Tools

When working with HTS data, we first attempt to model the data. This usually involves many assumptions which are
not true in practice. While inaccurate, these models are used to come up with initial interesting algorithms. As real data often does
not satisfy these assumptions, some additional effort is required to get working algorithms even when the modeling is reasonable. Some tools we will use in this course are:

- Combinatorial algorithms: Problems like genome assembly involve working on
combinatorial objects like graphs, and combinatorial algorithms naturally follow.
- Statistical Signal Processing: Because the data is noisy, we need signal processing techniques for dealing with the noise.  
- Information Theory: When performing inference, this gives a sense of how much data is necessary to achieve "good" estimates, allowing us to design optimal algorithms to achieve such estimates.
- Machine Learning

#### <a id='obj'></a>Objectives

In this course, we will work towards two key objectives:

1. Introduce an important and exciting application domain for data science.
2. Introduce interesting algorithms and statistical concepts in a concrete well-motivated setting.


### <a id='examples'></a>Example Problems

In this section, we discuss representative problems that will be
covered in this course.

#### <a id='assembly'></a>DNA-assembly (_de novo_)

The DNA sequencer outputs an analog signal (e.g. light intensities
or electric signals). We want to process this
signal to get the sequence. In essence, one could think of the DNA as a message,
the sequencer as a communication channel, and the base caller and assembler as the
decoder. This abstraction is shown below:

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture1/Figure6_DNA_decoding.png" width="70%">
  <div class="figcaption">DNA assembly as a message decoding problem.</div>
</div>

This abstraction gives us multiple avenues of exploring potential problems.
The extraction of digital information (discrete bases) from analog signals is a statistical signal processing problem. This involves various stochastic models with many parameters which need to be estimated.
Furthermore, one often has to account for
signals from adjacent bases interfering with one another. Dealing with intersymbol
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

_de novo_ here means "from new," which is relevant when we assemble a genome for the first item, for example in a new strain of bacteria or in cancer.

#### <a id='align'></a>DNA Alignment

The alignment problem is as follows: given a reference genome and a new read, we are interested in finding where the new read aligns to the reference genome. This is useful for finding the genomic regions that distinguish two individuals, which may indicate risk for disease and likelihood of possessing certain phenotypes. This problem is nontrivial for three reasons:

1. There are errors in the reads, and therefore looking for exact alignment is challenging.
2. The genome is quite repetitive, and therefore a read may have several places it can align to. In fact, there are regions of the genome (e.g. [Alu repeats](https://en.wikipedia.org/wiki/Alu_element)) that are repeated millions of times.
3. Recall above that we need to align $$ N = $$ 900,000,000  reads to a length 3B genome. Therefore the naive process of scanning the entire genome for each read's match is too slow.

#### <a id='rnaseq'></a>RNA quantification and analysis

As discussed above, RNA is another important biological molecule.
There exists around 20000-100000 RNA sequences (or _transcripts_) floating in each cell,
each of which are 1000-10000 bp long. Biologists are interested in the problem of _quantifying_ or estimating the number of each RNA transcript (the _expression level_ of that transcript) in a cell.

Biologists and chemists have figured out ways to convert RNA back into DNA
(mainly using an enzyme called _reverse transcriptase_) and then sequence the DNA to get reads using HTS. The computational problem is trying
to estimate the number of transcripts of each type from these reads.

One often uses the reference of known transcripts observed in an organism: the  _transcriptome_. Despite there existing a reference, many transcripts have common subsequences and therefore one can not always be sure of where
a read originates from. A good algorithm for solving this problem is
[expectation-maximization](https://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm) (EM).

#### <a id='downstream'></a>Downstream analysis

Suppose we measure gene expression levels of two types of mice, for example a stressed mouse v. a relaxed mouse. Based on the expression levels of all 20000 genes, we can ask: which genes distinguish the two mouse states? This problem is known as _differential expression_.

Additionally, because there are so many genes, by sheer luck, some genes may appear to be significant. To account for this issue, we will leverage techniques from _multiple hypothesis testing_ (e.g. false detection rate control).

In a bulk experiment, a biologist crushes the 100s of millions of cells in a tissue together. After sequencing, the biologist obtains a mixture of the RNA
of all cells in the tissue. The transcript counts (or abundances) obtained
are therefore an estimate of the sum over all cells. Recent technologies have allowed biologists to sequence biological samples such as tissue at the single-cell resolution. Single-cell technologies allow researchers to observe the diversity of cells within a cell population. Relevant problems here include dimensionality reduction, clustering, and identifying relevant features for characterizing cell types.

-----------------

[Slides](/Win2018/assets/lecture1/lecture1_slides_18.pptx)
