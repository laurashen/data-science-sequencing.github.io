---
layout: page
mathjax: true
permalink: /Win2018/lectures/lecture10/
---
## Lecture 10: Haplotype Phasing

Thursday 8 February 2018

-----------------

## Topics

1. 	<a href='#SNP'>SNP Calling</a>  
    - <a href='#diploid'>SNP Calling in diploid organisms</a>  
1. 	<a href='#phasing'>Haplotype Assembly</a>  
	  - <a href='#community'>Community recovery problem</a>

###  <a id='SNP'></a>SNP calling
**Single Nucleotide Polymorphisms** (SNPs) are mutations that occur over evolution. A simplistic view of these would be to think of them as around 100,000 positions where variation occurs in the human genome.

**SNP calling** is a technique that is used to identify SNPs in the sample genome. The main computational approach taken here is given reads from a genome,
we first map the reads to various positions on the genome using alignment
methods discussed in the last lecture. Some reads map into locations with
no variation with respect to the reference.

At a high level, the pipeline can be seen as follows:
<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture10/blocks.png" width="99%">
	<div class="figcaption">The haplotype phasing pipeline.</div>
</div>

The main statistical problem is to be able to distinguish errors in reads from truly different SNPs in the underlying genome. In practice, we usually have very high coverage; every position in the genome is covered by many reads. Thus we can run a simple statistical test to see if a read disagreeing with the reference is due to errors or due to the individual's genome actually being different.


#### <a id='diploid'></a>SNP calling in diploid organisms

If an organism had only one copy of every chromosome, the SNP calling problem
would reduce to just taking the majority of the base of reads aligned to
every position. Humans, however, are **diploid**. They have two copies of every chromosome: one maternal
and the other paternal.

During sequencing, we fragment the DNA material, so the sequencer cannot
distinguish between the paternal and maternal DNA. When we map these reads to the
locations, we do not have as clean a picture. We represent variation in each position as a 1 and no variation as a 0.  In each position, we have 4 possibilities:

1. 00 (no variation)
2. 11 (both copies are different from the reference)  
3. 10 or 01 (one of the copies is the reference and the other is the variation)  

We note that we assume here that there is only one variant at each position.
This is a reasonable approximation to reality.

Positions with 00 and 11 are called **homozygous** positions. Positions
with 10 or 01 are called **heterozygous** positions. We note that the
reference genome is neither the paternal nor the maternal genome but
the genome of an un-related human (or more precisely the mixture of genomes
of a few individuals). An individual's **haplotype** is the set of variations in that individual's chromosomes. We note that as any two human haplotypes are 99.9% similar, the mapping problem can be solved quite easily.

After mapping the reads, we gain information about the likelihood of four above possibilities. For SNP calling, we can measure (estimate) the number of variations at each position: 0, 1, or 2. Note that we cannot tell between the two heterozygous cases (01 vs 10). Distinguishing these two is important because many diseases are **multiallelic**. That is, multiple positions determine a disease. Also the diseases depend upon the proteins produced in an individual. This depends upon the SNPs being present on the same chromosome rather than being present on different chromosomes.


### <a id='phasing'></a> Haplotype Assembly

**Haplotype phasing** is the problem of inferring information about an individual's haplotype. To solve this problem, there are many  methods.

First, we focus on a class of methods focused on getting better data (rather than better statistical methods). Let’s say we have two variants, SNP1 and SNP2.
The distance between the two are on the order of $$\approx$$ 1000 bp (i.e. they’re pretty far apart). To do haplotype phasing, one needs some information that allows us to connect the two SNPs so that one can infer which variants lie on the same chromosome. If you do not have a single read that spans the two positions, then you don’t have any information about the connection between the two SNPs.

Illumina reads are typically 100-200bp long and are therefore too short; however, there does exist multiple technologies that provide this long-range
information:  

- **Mate-pair reads** - With a special library
preparation step, one can get pairs of reads that we know come from the
same chromosome but are far apart. They can be ~1000 bp apart, and we know the distribution of the separation.

