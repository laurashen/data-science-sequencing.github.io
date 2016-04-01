---
layout: page
mathjax: true
permalink: /drafts/lecture2/
---
## Biology Background, First and Second-generation sequencing

Wednesday 30 March 2016

-----------------

### Basics of DNA
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
minor (i.e. small SNPs, or Single Nucleotide Polymorphisms).

DNA is the mechanism for cell replication. When a cell undergoes
cell division, also known as _mitosis_, the DNA in its nucleus is
replicated and through a series of steps shown in the figure
below, one parent cell yields two identical child cells.


<div class="fig figcenter fighighlight">
  <img src="/assets/lecture2/Figure1_mitosis.png" width="99%">
  <div class="figcaption">A figure illustrating mitosis.</div>
</div>

#### DNA structure
DNA is comprised of four nucleotide bases (Adenine(A),
Cytosine(C), Guanine(G), and Thymine(T)) and a sugar-phosphate
backbone. It is structured in a double-helix formation, with
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

Now that we’ve familiarized ourselves with the structure of the
human genome, we’ll talk about a sequencing technique called
_Sequencing by synthesis_, which was first used in the form of
Sanger sequencing. Fred Sanger invented Sanger sequencing in
1977, and it was used to sequence genomic data until the mid
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
and second-generation sequencing. We will then discuss the parts
of the process that are specific to Sanger sequencing, and the
modifications made in second-generation sequencing which allow
the dramatic improvements in cost and quantity.

Sequencing by synthesis follows the following general steps:

1. Chop DNA sample, containing many copies of the genome, into
single-stranded fragments. Each fragment is a _template_.

2. Attach template strands to a surface.

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

### Sanger sequencing ###
Sanger sequencing follows the above general sequencing by
synthesis steps. The figure below illustrates a simple example
showing the process of Sanger sequencing. A template strand of
DNA is added to a test tube along with free-floating regular
nucleotides (dNTPs) and a few slightly-modified nucleotides
(ddNTPs) of just one type. A primer is added to start the
process of creating the complementary DNA strand, and then DNA
polymerase initiates the binding of free nucleotides to the
template. Each time a ddNTP (T* in this case) binds to the
template strand, the process is halted. When the reaction
finishes, we’re left with small percentages of strands
containing ddNTP T*s at locations where there is an A in the
template, and a large fraction of strands containing only
normal dNTPs. Then, we use gel electrophoresis to measure the
length of each strand to determine the position of each A
nucleotide in our original template strand. This process is
repeated using A*, C*, and G* ddNTPs in parallel.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture2/Figure4_SangerExample.png" width="75%">
  <div class="figcaption">Sanger sequencing through an example.</div>
</div>


### Second-generation sequencing ###
Second-generation sequencing, or Illumina sequencing, makes a few modifications to the Sanger process shown above as well as perform the process in massive parallel, which dramatically increases the throughput. One of the main improvements to second-generation sequencing is the method by which information is captured when each ddNTP binds to the template strand. Instead of having to measure each strand length using gel electrophoresis, Illumine sequencing tags each ddNTP with a different-colored fluorescent dye, and takes a picture of the fluorescence after each ddNTP binding timepoint. These fluorescent pictures are then analyzed by “base caller” software to “call” the complementary nucleotides.

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

## Looking forward ##
Next lecture, we’ll explore the answers to two questions
regarding sequencing by synthesis. First, how are errors
introduced? And second, why is the read length limited with this
method?
