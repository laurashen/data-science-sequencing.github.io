---
layout: page
mathjax: true
permalink: /lectures/lecture15/
---
## Lecture 15: RNA-seq - Quantification and the EM algorithm

Wednesday, May 18, 2016

_Scribed by Paraskevas Deligiannis and revised by the course staff_



## Topics

In the [previous lecture](http://data-science-sequencing.github.io/lectures/lecture14/), we introduced [RNA-seq](https://en.wikipedia.org/wiki/RNA-Seq) and the quantification problem. In this lecture, we  delve deeper into this problem -- in the case when we know the RNA transcripts beforehand -- and examine how to solve it optimally under some simplicity assumptions.

1.	<a href='#intro'>The RNA quantification problem & our assumptions</a>
2.	<a href='#naive'>Naive split reads</a>
    - <a href='#shortcomings'>Shortcomings of naive splitting</a>
3.	<a href='#improvement'>Improved approach: Iterative estimation refinement</a>
    - <a href='#idea'>Basic Idea</a>
    - <a href='#algo'>General Algorithm</a>
    - <a href='#questions'>Questions</a>
4.	<a href='#ml'>Maximum Likelihood estimation</a>
    - <a href='#convex'>Convexity</a>
    - <a href='#unique'>Special case: Uniquely-mapped reads</a>
5.	<a href='#em'>Expectation-Maximization (EM) algorithm</a>
    - <a href='#key'>Key idea</a>
    - <a href='#optimality'>Convergence & Optimality</a>
    - <a href='#steps'>Iterative steps</a>
    - <a href='#application'>Application to our problem</a>
    - <a href='#hard'>"Hard" EM</a>

## <a id='intro'></a>The RNA quantification problem & our assumptions

As discussed in the last lecture, the RNA-seq data consist of multiple reads sampled from the various
RNA transcripts in a given tissue (after the reverse transcription of RNA to cDNA).
We assume that these reads are short in comparison to the RNA transcripts and have equal length L.

We, also, assume that we know the list of all possible RNA transcripts $$t_1,t_2,...,t_K$$
beforehand. Every read $$R_i,i=1,2,...,N \ \ $$ is mapped (using alignment)
to  (possibly multiple) transcripts. Our goal is to estimate
abundance of each transcript $$\rho_1, \rho_2,...,\rho_K, \ $$ where
$$\rho_k \in [0,1], \ k \in \{1,2, \cdots, K \} \ \ $$ denotes the fraction of
$$t_k$$ among all transcripts.

Additionally, we make the following assumptions for the sake of simplicity:  
- _All transcripts have equal length $$\ell$$._ It is fairly straightforward to extend our analysis to transcripts of unequal length.  
- _The reads come from uniformly sampling all the transcripts._
A relatively mild assumption we have made before to ease our analysis, even though it is not entirely accurate.  
 - _Each read can come from at most one location on each transcript._ This is a reasonable assumption, since different exons rarely contain common subsequences.

## <a id='naive'></a>Naive split reads

As discussed in the previous lecture, the difficulty of the above counting problem lies in the existence of multiply-mapped reads. This occurs due to the fact that different transcripts can contain the same exons.

One approach to deal with these reads would be to split them, i.e. assign a fractional count to each transcript they map to. The simplest way to do this is by splitting the read equally among all transcripts it is mapped to. For instance, if a read maps to 5 transcripts, then each of them gets a count of $$\frac{1}{5}$$.

Finally, our estimate of the abundance of $$t_k$$ with total count $$N_k$$ is

$$
\hat{\rho}_k=\frac{N_k}{N}
$$

### <a id='shortcomings'></a>Shortcomings of naive splitting
This sounds reasonable, but it can fail spectacularly, as illustrated by the following example.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture15/transcripts_ABBC.png" width="50%">
  <div class="figcaption">Transcripts sharing a common exon </div>
</div>

Here, we have two transcripts $$t_1, t_2$$ sharing a common exon B and our ground truth is that $$\rho_1=1$$ and $$\rho_2=0$$.
As a result, some of our $$N=20$$ reads come from exon A and some come from exon B.
Let's assume that half of the reads come form each exon (even though the figure above does not depict the two exons as of equal length).

All the reads coming from exon A map uniquely to $$t_1$$ and thus, they contribute a total of $$\frac{20}{2}=10$$ to the count $$N_1$$ of $$t_1$$.
All the $$\frac{20}{2}=10$$ reads coming from exon B map to both transcripts and according to the naive
algorithm above, each of them contributes $$\frac{1}{2}$$ to each of the counts $$N_1, N_2.$$ As a result, our estimate is that

$$
\hat{\rho}_1=\frac{10+10*0.5}{20}=0.75,
$$

$$
\hat{\rho}_2=\frac{10*0.5}{20}=0.25,
$$

which is clearly wrong.

## <a id='improvement'></a>Improved approach: Iterative estimation refinement

Since the naive algorithm fails, we need to come up with a better solution. We note that despite the failure, we came closer to the truth (in comparison to a random guess of equal abundances). Is there a way to leverage the information we gained?

### <a id='idea'></a>Basic Idea

What if we were to use our newly obtained estimate of abundances to re-split the multiply-mapped reads with weights proportional to the relative abundances of the two transcripts? In our example, this would mean that

$$
\hat{\rho}_1^{(2)}=\frac{10+10 \times 0.75}{20}=0.875,
$$

$$
\hat{\rho}_2^{(2)}=\frac{10+10 \times 0.25}{20}=0.125,
$$

which is closer to the truth.

But now, we can simply repeat the process using the updated estimate of the abundances. It is easy to see that at each step, $$\hat{\rho}_2^{(m)}$$ will be halved and hence, this process converges to the ground truth at an exponential rate.

This seems promising. So, let's formulate this algorithm more generally.

### <a id='algo'></a>General Algorithm


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


### <a id='questions'></a>Questions

The natural questions that arise now are
1. whether this algorithm converges in general and
2. even if it does, does it converge to the Maximum Likelihood (ML) estimate $$\mathbf{\hat{\rho}^{ML}}$$?

The former is crucial, since a non-converging process is, basically, useless. The latter examines the performance of the algorithm in terms of estimation accuracy. Given that we have a finite amount of data, we cannot guarantee that the ground truth is recovered. Our best hope is to find $$\mathbf{\hat{\rho}^{ML}}$$.

This leads us to our next topics. What is $$\mathbf{\hat{\rho}^{ML}}$$ and how can we compute it efficiently?

## <a id='ml'></a>Maximum Likelihood estimation

Let $$\mathbf{\rho}=[\rho_1\ \rho_2\ ...\ \rho_K]^T \ $$ be the vector of transcript abundances.
The distribution of the reads depends on $$\mathbf{\rho}$$.
Since the reads are sampled independently, we have that

$$
Pr(R_1=r_1,R_2=r_2,...,R_N=r_N;\mathbf{\rho}) = \prod_{i=1}^N{Pr(R_i=r_i;\mathbf{\rho})}.
$$

We note that $$R_i=r_i$$ if and only if the read $$R_i$$ maps to a transcript
$$t_k$$ that contains the sequence $$r_i$$ and $$R_i$$ starts from the same position as
$$r_i$$. (Recall our assumption that
  _each read can come from at most one location on each transcript_.)
Therefore, the probability

$$
\begin{equation}
\begin{split}
Pr(R_i=r_i;\mathbf{\rho}) = \sum_{k=1}^K&[{Pr(R_i\ maps\ to\ t_k;\mathbf{\rho}) \times Pr(r_i\ belongs\ to\ t_k) \times ...}  \\
&...Pr(R_i\ starts\ at\ the\ position\ where\ r_i\ starts\ in\ t_k)].
\end{split}
\end{equation}
$$

The reads are sampled uniformly, so $$Pr(R_i\ maps\ to\ t_k;\mathbf{\rho})=\rho_k$$.
Also, each transcript $$t_k$$ has length $$l$$ and each read of length L coming from $$t_k$$
has an equal chance of starting at each of the possible $$l-L+1$$
positions, hence

$$
Pr(R_i\ starts\ at\ the\ position\ where\ r_i\ starts\ in\ t_k)=\frac{1}{l-L+1}.
$$

Finally, let

$$
y_{ik}=\left\{ \begin{array}[cc]\\
1 &\text{if }r_i \in t_k\\
0 & \text{otherwise.}  \end{array}\right.
$$

As a result,

$$
Pr(R_i=r_i;\mathbf{\rho}) = \sum_{k=1}^K{\frac{y_{ik}}{l-L+1}\rho_k},
$$

which means that

$$
\begin{equation}
\begin{split}
\log{Pr(R_1=r_1,R_2=r_2,...,R_N=r_N;\mathbf{\rho})} &= \sum_{i=1}^N{\log{\left(\sum_{k=1}^K{\frac{y_{ik}}{l-L+1}\rho_k}\right)}} \\
  &= \sum_{i=1}^N{\log{\left(\sum_{k=1}^K{y_{ik}\rho_k}\right)}}-N\log{(l-L+1)}.
\end{split}
\end{equation}
$$

Maximizing the likelihood function is equivalent to maximizing the log-likelihood
and since, $$-N\log{(l-L+1)}$$ is a constant, the ML estimation for $$k=1,...,K$$ is

$$
\DeclareMathOperator*{\argmax}{arg\!\max}
\hat{\rho}_{k}^{ML}=\argmax_{\rho_k \ge 0\ :\ \sum_{k=1}^K{\rho_k}=1}{\left(\sum_{i=1}^N{\log \left( \sum_{k=1}^K{y_{ik}\rho_k} \right)}\right)}.
$$

If we define the matrix $$Y \in \{0,1\}^{N \times K}$$ with elements $$y_{ik}$$, then

$$
\mathbf{\hat{\rho}^{ML}}=\argmax_{\mathbf{\rho} \succeq 0\ :\ \|\mathbf{\rho}\|_1=1} {\sum_{i=1}^N{\log{(Y\mathbf{\rho})}}}.
$$

Along each row i of matrix Y the positions with value 1 represent the transcripts to which $$R_i$$ maps. Along each column k of Y, the positions with value 1 represent the reads that map to $$t_k$$.

As we can see, the effect of the data (reads) on the ML estimate can be summarized by matrix Y, or equivalently, its entries $$y_{ik}$$. Therefore, Y is a [_sufficient statistic_](https://en.wikipedia.org/wiki/Sufficient_statistic) for this ML inference problem.

### <a id='convex'></a>Convexity

The above maximization problem is a convex optimization problem, which is desired, since convex problems are well studied and there are tools to solve them efficiently.

The convexity arises from the combination of the following factors:  

 - it involves the _maximization of a concave objective_ function, as  

     - $$\sum_{k=1}^K{y_{ik}\rho_k}$$ is an affine function of $$\mathbf{\rho}$$  

     - $$\log(\cdot)$$ is concave  

     - the composition of a concave with an affine function is concave  

     - the sum of concave functions is concave  

 - both $$\rho_k \ge 0$$ and $$\sum_{k=1}^K{\rho_k}=1$$ are _linear constraints_

### <a id='unique'></a>Special case: Uniquely-mapped reads

Let's consider the special case when there are no multiply-mapped reads, i.e. every read maps to at  most one transcript, or equivalently, each row of matrix Y has at most one element with value 1. If we denote by $$N_k$$ the number of reads that map to transcript $$t_k$$, then the above maximization problem becomes

$$
\hat{\rho}_{k}^{ML\ unique}=\argmax_{\rho_k \ge 0\ :\ \sum_{k=1}^K{\rho_k}=1}{(\sum_{k=1}^K{N_k\log{\rho_k}})}.
$$

This problem is easy to solve by equating to 0 the gradient of the objective function w.r.t $$\mathbf{\rho}$$ and using [Lagrange multipliers](https://en.wikipedia.org/wiki/Lagrange_multiplier). The result is obvious and reassuring:

$$
\hat{\rho}_{k}^{ML\ unique}=\frac{N_k}{\sum_{k=1}^K{N_k}}
$$

After all, we knew that the naive approach with split reads works when all reads are uniquely mapped. Note that when all reads map to exactly one transcript, $$\sum_{k=1}^K{N_k}=N$$.

## <a id='em'></a>Expectation-Maximization (EM) algorithm

The [EM algorithm](https://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm) was thoroughly described in a 1977 [article](https://www.jstor.org/stable/2984875) written by  [Arthur Dempster](https://en.wikipedia.org/wiki/Arthur_P._Dempster), [Nan Laird](https://en.wikipedia.org/wiki/Nan_Laird), and [Donald Rubin](https://en.wikipedia.org/wiki/Donald_Rubin). It provides an iterative method to compute -- locally optimal -- ML parameters of a statistical model. If $$\mathbf{\theta}$$ denotes the unknown parameters to be estimated (in our case, $$\mathbf{\rho}$$) and $$\mathbf{x}$$ are the observed variables (data, in our case, the reads), then the EM algorithm computes

$$
\argmax_{\mathbf{\theta}}{\ Pr(\mathbf{x};\mathbf{\theta})}.
$$

### <a id='key'></a>Key idea

The basic observation is that in many cases of statistical inference, the problem would become significantly easier, or even trivial, if we knew some unobserved _hidden_ variable(s) $Z$. For instance, in our case, if we somehow knew for every read which transcript it came from, then our problem would reduce to the simple problem with uniquely mapped reads. This information can be represented by a matrix $$Z$$ such that

$$
Z_{ik}=\left\{ \begin{array}[cc]\\
1 &\text{if }R_i \text{ comes from } t_k\\
0 & \text{otherwise.}  \end{array}\right.
$$

The idea behind EM is to iteratively try to use $$\mathbf{x}$$ and the current estimate $$\mathbf{\hat{\theta}}$$ to
compute the posterior distribution : $$p(Z \mid \mathbf{x} ,\mathbf{\hat{\theta}}) $$.
Then we  update our estimate $$\mathbf{\hat{\theta}}$$ to maximize the expected
value of the likelihood $$p(\mathbf{x},Z \mid \mathbf{\theta})$$ w.r.t. $$p(Z\mid\mathbf{x};\mathbf{\hat{\theta}})$$ and so on:

$$
\mathbf{\hat{\theta}^{(0)}} \to p(Z|\mathbf{x};\mathbf{\hat{\theta}}^{(0)}),\\
\max_{\mathbf{\theta}}\mathbb{E}[\log{p(\mathbf{x},Z|\mathbf{\theta})}] \to \mathbf{\hat{\theta}^{(1)}},\\ ...
$$

### <a id='optimality'></a>Convergence & Optimality

It is proven that the EM algorithm  _always_ improves the likelihood $$Pr(\mathbf{x};\mathbf{\hat{\theta}})$$ at every iteration. Since $$Pr(\mathbf{x};\mathbf{\theta})$$ is bounded above by 1, this means that the EM algorithm converges to a local maximum.

However, we saw from our ML analysis in a previous section that the ML optimization problem is concave. This means that there is only one local maximum, the global one. Thus, the EM algorithm is guaranteed to find the optimal ML estimate.

### <a id='steps'></a>Iterative steps

Let's formally describe the EM algorithm. It, basically, consists of two successive steps, the expectation step (E step) and the maximization step (M step), after which it is named. These steps are repeated until the algorithm converges.

For iteration $$m = 0,1,2,...$$  

1. __E step:__ Compute the expected value of the log-likelihood function , w.r.t the conditional distribution of $$Z|\mathbf{x}$$ using the current estimate of the unknown parameters $$\mathbf{\hat{\theta}^{(m)}}$$:  
$$
J(\mathbf{\theta};\mathbf{\hat{\theta}^{(m)}}) = \mathbb{E}_{Z|\mathbf{x};\mathbf{\hat{\theta}^{(m)}}}[\log{p(\mathbf{x},Z|\mathbf{\theta})}]
$$  

2. __M step:__ Find the updated estimate $$\mathbf{\hat{\theta}}$$ that maximizes $$J$$:  
$$
\mathbf{\hat{\theta}^{(m+1)}} = \argmax_{\mathbf{\theta}}{J(\mathbf{\theta};\mathbf{\hat{\theta}^{(m)}})}
$$

### <a id='application'></a>Application to our problem

In our case, it is easy to see that the probability that a read $$R_i \to S_i$$ comes from the transcript $$t_k$$ is proportional to the relative abundance of $$t_k$$ in $$S_i$$. Namely, given our reads $$\mathbf{R}$$ and our current estimate $$\mathbf{\rho}^{(m)}$$,

$$
Pr(Z_{ik}=1|\mathbf{R},\mathbf{\rho}^{(m)}) = f_{ik}^{(m)}.
$$

We have that  

$$
\begin{split}
p(\mathbf{x},Z|\mathbf{\rho}) &= \sum_{i=1}^N{\log{(\sum_{k=1}^K{Z_{ik}\rho_k}})} \\
  &= \sum_{k=1}^K{(\sum_{i=1}^N{Z_{ik})\log{\rho_k}}} \\
  &= \sum_{k=1}^K{N_k\log{\rho_k}},
\end{split}
$$  

where in the first step, we note that, since $$Z$$ represents the ground truth, similarly to the case with uniquely mapped reads, there is at most one non-zero term in the sum $$\sum_{k=1}^K{Z_{ik}\rho_k}$$.

Consequently,  

$$
\begin{align}
\mathbf{\hat{\rho}^{(m+1)}}
&= \argmax_{\mathbf{\rho}}{J(\mathbf{\rho};\mathbf{\hat{\rho}^{(m)}})}, \\
&= \argmax_{\mathbf{\rho}}{\mathbb{E}_{Z|\mathbf{R};\mathbf{\hat{\rho}^{(m)}}}[\log{p(\mathbf{R},Z|\mathbf{\rho})}]},\\
&= \argmax_{\mathbf{\rho}}{\sum_{k=1}^K{(\sum_{i=1}^N{f_{ik}^{(m)})\log{\rho_k}}}} \\
&= \frac{1}{N}\sum_{i=1}^N{f_{ik}^{(m)}},
\end{align}
$$  


where we have omitted the linear constraints on $$\mathbf{\rho}$$ for simplicity. One can verify that if we define $$\hat{N}_k = \sum_{i=1}^N{f_{ik}^{(m)}}$$, the above results follow readily from our analysis for the case of uniquely mapped reads. This is, after all, the reason why we use the _hidden_ variable $$Z$$.

### <a id='hard'></a>_Hard_ EM

The EM algorithm described above is a type of _soft_ EM in the sense that at each iteration,
it calculates and uses only an estimate of the _distribution_ of
$$Z$$ given $$\mathbf{x};\mathbf{\theta}$$.


In contrast, a _hard_ EM algorithm would compute an estimate
$$\hat{Z}$$ of the _values_ of $$Z$$ and then use it to
assign each read $$R_i \to S_i$$ to the transcript $$t_k \in S_i$$
that is most abundant according to the current estimate $$\mathbf{\hat{\rho}_k}$$.
The _hard_ algorithm, which is, also, described in the
[Wikipedia article](https://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm#Description),
commits a lot more to its estimates than the "soft" alternative, but seems simpler to implement.

Given its possible benefits over the _soft_ version, the questions that arise are:  

1. Will it work for the example of section <a href='#shortcomings'>shortcomings of naive splitting</a>
 where there is a common exon in two different transcripts?  
2. Will it work in general?

----
<!--
- The figure here is due to Paraskevas Deligiannis. -->
