---
layout: page
mathjax: true
permalink: /lectures/lecture10/
---
## Lecture 10: Errors and Alignment

Monday 2 May 2016

_Scribed by Nattapoom Asavareongchai and revised by the course staff_



## Topics

In the previous lecture, we learned about the multibridging algorithm, which was an improved k-mer based algorithm. We then looked at read-overlap graphs and the greedy and not-so-greedy algorithm associated with the graph. In this lecture we will consider the different types of errors that may be present and how they affect the algorithms we have derived. We will then move on to discuss about the alignment problem.

1.	<a href='#pratical'>Assembly Algorithms in Practice</a>
2.	<a href='#error'>Errors</a>
    - <a href='#type'>Types of errors</a>
    - <a href='#greedy'>Impact of error on greedy algorithm</a>
    - <a href='#kmer'>Impact of error on k-mer algorithm</a>
3. <a href='#alignment'> Alignment</a>
	- <a href='#subproblem'>Edit distance & Dynamic Programming</a>

## <a id='practical'></a>Uses of Algorithms in Practice

To recap what we have done so far, we have derived 2 classes of algorithms or 2 paradigms used for DNA assembly:


  1. k-mer based algorithms:  
     - de Bruijin graph  
     - simple bridging & multibridging  
  2. Read-overlap graph algorithms:  
     - greedy algorithm  
     - not-so-greedy algorithm

But the important question is, how are these algorithms used in practice?

The de Bruijin graph algorithm is usually used for short read assembly. Read-overlap graph algorithms are usually used for long reads (e.g. from Sanger sequencing).

