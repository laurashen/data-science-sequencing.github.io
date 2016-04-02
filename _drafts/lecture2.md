---
layout: page
mathjax: true
permalink: /drafts/lecture2/
---
## Biology Background, First and Second-generation sequencing

Wednesday 30 March 2016

-----------------

### Biological Background



We start by exploring briefly the basics of the human genetic
code. The human _genome_ is the entire DNA sequence of an
individual, or all of the individual’s chromosomes. Humans have
23 pairs of chromosomes (each pair contains one chromosome
inherited from the mother and one inherited from the father) to
yield 46 chromosomes total. 22 of the pairs are autosomal
chromosomes, and one pair is sex chromosomes.The genome is
contained in the nucleus of each human cell, and every cell in a
human being contains the same exact genomic data. In humans, the
genome is 3 billion nucleotides long. Out of these 3 billion
_base pairs_, generally each individual human varies from other
humans at 3-4 million base pair locations. Most variations are
 small
 [Single Nucleotide Polymorphisms](https://ghr.nlm.nih.gov/handbook/genomicresearch/snp)
 (SNPs), though there are some large variations called
[Structural Variants](http://www.ncbi.nlm.nih.gov/dbvar/content/overview/)(SVs).


DNA is the mechanism for cell replication. When a cell undergoes
cell division, also known as _mitosis_, the DNA in its nucleus is
replicated and through a series of steps shown in the figure
below, one parent cell yields two identical child cells.


<div class="fig figcenter fighighlight">
  <img src="/assets/lecture2/Figure1_Mitosis.png" width="99%">
  <div class="figcaption">A figure illustrating mitosis.</div>
</div>

The variation in the genome is caused by either :

1. Random mutations: These are mainly due to "errors"
during the DNA replication process during cell division
Most of these mutations lead to phenotypic
changes that are harmful, and lead to the
death of the cell. These are called deleterious mutations.
However, rarely natural selection favours mutations
that arise randomly, and these are preserved in the
population.
2. Recombination: This occurs during reproduction
in higher organisms like mammals, where the genetic material passed
by an organism to its child is a mixture of genetic material
it receives from its parents.

#### DNA structure
DNA is comprised of four nucleotide bases (Adenine(A),
Cytosine(C), Guanine(G), and Thymine(T)) and a sugar-phosphate
backbone. It has two strands, and is
structured in a double-helix formation, with
_base pairs_ as the “rungs” of the helix. These base pairs are
comprised of pairs of nucleotides bound together by hydrogen
bonds. Adenine always binds with Thymine (A-T) and Cytosine
always binds with Guanine (C-G). The structure of DNA is shown
below.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture2/Figure2_DNADoubleHelix.png" width="75%">
  <div class="figcaption">The DNA double-helix.</div>
</div>


DNA also has a direction, which goes from the 5’ end (head) to
the 3’ end (tail). This is the convention that we follow when we
write a DNA strand. Also important to note: when we write a DNA
strand, we only write the letters representing the bases from
one of the strands. The other strand can be inferred because it
is the _reverse complement_. To get the reverse complement,
simply reverse the order of the nucleotides in the original
string and then complement the nucleotides (i.e. interchange A/T
and C/G). The figure below shows an example of a DNA fragment
and its reverse complement strand.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture2/Figure3_ReverseComplement.png" width="25%">
  <div class="figcaption">An illustration of DNA complement.</div>
</div>

### Sequencing by synthesis

The first technique used to get reads from DNA was a process
called [Sanger sequencing](https://en.wikipedia.org/wiki/Sanger_sequencing),
which is based on the idea of
_Sequencing by synthesis_.
[Fred Sanger](https://en.wikipedia.org/wiki/Frederick_Sanger) won
his second Nobel prize for the invention of  Sanger sequencing.
It was invented in 1977, was the main technology
used to sequence genomic data until the mid
2000’s, at which point second-generation sequencing was
invented. The two sequencing techniques are related because they
both use the sequencing by synthesis technique; however,
second-generation sequencing achieves a six-order of magnitude
improvement in both cost of sequencing and quantity of data able
to be sequenced, due to the fact that it performs sequencing by
synthesis in massive parallel.

We’ll demonstrate the concept of sequencing by synthesis below.
The technique takes advantage of the fact that DNA strands,
which are normally in double-helix form, split apart for mitosis
and are replicated based on their complementary relationship.
This example will illustrate the basic methodology behind
sequencing by synthesis, which is the backbone of both Sanger
and second-generation sequencing.

Sequencing by synthesis follows the following general steps:

1. Chop DNA sample, containing many copies of the genome
and increase the temperature so that the two strands of the
double strands come apart to form
single-stranded fragments. Each fragment is a _template_.

2. Attach  strands to a surface.

3. Make copies so that each template becomes a cluster of
templates, all the exact same.

4. Add DNA polymerase enzyme as well as tagged free-floating
nucleotides, called ddNTPs. These nucleotides cause
complementary binding to stop after they bind to the template
strand.

5. DNA polymerase will facilitate complementary binding of
ddNTPs to each template strand.

6. Capture and store the information about the ddNTP that just
added to the newly created complementary strand. This
information will be translated into the _sequence read_ at the
end of the process.

7. Repeat process until the entire template strand has
bonded to the created complementary strand.

However we note that these microscopic complementary
strands can not be observed. Sanger sequencing and
second generation sequencing differ in how they reduce
the problem of sequencing the genome from here to
measuring a property of the DNA.

#### Sanger sequencing
Sanger sequencing follows the above general sequencing by
synthesis steps. The figure below illustrates a simple example
showing the process of Sanger sequencing.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture2/Figure4_SangerExample.png" width="75%">
  <div class="figcaption">Sanger sequencing through an example.</div>
</div>

A template strand of
DNA is added to a test tube along with free-floating regular
nucleotides (dNTPs, where the 4 types are represented as dATP, dCTP,
dGTP, dTTP) and a few modified nucleotides
(ddNTPs) of just one of the 4 type. ddNTPs differ
from dNTPs in the fact that they act as terminators
for DNA polymerase, and hence result in the replication to stop.

A primer is added to start the
process of creating the complementary DNA strand, and then DNA
polymerase initiates the binding of free nucleotides to the
template. Each time a ddNTP (T\* in this case) binds to the
template strand, the process is halted. When the reaction
finishes, we’re left with small percentages of strands
containing ddNTP T*s at locations where there is an A in the
template, and a large fraction of strands containing only
normal dNTPs. Then, we use gel electrophoresis to measure the
mass of each strand to determine the position of each A
nucleotide in our original template strand. This process is
repeated using A\*, C\*, and G\* ddNTPs in parallel.

We then get
the masses of the molecules when terminated at the
positions of A, G, C, and T. We combine these
to get the sequence



|-------
| A    	| C    	| G    	| T    	|
| ----- | ----- | ----- | ----- |
| 30.0  	| 48.2  	| 56.7  	| 86.3  	|
| 61.3  	| 99.3  	|      	|      	|
| 74.4  	|      	|      	|      	|


Then merging these 4 sorted lists gives us the underlying
sequence. In the example we get

30.0 - A  
48.2 - C  
56.7 - G  
61.3 - A  
74.4 - A  
86.3 - T  
99.3 - C  

giving us the sequence to be **ACGAATC**.

#### Second-generation sequencing
Second-generation sequencing, or pioneered by
[Illumina](http://www.illumina.com/technology/next-generation-sequencing.html),
makes a few modifications to the Sanger process shown
above as well as perform the process in massive parallel,
which dramatically increases the throughput. One of the
main improvements to second-generation sequencing is the
method by which information is captured when each ddNTP
binds to the template strand. Instead of having to measure
each strand length using gel electrophoresis, Illumina
sequencing tags each ddNTP with a different-colored fluorescent dye,
and takes a picture of the fluorescence after each ddNTP binding
timepoint. These fluorescent pictures are then analyzed by
“base caller” software to “call” the complementary nucleotides.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture2/Figure5_IlluminaInfoCollection.png" width="95%">
  <div class="figcaption">An illustration of Illumina sequencing.</div>
</div>

Illumina sequencing also uses _reversible termination_, a
process by which an enzyme can turn a ddNTP into a regular
dNTP after it has bound, so the reaction can continue to
occur instead of being permanently halted for that particular
strand. In addition, Illumina sequencing can sequence billions
of clusters simultaneously, which greatly increases the
throughput.


--------------------------------------------

- [Slides on Biological Background](/lectures/lecture2_slides1.pdf) :
Borrowed from [Ben Langmead](http://www.langmead-lab.org/)'s
[slides](http://www.cs.jhu.edu/~langmea/resources/lecture_notes/biological_background.pdf)

- [Slides on Sequencing by Synthesis ](/lectures/lecture2_slides2.pdf)
: Borrowed from Ben Langmead's
[slides](http://www.cs.jhu.edu/~langmea/resources/lecture_notes/dna_sequencing.pdf)

- Ben Langmead's [animation showing Sequencing by Synthesis](https://github.com/BenLangmead/ads1-slides/blob/master/0055_dnaseq__sequencing_by_synthesis.pdf)

- These notes are based on notes scribed by Claire Margolis. The
reverse complement figure, and the Sanger sequencing figure are both
due to her. The rest are taken from Ben Langmead's notes.
