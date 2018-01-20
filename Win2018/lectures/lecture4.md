---
layout: page
mathjax: true
permalink: /Win2018/lectures/lecture4/
---
## Lecture 4: Base Calling for Next-Generation Sequencing

Thursday 18 January 18

## Topics

We last talked about Illumina reads, which are short (~100-200 bp long). For long read technologies, reads can reach the length of 10s of thousands of bp long. Today we will discuss the base calling problems associated with long-read technology.

1.	<a href='#ml'>Maximum Likelihood</a>
2.	<a href='#lr'>Long Read Technologies</a>
    - <a href='#nano'>Nanopore</a>
    - <a href='#pb'>Pacific Biosciences</a>

For optimal base calling, we modeled the base calling process as

$$\mathbf{y}^A = Q\mathbf{s}^A + \mathbf{n}^A$$

 where $$\mathbf{y}^A$$ is our observed signal, $$Q$$ models the intersymbol interference (distortion on the true signal $$\mathbf{s}$$), and $$\mathbf{n}$$ models the technical noise. We previously discussed linear methods, i.e. methods of the following form:

[IMAGE: y^A -> [H] -> [step function] -> s-hat ^A]

The step function here refers to symbol-by-symbol thresholding. The best $$H$$ we came up last lecture with was from the MMSE formulation, but this strategy is not necessarily optimal because it does not use the fact that y \in \{0, 1\}.

## <a id='ml'></a>Maximum Likelihood

We will now attempt to formulate the problem as a maximum likelihood (ML) problem (we will omit the $$A$$ superscript to simplify the notation).

$$ \max_{\mathbf{s} \in \{0, 1\}^L} P(\mathbf{y} | \mathbf{s}) = \max_{\mathbf{s} \in \{0, 1\}^L} \frac{1}{(2\pi)^{n/2} \sigma} \exp \left( \frac{-1}{2\sigma^2} \| \mathbf{y} - Q\mathbf{s} \|^2 \right) = \min_{\mathbf{s} \in \{0, 1\}^L} \| \mathbf{y} - Q\mathbf{s} \|^2$$

A brute-force approach would involve testing all $$2^L$$ possible solutions, but this is very inefficient. If we assume $$Q$$ can take on any form, there is no easy way to solve this problem. Recall that for $$Q$$, as we move away from the diagonal entries, the terms get smaller quickly. Therefore we can approximate $$Q$$ with a band-diagonal matrix. For now, we will assume that $$Q$$ will only have 2 bands: the main diagonal and the diagonal right below:

$$ Q \approx $$

Now, our original equation $$\mathbf{y} = Q\mathbf{s} + \mathbf{n}$$ becomes

$$
\begin{align*}
y(1) &:= Q_{11} s(1) + n(1) \\
y(2) &:= Q_{22} s(2) + Q_{21} s(1) + n(2) \\
y(3) &:= Q_{33} s(3) + Q_{32} s(2) + n(3) \\
& \vdots
\end{align*}
$$

which can be summarized as

$$ \min_{\mathbf{s}} \sum_{i = 2}^L [ y(i) - Q_{ii} s(i) - Q_{i, i-1} s(i-1) ]^2 + [y(1) - Q_{11}s(1)]^2. $$

We can also introduce a state-transition model to capture how each entry $$s(i)$$ depends on previous entries. We can define the state as

$$ \text{state} =
\begin{bmatrix}
s(i-1) \\
s(i)
\end{bmatrix}
$$

resulting in the following state transition diagram

[IMAGE of state transition diagram]

We can now view the optimization problem as
$$ \min_{\mathbf{s}} \sum_{i = 2}^L [c_i(s(i-1), s(i))]^2 + [y(1) - Q_{11}s(1)]^2. $$

where $$c_i$$ is the cost associated with transitioning from state $$s(i-1)$$ to state $$s(i)$$. Therefore one method of solving this algorithm would be a shortest-path algorithm that needs to find a path of length $$L$$. Another way of viewing the state transitions is by using a _trellis_.

