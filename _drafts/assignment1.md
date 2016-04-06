---
layout: page
mathjax: true
permalink: /drafts/assignment1/
---
## Assignment 1

posted Wednesday 6 April 2016  
due Wednesday 20 April 2016

### Question I: Basics of sequencing

#### a) complementary pairs

#### b) Sanger sequencing

### Question II: Base calling

### Question III: Read alignment (Programming)

Python programming is required for all of part a) and question 3 in part b). Please write your code in [this iPython notebook](/assets/assignment1/ee372_assignment1q3.ipynb) and email the completed assignment to ee372-spr1516-staff@lists.stanford.edu. Save your completed notebook as "ee372_assignment1q3_FIRSTNAME_LASTNAME.ipynb".

#### a) Naive aligner

1. Write a function that computes the edit distance between two strings. You can use standard libraries such as [editdistance](https://pypi.python.org/pypi/editdistance) to check the correctness of your function. The input should be two strings each of at least length 2. The output should be a float representing the edit distance between the two input strings.

2. Write a function that generates random reads. The input should be the number of reads generated $$N$$ and the length $$L$$ of each read generated. The output should be $$N$$ random length-$$L$$ sequences of nucleotides.

3. How can you use the above two functions to perform alignment? What issues do you see with this approach? (3-4 sentences).

4. For $$L$$ = 10, generate two reads of length $$L$$ and compute their edit distance. Average your result over 100 runs to obtain an estimate of the average edit distance $$\hat{d}_L$$ of two randomly generated reads of length $$L$$. Repeat for $$L$$ = 1, 100, 1000, and 10000. Plot $$\hat{d}_L$$ as a function of $$L$$ with error bars. Do you observe any trends? What can you say about how well random strings align? (1-2 sentences).

#### b) Bowtie

1. We are given $$N$$ reads of length $$L$$ and a reference genome of length $$\ell$$. Assuming reads were sampled uniformly from the entire genome, what is the expected number of times a base at a particular position will be sequenced? In other words, what is the _sequencing depth_ of each base in the genome? What is the probability that we see the exact same read twice? You can assume that if a length-$$L$$ sequence appears in the genome, it appears exactly once.

2. Download the reference genome for _E. coli_ [here](http://portal.nersc.gov/dna/microbial/assembly/uploads/dtse/Mock-Community/E.coli_K12_ATCC_700926.fasta). Download a set of reads obtained from an _E. coli_ experiment [here](http://portal.nersc.gov/dna/microbial/assembly/uploads/dtse/Mock-Community/e.coli_k12_atcc_700926.fastq.gz). You can right click each link and select "Save Link As".
- What is the length of the reference?
- What is the length of each read?
- How many reads are there?
- What is the maximum number of times a read is repeated?
- What is the sequencing depth of each base in the reference for this experiment?

3. How many distinct 20-length substrings do you see across all reads? These substrings are commonly referred to as $$k$$-mers where $$k$$ = 20. Count how often each distinct 20-mer appears and generate a histogram of the counts. (_Hint_: Note that initializing a length-$$4^{20}$$ array may not be a viable approach. Consider using dictionaries!)

4. [Bowtie](http://bowtie-bio.sourceforge.net/manual.shtml) is a popular read aligner optimized for aligning large amounts of short reads to long references. Bowtie is preinstalled on Stanford's Corn cluster, but you can also install Bowtie on your local machine by downloading the [binary](https://sourceforge.net/projects/bowtie-bio/files/bowtie/).
- Build a Bowtie index from the _E. coli_ reference genome ("bowtie-build" command). You can copy the downloaded files from your computer to Corn using the [scp](http://www.hypexr.org/linux_scp_help.php) command.
- Using the default settings, use Bowtie to align the _E. coli_ reads to the newly built Bowtie index. Use Bowtie's "-t" option to obtain the runtime. How many reads have at least 1 reported alignment? What was the runtime?


---

[This assignment as a pdf.](/assets/assignments/assignment1.pdf)
