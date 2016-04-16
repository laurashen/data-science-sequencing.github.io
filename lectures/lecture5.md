---
layout: page
mathjax: true
permalink: /lectures/lecture5/
---
Lecture 5: Assembly
=======
Monday 11 April 2016

-------

_Scribed by Mojtaba Tefagh and revised by the course staff_



## Topics


1.	<a href='#input'>Reads from a sequener</a>   
 		- <a href='#challenge'>Main Challenges</a>  
		- <a href='#complexity'>Sample Complexity</a>
2.	<a href='#coverage'> Coverage Problem </a>
3.	<a href='#greedy'> Greedy Algorithm </a>

## Input of Assembler <a id='input'></a>

We have already gone through a high-level description of the roles of the sequencer and the base caller and how these are achieved in practice. Assuming that these stages are completed successfully, their output would be hundreds of millions to billions of erroneous reads. This information is usually provided to us in the format of a `FASTQ` file in which $$Q$$ stands for the quality score associated to each base $$Q = 10\log_{10} P_e,$$ where $$P_e$$ is the probability of error which is calculated in the base calling stage and is available alongside the corresponding reads. The next phase in the pipeline  is  to reconstruct the original genome from this data.

### Main Challenges <a id='challenge'></a>

There are three major difficulties regarding the input of our problem:

  * As mentioned above, errors are ubiquitous in our input data. This can be ameliorated in low error-rate like _Illumina_, for which one can restrict their attention to only the high quality reads, and thus wasting a lot of data (for 1% error rates, around one-third of 100 length reads have at least 1 error). However, for  simplicity and clarity, we first assume that reads are error free, and examine the assembly problem under that setting.  
  * By the nature of evolution, there are always a lot of repeats in the genome which make the distinct reads from different far away locations can be similar. This inherent property of genome makes  reads from different places in the genome indistinguishable, which in turn makes it very hard to assemble them. By analogy, it is like attempting to solve a jigsaw puzzle with a  underlying picture having a lot of  identical sections.
  * Continuing in this puzzle analogy, **de novo assembly** which means to assemble the genome of a different species for the first time without any existing instances from previous works, is like solving a puzzle where the cover of the box is lost and you have no idea of what the final picture would be like. This is a much harder instance in contrast to **reference-based assembly** where we use an already sequenced DNA from the same spicies as a guide and map the reads into this template just like what we do in a real world puzzle game.

### Sample Complexity <a id='complexity'></a>

For much of the sequel, we focus on answering the following two questions.

- _How many reads should be do we need to assemble?_  
    We need at least one read that sequences each base of the genome. In other words, we need reads to at least *cover* the genome
		Because of the randomness involved in the locations we are sampling from, higher probability of coverage we need, more the samples
		we need.
- _How long should the reads do we need to assemble the underlying genome unambiguously?_  
    For example, one can not assemble from reads of length 1. So in general we want to get an estimate of the read lengths needed to assemble unambiguously.


## Coverage Problem <a id='coverage'></a>

Let  

$$
\begin{align*}
G &:= \text{Length of the genome},\\
L &:= \text{Read length},\\
N &:= \text{Number of reads}.
\end{align*}
$$

In any case, we would need that $$N > \frac{G}{L}$$. If we could pick the positions we could sample, then
we could get coverage from these many reads. Note that this is equivalent to,

$$
c = \frac{NL}{G}>1.
$$

Note that $$c$$ is  the expected number of reads covering a specific position on DNA  and called the *coverage*. Furthermore, suppose that reads are sampled uniformly at random and also independent of each other. Under these assumptions, the probability of there existing a location on the genome that no read covers can be computed as follows:  

$$\Pr(\text{there exist a location covered by no read})=\left(1-\frac{L}{G}\right)^N=\left(1-\frac{L}{G}\right)^{\frac{G}{L}\cdot\frac{LN}{G}}\approx e^{-\frac{LN}{G}}=e^{-c}$$

Define the random variable $$X$$ to be the number of positions not covered by any reads. By the linearity of expectation, the above line implies that:  

$$\begin{align*}
E[X]=Ge^{-c} \\
\Rightarrow \Pr(X\geq 1) \leq \frac{E[X]}{1}=Ge^{-c} \\
\Rightarrow \Pr(X=0)\geq 1-Ge^{-c}
\end{align*}$$  

, where the second step holds because of Markov inequality. Therefore, if one wants to guarantee the coverage with a probability of failure at most $$\epsilon$$, it is enough to consider the following $$N$$:  

$$
\epsilon=Ge^{-c}\Rightarrow c=\ln\frac{G}{\epsilon}\Rightarrow N=\frac{G}{L}\ln\frac{G}{\epsilon}
$$  

As an example, if the genome of interest is about one billion base pairs long, and the probability of failure is set to $$1\%$$, then we need at least $$25$$X coverage depth. $$(G=10^9;\epsilon=0.01\Rightarrow c=25.328)$$

## Greedy Algorithm <a id='greedy'></a>


Consider the following greedy assembler:

```
while (# reads > 1)
{
    search among all pairs of reads and find the two with the largest overlap
    merge these two so that the number of reads is reduced by one
}
```

As an example of how this works, consider the example genome $$AGATTATGGC$$ and its associated reads $$AGAT,GATT,TTAT,TGGC.$$ Then the above algorithm assembles them as follows:  
<div class="fig figcenter fighighlight">
  <img src="/assets/lecture5/Figure1.png" width="90%">
  <div class="figcaption"> The greedy algorithm assembles the reads on the LHS into the DNA on the RHS correctly. </div>
</div>  


As another example, consider the example genome $$ATGGTATGGC$$ and its associated reads $$ATGG,TGGT,TATG,TGGC.$$ Then the greedy algorithm assembles them in the following wrong way:  
<div class="fig figcenter fighighlight">
  <img src="/assets/lecture5/Figure2.png" width="90%">
  <div class="figcaption"> This time, the final result on the RHS is different from the original DNA. </div>
</div>  
As you can see, we cannot always guarantee that the output of the greedy algorithm is the original DNA. The following theorem gives the necessary and sufficient conditions for the correct assembly:  

**Theorem.** Let a set of reads from a genome fully cover the genome. Moreover, let that each repeat in the genome _bridged_ by at least one read, that is there exists a read
that starts at least one base before every repeat, and ends at least one base after. Then the above greedy algorithm is guaranteed to reconstruct the original DNA.

**Proof** The proof is by induction on the length of the overlap considered  in step $i$. We prove by induction that there is no mistake made in the step where the overlap used for merging is of length $$\ell$$.

 Let this be represented by $$\theta_i$$. If $$\theta_i=L-1$$, then as each $$L-1$$ length repeat is bridged (this implies that there are no repeats of lenght $$L-1$$, why?), and hence any overlap of length $$L-1$$ is a true overlap and hence the merging is not erroneous. Similarly, this holds for $$\theta_i=L-2, L-3, \cdots, 1$$. Further the
 assumption that the genome is covered gives us that we're left with a unique sequence at time we process all length $$1$$ overlaps, proving the result.

-----------------