The algorithm generally used for long read assembly are variants of the [String graph](http://bioinformatics.oxfordjournals.org/content/21/suppl_2/ii79.abstract).
The standard such assemblers are the Celera assembler or its succesor [Canu](http://canu.readthedocs.io/en/stable/), the [HGAP](https://github.com/PacificBiosciences/Bioinformatics-Training/wiki/HGAP)
assembler and its successor [FALCON](https://github.com/PacificBiosciences/FALCON). Recently there have been some
interesting ideas derived from the greedy algorithm to generate quick assemblies with assemblers like
[Miniasm](http://arxiv.org/abs/1512.01801).

In practice assembling the whole DNA genome is impossible, so how well are the algorithms we have mentioned perform? What if we do not have enough reads/data?  

  - In the case of the de Bruijin graph algorithm, if there are repeats that cannot be resolved because of the lack of data, the algorithm does not break down and data on these repeats can be kept. Basically, the algorithm can take note that these particular repeats have not been resolved. If in the future more data have been obtained and a read that is able to resolve the repeats is found, the algorithm can easily use stored data to improve on their results. This holds true for the multibridging algorithm to a large
  extent as well. The only scenario under which it can break down is the case where there is a triple repeat with at least one copy bridged by a read, and one copy not bridged
  by reads (an some nested repeat setups).
  - However in contrast, the greedy and not-so-greedy algorithm does not keep information about unresolved repeats. This is because it is an aggressive algorithm that relies on pruning the graph and so data are thrown out as much as possible to simplify the problem. The practical string graph based algorithms use some interesting heuristics to keep track of long repeats and not create mis-assemblies.

## <a id='type'></a>Errors

Our discussion in earlier lectures assume perfect reads with no errors. However, this is not the case in practice. There are always errors present during sequencing and base-calling. We want to therefore answer the question: What is the impact of errors on assembly? How do we account for these errors in the algorithms we have presented?

### <a id='type'></a> Type of Errors

There are three types of errors:

  1. Substitution error  
  2. Insertion error  
  3. Deletion error  

E.g. Suppose we have an underlying sequence: <tt>AGGCTTAAT</tt>.

Substitution error:  <tt>AGGC<span style="color:red">C</span>TTAAT</tt>

Insertion error:  <tt>AGGCTTAA<span style="color:red">A</span>T</tt>

Deletion error: <tt>AGGCTT<span style="color:red">-</span>AT</tt>

Second generation technologies like Illumina have mainly substitution errors at a rate of around 1-2%


Third and fourth generation technologies like PacBio and Nanopore have no PCR, and hence the error rate is $$\approx$$ 10-15%
with type of errors being mainly insertions and deletions.

### <a id='greedy'></a>Impact of Error on Greedy Algorithm

Lets first consider the greedy algorithm and how errors will impact its performance.

Greedy recap: An algorithm that merges the longest overlap.

If there are errors present, we won't be able to find a perfect overlap and longest overlap may be corrupted by errors (and would be considered not an overlap by the algorithm).

- To account for the errors, not only do we account for perfect overlap, we must also consider approximate overlap.  
- For example, an approximate overlap of 99% would mean that 99% of the overlapped nucleotides match, while the other 1% do not.  
- So what should be the approximate percentage for the overlap?  
	- This depends on the error rate. The approximate percentage should intuitively be = (1 -  2 x error rate).  
	- E.g. a 1% error rate may cause 1% error on each side of the overlapped reads, thus there would be a possibility of a 2% error. The approximate percentage overlap would then be 98%.  

### <a id='kmer'></a>Impact of Errors on k-mer Algorithm

Now lets consider the class of k-mer algorithms. We will use an example to show how an error may affect our k-mer graph.

Consider a sequence of letters (we will use the English alphabets instead of A,G,C,T in this case) and the two reads of length 5:

$$
\mathrm{\overbrace{HELLO}^\text{first read}WORLD} \\
\mathrm{HE\underbrace{LLOWO}_\text{second read}RLD}
$$

Here, L = 5 and k = 3. The k-mers from the 2 reads are:

$$
\mathrm{reads \rightarrow kmer : \\ HELLO \rightarrow HELL, ELL, LLO \\}
\mathrm{     LLOWO \rightarrow LLO, LOW, OWO}
$$

We can therefore create a k-mer graph from this 2 reads as follow:

$$
\mathrm{HEL \rightarrow ELL \rightarrow LLO \rightarrow LOW \rightarrow OWO}
$$

Now suppose we have a third read, OWORL. But this read is corrupted and has an error, so we read OWXRL instead. The k-mer for this read are OWX, WXR, XRL. Therefore, combining this third read we have:

$$
\mathrm{HEL \rightarrow ELL \rightarrow LLO \rightarrow LOW \rightarrow OWO \rightarrow OWX \rightarrow WXR \rightarrow XRL}
$$

instead of:

$$
\mathrm{HEL \rightarrow ELL \rightarrow LLO \rightarrow LOW \rightarrow OWO \rightarrow OWO \rightarrow WOR \rightarrow ORL}
$$

The error read creates a new path in the k-mer graph that branches out and may then be connected back to the main path. This branched out path is called a **bubble**.  
   - In practice our dataset is large and we have a large number of reads. We may have both OWORL and OWXRL reads in our dataset.  
   - With bubbles we will have two possible paths. This would create ambiguity in finding the Eulerian path from the k-mer graph.  

There are methods used to address these in practice  
	1. We can align the two possible paths and choose the path that occurs more often. Since the error path is rare, or may occur in fewer reads, there is a higher probability that the correct path will occur more often. Thus, choosing the more common path would eliminate the error bubble.  
	2. Prefiltering: to filter out reads that contain errors before actually creating our k-mer graph.  

####Prefiltering to Remove Error Reads

To find reads that contain errors in our dataset, we must consider the probability of correct reads occurring in our dataset as well as the probability of incorrect reads (errors) occurring.

So how many times will a particular k-mer appear, assuming that there are no error?

$$
\mathrm{\text{Let, G = genome length, and N = # of reads of length L} \\
\mathbb{E}[\text{ Number of occurrences of a k-mer}] = \frac{(L-k)}{G}N = \underbrace{\frac{NL}{G}}_\text{coverage}\frac{(L-K)}{L}}
$$

Now for example we have k = 20, L = 100, and coverage = 30X.

$$
\mathrm{\mathbb{E}[\text{ Number of occurrences of a k-mer}] = \frac{(100 -20)}{100}30 = 24 \  \text{times}}
$$

If we have an error rate of 1%,

$$
Pr(\text{no error}) = (1-\text{error rate})^k = (0.99)^{20} \approx 0.82
$$

Therefore,

$$
\mathbb{E}[\text{ Number of occurrences of a k-mer with no error}] \ = \ Pr(\text{no error})*\mathbb{E}[\text{# of occurrences}] = 0.82*24 =\approx 20
$$

Thus, k-mer of length 20 will occur 20 times on average with no errors out of the 24 times that it may appear. Now consider the case with 1 error:

$$
Pr(\text{1 error}) = (0.01)(0.99)^{19} \approx 0.008
$$

Therefore,

$$
 \mathbb{E}[\text{ Number of occurrences of a k-mer with 1 error}] \ = \ Pr(\text{1 error})*\mathbb{E}[\text{# of occurrences}] = 0.008*24 \approx 1
$$

Therefore, approximately 1 out of the 24 k-mer that occurs will have an error. We can therefore easily find the k-mer that rarely appears or in few numbers and discard them as error reads. We can set a threshold on the number of occurrences of a particular k-mer for it to be a valid k-mer.

Now lets consider a higher error rate of 15%. Doing the same calculation we have that:

$$
\text{# of occurrences of error-free k-mers} \approx 1
$$

The k-mer with no errors will appear rarely as well in this case. This means that it is very hard to tell if a k-mer that appears once is an error k-mer or a valid one. We won't be able to set a threshold and pre-filtering breaks down at large error rates.  
	- We can prevent breakdowns by setting smaller k values (using smaller k-mers) but it may not be practical because of the huge size of our k-mer dataset.  
	- Therefore with higher error rate, people usually do not use k-mer based algorithms and instead will choose to use read-overlap graph algorithms which do not have this problem.

## <a id='alignment'></a>Alignment

In past lectures we have talked about assembling the genome from reads. However, in order to assemble them most of our algorithm requires us to merge two reads by aligning them with parts that overlap. We will now discuss how we overlap two reads and merge them together.

In order to overlap two reads, we come across the alignment problem. Because of errors, we will consider an algorithm that does an approximate alignment to overlap the reads.

What are the uses of alignment? Why would we want to have an algorithm to solve the alignment problem?
	1. it can be used to overlap reads for a *de novo* assembly.
	2. it can be used to compare reads with a reference genome to see which region the read belongs to. In turn we can find new variations and differences in the reads from the reference genome.

### <a id='subproblem'></a> Edit Distance & Dynamic Programming

To solve the alignment problem, we want to find the best way to align two strings by taking into account the three different types of errors we discussed earlier. Consider two strings, $x$ and $y$:

$$
x = \text{GCGTATGTGGCTAACGC} \\
y = \text{GCTATGCGGCTATACGC}
$$

In order to measure how much these two strings overlap and to try to align them, we will consider the **edit distance** of the two strings.

Edit distance is defined as the the minimum # of insertion, deletion and substitutions necessary to get from string x to string y.

Using the x and y given, we will denote a deletion by a **-**, and a substitution by a bold letter.

<p style="text-align: center;">  
x = <tt> GCGTATG<span style="color:red">T</span>GGCTA<span style="color:red">-</span>ACGC</tt> <br>
y = <tt> GC<span style="color:red">-</span>TATG<span style="color:red">C</span>GGCTATACGC</tt>
</p>

We see from our example that we have two insertion/deletion at the 3rd and 14th letter of the sequence, and a substitution at the 8th letter. Therefore, there are 3 edits = and edit distance of 3.


One could compute edit distance between two strings by computing all permutations of the string and compare. However, this will definitely take exponential time in terms of the length of the string and is not  efficient. An efficient solution would be to use __Dynamic Programming__.

An algorithm to find the edit distance would require us to break down the problem into subproblems. Using solutions from the subproblems we can then build a working solution for the whole problem. We will discuss this algorithm next lecture.