[IMAGE of trellis]

We have $$L$$ stages, and we can find the shortest path using the [_Viterbi algorithm_](https://en.wikipedia.org/wiki/Viterbi_algorithm) (dynamic programming). We exploit the fact that the shortest path at base $$i$$ is simply the minimum of the combinations of shortest path at base $$i-1$$. The algorithm can solve the problem in runtime linear to the number of state transitions, which is much better than the brute-force solution with runtime $$2^L$$.

## <a id='lr'></a>Long Read Technologies

Recall that a major issue with short reads is the difficulty of resolving _repeats_, identical sequences within the reference genome.

[IMAGE: repeat confusion]

Technology that produce longer reads can help resolve this. We will discuss two strategies for long-read sequences pioneered by the two companies _Oxford Nanopore_ (zero-mode waveguide) and _Pacific Biosciences_. Both strategies perform _single-molecule sequencing_, which in contrast to second-generation sequencing technologies, does not require PCR.

### <a id='nano'></a>Nanopore

For second-generation sequencing, we were measuring color. For Nanopore technologies, bases are tagged such that each nucleotide has a different resistance. Therefore we effectively have an electrical circuit with capacitance (effectively a constant voltage source) from the lipid layer and resistance from the nucleotide, and we can read the current (on the order of picoamperes or pA). Our length is no longer limited by the phasing or misalignment issue, but instead is limited by when our enzyme breaks down.

[IMAGE: nanopore. See [here](https://www.youtube.com/watch?v=GUb1TZvMWsw) for a video.]

The error rate of Oxford Nanopore is relatively bad and on the order of 15-20% due to two major issues associated with this technology.

1. The size of a nanopore is bigger than a nucleotide, and therefore each electrical signal we measure is the signal aggregated from a few adjacent nucleotides (typically 3-6).

2. The DNA sequence does not move at a constant rate through the nanopore. Therefore when we segment the signal, we may skip bases or backtrack. This leads to deletion and insertion errors, the major source of error for this technology.

The diagram below describes a state-of-the-art approach for performing base calling. We start by sliding a length-4 window across our DNA sequence, resulting in length-4 sequences called _contexts_. Occasionally we may skip or backtrack. The _dwell time_ is the time each window spends in the nanopore, or the time we read a particular current for. Level-finding is the process of of smoothening the noisy pA signal into discrete steps. Finally, we discretize the signal.

[IMAGE: nanopore base calling (Mao et al 2017)]

Leveraging our previous notation, we can summarize the process using the following block diagram:

[IMAGE: s1 s2... -> [base->contexts] -> z1 z2 ... -> [deletion/insertion] -> z1 z2 ... -> + noise -> y ]

Note that $$s_i \in \{A, G, C, T\}$$ while $$z_i \in \{A, G, C, T\}^4$$. Now we have a base calling problem. Leveraging our intuition from second-generation sequencing, we can again draw a state transition diagram. With 4-mers, we have $$2^8$$ states. Given that we are in a certain state, how many states can we move to? Assuming that the probability of insertion or deletion is 0, then we can move to only one of 4 states.

In general, however, we can use our Viterbi approach from before. Each column in the trellis consists of $$2^8$$ states. If the probability of skipping one or two bases is non-zero, then we simply add more edges to our trellis.

### <a id='pb'></a>Pacific Biosciences

While Nanopore technology measures electrical current, PacBio technology measures colors emitted in microscopic wells called _zero-mode waveguides_ ($$10^{-21}$$ liters) during DNA synthesis. With 10s of thousands of wells per so-called SMRT chip, each ZMW essentially allows us to read out color intensities at thousands of times stronger than the background signal. The error rate of PacBio reads is about 10-15%. The speed of the process of the single DNA molecule going through an enzyme causes randomness, resulting in the same insertion and deletion issues also associated with Nanopore technology.

[IMAGE: PacBio sequencing [video](https://www.youtube.com/watch?v=NHCJ8PtYCFc)]