- **Read clouds** - Pioneered
by [10x Genomics](http://www.10xgenomics.com/), this relatively new library preparation technique uses barcodes to label
reads and is designed such that reads with the same barcode come from the
same chromosome. The set of reads with the same barcode is called a _read cloud_.
Each read cloud consists of a few hundred reads that are from a length 50k-100k segment of the genome.

- **Long reads** - Discussed in previous lectures.

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture10/matepair.png" width="70%">
	<div class="figcaption">Mate-pair reads.</div>
</div>

For both of these technologies, the separation between linked reads
is a random variable, but one can compute it by aligning the reads to a reference.

In practice, the main software used for haplotype assembly
are [HapCompass](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3375639/)
and [HapCut](http://bioinformatics.oxfordjournals.org/content/24/16/i153.short).
HapCut poses haplotype assembly as a max-cut problem and solves it using heuristics. HapCompass on the other hand constructs a graph where each node is a SNP and each edge indicates that two SNP values are seen in the same read. HapCompass then solves the haplotype assembly problem by finding max-weight spanning trees on the graph. For read clouds, a 10x Genomics's  [loupe](http://loupe.10xgenomics.com/loupe/) software
[visualizes](http://loupe.10xgenomics.com/loupe/view/TkExMjg3OF9XR1MubG91cGU=/summary) read clouds from [NA12878](https://catalog.coriell.org/0/Sections/Search/Sample_Detail.aspx?Ref=GM12878), a human cell line with a genome frequently used as a reference in computational experiments.

#### <a id='comp'></a> The Computational Problem

Here we consider a simplified version of the haplotype assembly problem. We assume we have the locations of the heterozygous positions in the genome, and we only consider reads linking these positions.

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture10/chr.png" width="70%">
	<div class="figcaption">The haplotype phasing example with some noisy SNP information captured in mate-pair reads.</div>
</div>

The above figure shows two chromosomes with heterozygote SNPs; we want to
identify which variations occurred on the same chromosome. Note that errors can occur in the mate-pair reads, as shown above, resulting in erroneous SNP calls. We will show that the haplotype phasing problem can be cast as a _community recovery_ problem.

<!-- Let $$L_i$$ = parity between $$i^{\text{th}}$$ and $$(i+1)^{\text{th}}$$ SNP. For example, in the above figure $$L_1 = 1, L_2 = 1, \text{ and }L_3 = 0.$$

The observed parities obtained between the two SNPs covered by the reads are given by
$$Y_A = 1, Y_B = 1, \text{ and } Y_C = 1.$$ Because the observations are noisy, one can model each SNP observation as the true parity
being flipped with some probability $$\epsilon $$ independent of all other SNP observations. This leads to the following model:

$$Y_A = L_2 \oplus Z_A$$  
$$Y_B = L_1 \oplus Z_B$$  
$$Y_C = L_2 \oplus L_3 \oplus Z_C,$$  


where $$Z_A, Z_B, Z_C \sim \text{Bernoulli}(\epsilon(1-\epsilon)) \ \ \ $$
model the noise in the observed parities.

Our goal is to infer the sequence of $$L_i$$, allowing us to identify
which variations occurred on the same chromosome. Note that we still cannot tell which variations are on the maternal chromosome and
which are on the paternal chromosome.


#### <a id='conv'></a> Convolutional Code and Viterbi Algorithm

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture10/logic.png" width="40%">
	<div class="figcaption">Convolutional codes used with haplotype assembly.</div>
</div>
The transfromation from $$L$$'s to $$Y$$'s can be viewed as a
[convolutional code](https://en.wikipedia.org/wiki/Convolutional_code)
and the maximum-likelihood decoder is called the
[**Viterbi algorithm**](https://en.wikipedia.org/wiki/Viterbi_algorithm).

The runtime of the Viterbi algorithm is linear in the number of SNPs
in the genome (around 100,000 in human genome) and proportional to $$2^{\text{mate-pair separation range}}$$.
The fact that the runtime is exponentially increasing with the mate-pair
separation range can be a problem when the range is long. Convolutional codes with constraint lengths (mate-pair separation
range) in the tens are routinely decoded in communication using
various schemes that trim the state-space. -->


#### <a id ='community'><a/>Community recovery problem

In the _community recovery_ problem, we are given a graph with a bunch of nodes, and each node belongs to one of multiple clusters as shown in the figure below. The recovery problem is to recover the clusters (colors) based on the edge information between nodes. This problem is commonly seen in social networks where nodes can be blog posts, for example, and we want to identify which posts are from Republicans and which are from Democrats. The edges describe how the posts link to one another.

<div class="fig figcenter fighighlight">
  <img src="http://allthingsgraphed.com/public/images/political-blogs-2004/left-right.png" width="80%">
	<div class="figcaption">A community detection example based on political blogs (Democratic vs. Republican).</div>
</div>

Returning to our haplotype phasing problem, we can define each index as a node in a graph. This results in four nodes corresponding to the 4 heterozygous SNP locations. We can also define two communities $$A$$ and $$B$$ for our graph:

$$
A = \begin{bmatrix} 0 \\ 1 \end{bmatrix} \ \ \ \ \ \ \
B = \begin{bmatrix} 1 \\ 0 \end{bmatrix}
$$

SNPs 1 and 2 belong to community $$A$$, and SNPs 3 and 4 belong to community $$B$$. In practice, we may have 100,000 nodes with half in each community.A mate-pair read linking two nodes results in an edge between those two nodes, and the weight of the edge depends on the parity of the read. We will show that recovering the communities is equivalent to solving the haplotype phasing problem. The partition will give us all the information except for 1 bit: which SNPs correspond to the maternal chromosome.

A necessary condition for successful haplotype assembly is _connectedness_; each node has a path to each other node. If there are no errors on the reads, we can recover the communities using a greedy algorithm. We can start at an arbitrary node, assign it to community $$A$$, then follow an edge leaving the node. If the edge has weight 1 (indicating that the two nodes are identical), then we assign the next node to community $$A$$ as well. Otherwise, we assign it to community $$B$$. Note that we can only resolve the nodes into two communities. Without additional information, we cannot know which community corresponds to which chromosome.

In the presence of noise, we would need more reads in order to guarantee connectedness. If we have $$n$$ reads, we would need $$n \log n$$ reads. One approach for finding the communities would be to enumerate all possible pairs of communities. We would then simply choose the solution that results in the maximum likelihood given the data. This approach has close ties to the [_MAXCUT_](https://en.wikipedia.org/wiki/Maximum_cut) problem, which is NP-hard.

Alternatively, we will first assume a uniform linking model; reads are equally likely to be between any pair of SNPs. For our haplotype example, we can construct the adjacency matrix

$$
A =
\begin{bmatrix}
\star & -1 & 0 & 0 \\
-1 & \star & 1 & -1 \\
0 & 1 & \star & 1 \\
0 & -1 & 1 & \star
\end{bmatrix}
$$

where position $$A_{ij} = 1$$ if the SNPs at indices $$i, j$$ are equal. Otherwise, $$A_{ij} = -1 $$. We claim that this matrix captures all the information in the graph, and we can operate with solely this matrix. We will explore this further next lecture.

<!-- We will let $$x_i$$ denote the class of node $$i$$ and $$x_i \in \{-1,+1\}$$. Let $$Y_{ij}$$ represent the edge data between nodes $$i$$ and $$j$$ where $$Y_{ij} = 1$$ if $$x_i = x_j$$ and $$-1$$ otherwise. We will set $$Y_{ij} = 0$$ if there is no linking reads between node i and node j. If there is no noise, then $$Y = 1$$ corresponds to an edge where the two nodes are in the same community and vice versa. $$Y = -1$$ would indicate the two nodes being in different communities. The figure below illustrates the notation introduced so far.

<div class="fig figcenter fighighlight">
  <img src="/Spr2016/assets/lecture13/Figure2.png" width="50%">
	<div class="figcaption"> The community detection setup for the haplotype phasing problem..</div>
</div>

When working with real read data, we can think of each measurement (mate-pair read) as a noisy edge on the graph telling us if two nodes are linked. We introduce a random variable $$Z_{ij}$$ to represent the noise in each edge. We assume that all $$Z_{ij}$$ are i.i.d. In summary,

$$
\begin{align}
x_i & \in\ \{-1, 1 \} \\
Z_{ij} & = \left\{ \begin{array}[cc]\\
1  & \text{w.p. } 1- \epsilon\\
-1 & \text{w.p. } \epsilon
\end{array}\right. \\
Y_{ij} & = x_i x_j Z_{ij}
\end{align}
$$

$$Y_{ij}$$ essentially tells us if two nodes are in the same community with an $$\epsilon$$ probability of error. Exploiting vector notation, we further define:

$$
\mathbf{x} = \begin{bmatrix} x_1 \\ \vdots \\ x_n \end{bmatrix} \in \mathbb{R}^n \\
\mathbf{Y} = \left[ Y_{ij} \right] \in \mathbb{R}^{n\times n}
$$

#### <a id='ML'></a>Maximum likelihood
To solve the community recovery problem, we will use maximum likelihood to infer the $$x_i$$'s':

$$
\begin{align}
\hat{\mathbf{x}} & = \text{argmax}_{\mathbf{x}} P\left(\mathbf{Y}|\mathbf{x} \right) \\
 & = \text{argmax}_{\mathbf{x}} \prod_{i,j \in E} P\left(Y_{ij} | x_ix_j \right) \\
\end{align} \\
P\left(Y_{ij} | x_ix_j \right) = \left\{ \begin{array}[cc]\\
1 - \epsilon  & \text{if } Y_{ij} = x_ix_j \\
\epsilon      & \text{if } Y_{ij} \neq x_ix_j\epsilon
\end{array}\right.
$$

where $$E$$ indicates the set of edges in the observed data. This can be further simplified by using the log likelihood:

$$
\hat{\mathbf{x}} = \text{argmax}_{\mathbf{x}} \sum_{i,j \in E} \log\left(P\left(Y_{ij}|x_ix_j \right)\right)
$$

where each log term can be expressed as

$$
\begin{align}
\log\left(P\left(Y_{ij}|x_ix_j \right)\right) & = \left\{ \begin{array}[cc]\\
\log\left(1 - \epsilon\right)  & \text{if } Y_{ij} = x_ix_j \\
\log\left(\epsilon\right)      & \text{if } Y_{ij} \neq x_ix_j\epsilon
\end{array}\right.\\
& = Y_{ij}x_ix_j\left(\frac{\log(1-\epsilon) - log(\epsilon)}{2}\right) + \frac{\log(1-\epsilon) + \log(\epsilon)}{2}
\end{align}
$$

Since $$\epsilon$$ is a constant, we can further simplify the ML decoder to

$$
\begin{align}
\hat{\mathbf{x}} & = \text{argmax}_{\mathbf{x}} \sum_{i,j \in E} Y_{ij}x_ix_j\\
& = \text{argmax}_{\mathbf{x}} \sum_{i,j} Y_{ij}x_ix_j\\
& = \text{argmax}_{\mathbf{x}} \ \mathbf{x}^T \mathbf{Y} \mathbf{x}
\end{align}
$$

Notice that we threw in the edges that are not in the observed set of edges. We can set $$Y_{ij} = 0$$ for these cases. Ultimately, we want to compute the maximization using this quadratic form. Brute force maximization of this is quite bad because the number of possible $$\mathbf{x}$$'s is $$O(2^n)$$.

Intuitively, when two nodes are in the same community ($$x_i x_j =1$$) and there is no error ($$Z_{ij} = 1$$), $$Y_{ij}$$ is positive, giving us a positive contribution to our maximization objective. We do not want negative terms. We can decompose the sum in objective into:

$$
\begin{align}
\sum_{i,j} Y_{ij}x_ix_j & = (\text{# of in-cluster $+1$ edges}) \\
& + (\text{# of cross-cluster $-1$ edges}) \\
& - (\text{# of in-cluster $-1$ edges}) \\
& - (\text{# of cross-cluster $+1$ edges}) \\
\end{align}
$$

This is a combinatorial optimization problem. Suppose we are solving a simpler problem where we only have $$-1$$ edges. Then the objective becomes

$$
\begin{align}
\sum_{i,j} Y_{ij}x_ix_j & = (\text{# of cross-cluster $-1$ edges}) - (\text{# of in-cluster $-1$ edges}) \\
& = |E| - (\text{# of cross-edges}) \\
& = 2 - (\text{# of cross-edges}) - |E|
\end{align}
$$

While the number of edges is fixed, the number of cross edges depends on the clustering. Therefore the problem becomes: find a partition of the graph that maximizes the number of cross edges. This is the _max cut_ problem, which is NP hard. If we approach the problem from a general approach, it's NP hard. We will need to exploit some further structure in the problem.

### <a id ='SMSDP'><a/>Spectral method

In order to solve this NP hard combinatorial optimization problem, we can use the spectral method to arrive at an approximate solution. We relax the problem by allowing each $$x_i$$ to be real. We will also constrain $$\|\mathbf{x}\|_2 = n$$.  We can bound the optimization problem as follows:

$$
\begin{align}
& \max_{\mathbf{x}} \sum_{i,j} Y_{ij}x_ix_j \\
= & \max_{x_i, x_j \in \{\pm1\}} \mathbf{x^TYx}\\
\le & \max_{\mathbf{x},||\mathbf{x}||_2 = n} \mathbf{x^TYx} \\
\le & \lambda_{max}n
\end{align}
$$

Because $$Y$$ is a symmetric matrix, its eigenvalues are real and positive. We simply set $$\mathbf{x}$$ to equal the eigenvector corresponding to the largest eigenvalue of $$\mathbf{Y}$$. By taking the sign of each entry in $$\mathbf{x}$$, we get an approximate solution to our original problem (where $$x_i \in \{-1,+1\}$$) with a reasonable $$\mathbf{x}$$. This approach is called the _spectral method_ because we pick $$\mathbf{x}$$ according to the spectrum of $$\mathbf{Y}$$.

#### <a id ='Verify'><a/>Correctness of spectral method

Because we relaxed the original problem, we need to exhibit some evidence that this approach is good. Consider the following random graph: for every pair of points, we draw an edge between them with probability $$p$$. Note that Y is a random matrix because the location of the measurements are random and the errors are random. We want to first check what happens when $$\mathbf{Y}$$ is replaced by its expected value. Intuitively, if this method does not work when $$\mathbf{Y}$$ is deterministic at the mean, then there's not much hope of this method working in general.

$$
\begin{align}
\bar{Y_{ij}} & = E[Y_{ij}] \\
& = (1 - p)\dot\ 0 + p[x_ix_j(1-\epsilon) - x_ix_j\epsilon] \\
& = p(1-2\epsilon)x_ix_j
\end{align}
$$

Therefore

$$
\mathbf{\bar{Y}} = p(1-2\epsilon)\mathbf{xx^T}
$$

$$\mathbf{\bar{Y}}$$ is a rank 1 matrix, and applying the spectral method on this matrix will give us exactly $$\mathbf{x}$$, our ground truth. The hope is that while $$\mathbf{Y}$$ in actuality is random, statistically it's close to its mean $$\mathbf{\bar{Y}}$$. This shows that using the spectral method, we can expect to get a reasonable answer.

The solution obtained for $$\mathbf{\hat{x}}$$ using the spectral method will be correct in a large number of entries. We can clean up the entries a bit by considering the neighbors of each node. We set each node to the majority community amongst its neighbors. Since most of the nodes are correct, this clean-up step improves our solution.

### <a id ='sim'><a/>Simplifying the haploid phasing problem

When dealing with real heterozygous SNPs, the linking information will be constrained to ranges of ~100 kbp (e.g. 10x technologies) while the chromosomes they reside on are each ~100 Mbp. Since the links are localized, unlike a random graph, we can section the chromosome into segments of length $$r$$ and analyze each segment as shown in the figure below. For small values of $$r$$ we can use Viterbi decoding, but for large values we can use the spectral method.

<div class="fig figcenter fighighlight">
  <img src="/Spr2016/assets/lecture13/Figure3.png" width="70%">
	<div class="figcaption">For real chromosomes, we obtained localized information about SNPs.</div>
</div> -->
