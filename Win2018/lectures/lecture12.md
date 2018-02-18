---
layout: page
mathjax: true
permalink: /Win2018/lectures/lecture12/
---
## Lecture 12: RNA-seq - A Counting Problem

Thursday 15 February 2018

_scribed by Logan Spear and edited by the course staff_

-----------------

## Topics

In the previous lecture, we introduced [RNA-seq](https://en.wikipedia.org/wiki/RNA-Seq)
 and the quantification problem. In this lecture, we dive deeper into this problem
-- in the case when we know the RNA transcripts beforehand -- and
examine how we can solve it optimally under some simplicity assumptions.

1.	<a href='#intro'>RNA-Seq quantification</a>
    -	<a href='#naive'>A naive approach</a>
1.	<a href='#improvement'>Improved approach: Iterative estimation refinement</a>
    - <a href='#algo'>General Algorithm</a>
    - <a href='#questions'>Questions</a>

### <a id='intro'></a>RNA-Seq quantification

As discussed in the last lecture, the RNA-seq data consist of multiple reads sampled from the various RNA transcripts in a given tissue (after the reverse transcription of RNA to cDNA).
We assume that these reads are short in comparison to the RNA transcripts.

We also assume that we know the list of all possible RNA transcripts $$t_1,t_2, \dots,t_K$$
beforehand. Every read $$R_i,i=1,2,\dots,N \ \ $$ is mapped (using alignment) to (possibly multiple) transcripts. Our goal is to estimate the abundance of each transcript $$\rho_1, \rho_2,...,\rho_K, \ $$ where $$\rho_k \in [0,1], \ k \in \{1,2, \cdots, K \} \ \ $$ denotes the fraction of $$t_k$$ among all transcripts.

Additionally, we make the following assumptions for the sake of simplicity:  

1. _All transcripts have equal length $$\ell$$._ It is fairly straightforward to extend our analysis to transcripts of unequal length.  
1. _Each read has the same length $$L$$._
1. _Each read can come from at most one location on each transcript._ This is a reasonable assumption, since different exons rarely contain common subsequences.
1. _The reads come from uniformly sampling all the transcripts._
This is a relatively mild assumption we have made before to ease our analysis, even though it is not entirely accurate.  

#### <a id='naive'></a>A naive approach

At the end of the last lecture, we discussed how we can simply count the number of reads that align to each transcript. We consider the following example where we have two transcripts $$t_1, t_2$$ sharing a common exon B:

<div class="fig figcenter fighighlight">
  <img src="/Win2018/assets/lecture12/transcripts_ABBC.png" width="50%">
  <div class="figcaption">Transcripts sharing a common exon.</div>
</div>

We consider two types of reads:
1. _uniquely mapped_ reads (e.g. reads that align to either exon A or exon C)
2. _multiply mapped_ reads (e.g. reads that align to exon B)

The difficulty of the above counting problem lies in the existence of the latter type of read. The simplest strategy for handling these types of reads is to just throw them away and work with only uniquely mapped reads. We see immediately that this approach fails if all the reads for a transcript comes from only exon B.

A less naive approach to deal with these reads would be to split them, i.e. assign a fractional count to each transcript a read maps to. We can split a multimapped read equally among all transcripts it is mapped to. For instance, if a read maps to exon B, then each transcript gets a count of $$\frac{1}{2}$$. Finally, our estimate of the abundance of $$t_k$$ with total count $$N_k$$ is

$$
\hat{\rho}_k=\frac{N_k}{N}
$$

While naive read splitting sounds reasonable, it can fail spectacularly as well. Assume our ground truth is that $$\rho_1=1$$ and $$\rho_2=0$$. As a result, some of our $$N=20$$ reads come from exon A and some come from exon B. Let's assume that half of the reads come form each exon (even though the figure above does not depict the two exons as of equal length).

All the reads coming from exon A map uniquely to $$t_1$$ and thus, they contribute a total of $$\frac{20}{2}=10$$ to the count $$N_1$$ of $$t_1$$. All the $$\frac{20}{2}=10$$ reads coming from exon B map to both transcripts and according to the naive algorithm above, each of them contributes $$\frac{1}{2}$$ to each of the counts $$N_1, N_2.$$ As a result, our estimate is that

$$
\hat{\rho}_1=\frac{10+10*0.5}{20}=0.75,
$$

$$
\hat{\rho}_2=\frac{10*0.5}{20}=0.25,
$$

which is clearly wrong.

### <a id='improvement'></a>Improved approach: Iterative estimation refinement

Since the naive algorithm fails, we need to come up with a better solution. We note that despite the failure, we came closer to the truth (in comparison to a random guess of equal abundances). Is there a way to leverage the information we gained? For example, what if we were to use our newly obtained estimate of abundances to re-split the multiply-mapped reads with weights proportional to the relative abundances of the two transcripts? In the above example, this would mean that

$$
\hat{\rho}_1^{(2)}=\frac{10+10 \times 0.75}{20}=0.875,
$$

$$
\hat{\rho}_2^{(2)}=\frac{10+10 \times 0.25}{20}=0.125,
$$

which is closer to the truth.

But now, we can simply repeat the process using the updated estimate of the abundances. It is easy to see that at each step, $$\hat{\rho}_2^{(m)}$$ will be halved and hence, this process converges to the ground truth at an exponential rate.

This seems promising. So, let's formulate this algorithm more generally.

#### <a id='algo'></a>General Algorithm


1. Since we know nothing about the abundances to begin with, our initial estimate is uniform.  That is  
\\[\hat{\rho}_k^{(0)}=\frac{1}{K},k=1,2,...,K\\]


2. For step $$m=1,2,...$$ repeat:  
- For $$i=1,2,..,N$$   let read $$R_i$$ map to to a set $$S_i$$ of transcripts, denoted by $$R_i \to S_i$$.
Then, split $$R_i$$ into fractional counts for each transcript $$k \in S_i$$, equal to the relative abundances of the transcripts in $$S_i$$,
as follows:  
$$
f_{ik}^{(m)}=\begin{cases}
\frac{\rho_k^{(m)}}{\sum_{j \in S_i}{\rho_j^{(m)}}} &\text{if }k \in S_i \\
0 & \text{otherwise}  \end{cases}
$$  
- The updated estimate is, obviously,  
$$
\hat{\rho}_k^{(m+1)}=\frac{1}{N}\sum_{i=1}^{N}{f_{ik}^{(m)}}
$$

{% include_relative Logan_code.html  %}

#### <a id='questions'></a>Questions

The natural questions that arise now are

1. whether this algorithm converges in general and
2. even if it does, does it converge to the Maximum Likelihood (ML) estimate $$\mathbf{\hat{\rho}^{ML}}$$?

The former is crucial, since a non-converging process is, basically, useless. The latter examines the performance of the algorithm in terms of estimation accuracy. Given that we have a finite amount of data, we cannot guarantee that the ground truth is recovered. Our best hope is to find $$\mathbf{\hat{\rho}^{ML}}$$.

This leads us to our next few topics. What is $$\mathbf{\hat{\rho}^{ML}}$$ and how can we compute it efficiently?
