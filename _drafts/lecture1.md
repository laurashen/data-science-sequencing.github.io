---
layout: page
mathjax: true
permalink: /drafts/lecture1/
---
## Course Highlights

Monday 28 March 2016

-----------------



### Need to understand high-throughput sequencing

The main object of interest in this course
is the [genome](https://en.wikipedia.org/wiki/Genome) of a
organism. The genome of an organism is its genetic material
which is usually made of
[deoxyribonucleic acid](https://ghr.nlm.nih.gov/handbook/basics/dna).
All computational methods we discuss in this course will
try to solve a problem which is related to deducing genome
or some property that is quite close to the genome.

High-throughput sequencing is the technology to sequence
the genome these days. Only 15 years ago, the
the sequencing technologies were around 6 orders
of magnitude slower than they are today (and more
expensive by around 6 orders of magnitude too!!).

Interest in sequencing was first sparked by the
[Human Genome Project](https://www.genome.gov/10001772).
This was a big consortium that got together to
sequence the human genome in 1990.
They released their first draft in 2003.
It  cost $2.7 billion, and 13 years of
work by labs around the world to
sequence the genome. In 2015, it cost
around $1000 to sequencing a genome.
This is testament to how far the technology has
evolved. As shown below,
the cost of DNA sequencing has been falling
at a rate faster than Moore's law over the last
15 years.


<!-- ![Cost of DNA sequencing over the years](/assets/lecture1/HTS_cost.png){: width="99%"} -->


<div class="fig figcenter fighighlight">
  <img src="/assets/lecture1/HTS_cost.png" width="99%">
  <div class="figcaption">Cost of DNA sequencing over the years.</div>
</div>


DNA is a very important biological molecule,
but it’s only one of many important biological molecules.
Other important biological molecules include
[ribonucleic acids](https://en.wikipedia.org/wiki/RNA)
and [proteins](https://en.wikipedia.org/wiki/Protein).
Some innovative bio-chemistry has allowed the
use of DNA sequencing technology to measure properties of
various other biological molecules (and there are proposals to
[detect dark matter using this](http://arxiv.org/abs/1206.6809)).
The basic paradigm is to reduce the estimation problem of
interest to the a DNA sequencing problem, which is then sequenced
using high-throughput sequencing. This is similar in principle
to the reduction used to solve many mathematical problems,
or to show NP-hardness of various problems. This is illustrated
below.
<div class="fig figcenter fighighlight">
  <img src="/assets/lecture1/star_seq_paradigm.png" width="99%">
  <div class="figcaption">The -seq paradigm: Convert problem of interest to DNA sequencing problem and solve that.</div>
</div>

One analogy would be to think of high-throughput sequencing
to be a piece of equipment (like a microscope, say)
that can be used to measure a variety of quantities.
The challenge to the bio-chemists is to covert the problem of
interest to them to a problem which can be measured
using high-throughput sequencing (just like biologists
have to design experiments such that the results can
be observed under a microscope). The challenge to
the computational biologist is to do the relevant type of
inference on the
data observed using high-throughput sequencing.
Some important sequencing assays are:

- RNA-Seq: RNA important intermediate product for producing protein from DNA.
Every cell in a human has the same DNA
but very different RNA. RNA in cells also shows
a lot of variation over time, and the environment.
RNA-Seq is an assay to "measure" RNA.  
This was the first assay in which high-throughput
sequencing was used to measure a molecule other than
DNA. It was developed in 2008 by
[Mortazavi _et al_](http://www.nature.com/nmeth/journal/v5/n7/abs/nmeth.1226.html).

- ChIP-Seq: The difference in RNA across cells is
to a large extent due to the fact that DNA in cells
are bound to proteins called histones. In different
cells different parts of the genome are bound to
histones. Only parts of the DNA that are not
bound to histones get converted to RNA. This is
an assay which was developed measure the
regions of the genome that are bound to histones in
cells. This was developed in 2007 by
[Johnson _et al_](http://science.sciencemag.org/content/316/5830/1497).
Another recent assay called
[ATAC-seq](http://www.nature.com/nmeth/journal/v10/n12/full/nmeth.2688.html)
measures regions of the genome that are _not_ bound to histones.

- Hi-C-Seq: This is an assay used to measure measure the 3D
structure of molecules. This was developed by
[Belton _et al_](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3874846/)
in 2012.


One of the most interesting and  important problems is
predicting the phenotype (physical characteristics
like a person's height, or if he/she likes the colour red)
from the person's genotype (DNA sequenced).
This is important in medicine to predict susceptibility
to diseases. A big success-story here is the
discovery of that presence of a particular mutation in the
gene [BRCA1](http://www.cancer.gov/about-cancer/causes-prevention/genetics/brca-fact-sheet)
increases the risk of breast cancer to around
45%.

Another important application of high-throughput sequencing is
[cancer](http://cancergenome.nih.gov/cancergenomics/whatisgenomics/whatis).
Cancer is a "disease of the genome". It is caused
by rearrangements of the genome (which are sometimes very large).
By sequencing cancer cells, one gets information about
the nature of the cancer-causing mutation, and
tailor treatment to that.

[Non-invasive pre-natal testing](http://www.mayoclinic.org/tests-procedures/noninvasive-prenatal-testing/home/ovc-20187358)
for genetic birth defects
is another very interesting application of
high-throughput sequencing. There are traces of foetal DNA
in the maternal blood. The main idea here
is to sequence the maternal blood, and
try to infer foetal genetic birth defects from it.
This has been used successfully to detect
[Down's syndrome](http://www.mayoclinic.org/diseases-conditions/down-syndrome/basics/tests-diagnosis/con-20020948).

### What is High-throughput sequencing?

Science is basically progressed by the
invention of measuring methods.
High-throughput Sequencing is one such measurement
tool.  However,
high-throughput Sequencing is different
from many measurement tools in the fact that it
has a significant computational component. High-throughput
sequencing (also called _shotgun sequencing_) basically consists 



Sequencing is different from many measurement tools. Science is basically progressed by the invention of measuring methods. Sequencing has a significant computational component. The flow diagram shows a sequencing machine taking a DNA molecule to generate a bunch of (read) data. It is because of these types of read data that leads to so many interesting computational problems. so we should thank the biochemists for not figuring out how to sequence the entire DNA from beginning to end (3 billion symbols, 23 chromosomes). Instead, the data is pretty bad. Fortunately, it still contains significant information, but the extraction of the information comes at a price, and thats where the computational part comes in.

Instead of reading the DNA sequence from beginning to end, what we get from the output of the sequencer is a lot of very short fragments called reads (a subsequence of the DNA which is very short, on the order of 100 symbols). One single read contains of course very little information about the DNA, but in a typical experiment we can get a few hundred million of such reads (hence “high-throughput”) relatively cheaply (in terms of both time and money). Read data is very fragmented and noisy. The sequencing process is noisy. Each of these reads can potentially be different from the original sequence from which the read came from.
The revolution is because of the evolution of sequencing technologies. Sequencing started by Sanger, who invented the idea of sequencing (very low throughput), which was the dominant technology until the human genome project (second-generation sequencing). The dominant technology is by a company called illumina. In the past few years, theres been a new third0 generation of sequencing (single-cell, Nanopore, PacBio).
HTS is a fast changing area with new technologies emerging constantly. The basic data you get from each of these technologies is a lot of reads. However, different technologies are based on different chemistry. This is interesting to us is because the computational stuff has to do with dealing with noise. understanding the chemistry gives us a feeling of where these errors come from (the nature of these errors). e.g. understanding the physics of the technology for the channel.
Key parameter #1 is the read length. the longer they are the better. ideally we want the entire genome, but no chemistry has been able to accomplish this yet. Illumine can get reads that are about 100 bp (base pairs) long. PacBio can get reads that are > 10000 bp. We have a wide range of genome lengths but all of them are considerably shorter than the genome.
For Illumina, we have short reads but also low error (2%). On the other hand, long errors (PacBio) has large numbers of reads (10-15%).


-----------------

[Slides](/lectures/lecture1_slides.pdf)
