---
layout: page
mathjax: true
permalink: /lectures/lecture9/
---
## Lecture 3: Assembly - Multibridging and Read-Overlap Graphs

Monday 25 April 2016

_Scribed by Min Cheol Kim and revised by the course staff_



## Topics

In the last lecture, we discussed about a practical algorithm based on the de Bruijin graph strucutre.
In this lecture, we examine a tweak of the de Bruijin structure (k-mers)
that has better performance. We then discuss the notion of read-overlap graphs.

1.	<a href='#review'>Review of de Bruijin algorithm</a>
2.	<a href='#multi'>Making k smaller</a>
    - <a href='#simple'>Simple bridging</a>
    - <a href='#triple'>Multibridging</a>
3. <a href='#readoverlap'>Assembly problem revisited: read-overlap graphs</a>
    - <a href='#read1'>Read-overlap graph</a>
    - <a href='#info'>Information limit and solving instances of a NP-hard problem</a>  
    - <a href='#weakness'>Weakness of this framework of algorithm design</a>  

## <a id='review'></a>Review of de Bruijin algorithm

de Bruijin Graph Algorithm:  
	1. Chop L-mers (reads) into k-mers. These become basic units of the algorithm.  
	2. Build the de Bruijin graph from the k-mers.  
	3. Find the Eulerian Path.

Conditions for de Bruijin to succeed:  
	1. k - 1 > $$\ell_{\text{interleaved}}$$ (length of the longest interleaved repeat)  
	2. DNA is k-covered (A read and the read in the next position have k-overlap)

Observe that the de Bruijin graph algorithm can achieve perfect assembly at shorter
read lengths that Greedy, but coverage depth must be very high (even worse than
Greedy in some cases!). This comes from the fact that the condition on bridging
(k - 1 > $$\ell_{\text{interleaved}}$$). The k-mers must bridge
**every** intereaved repeat.

For the lower bound, the necessary condition for reconstruction is that the interleaved repeats are bridged by the reads (not k-mers). There are only a few long interleaved repeats, and it is overkill to bridge all those with k-mers. We have the information to cover these interleaved repeats with the L-mer (reads) themselves, but we are not using this information by chopping them all into k-mers.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture8/Figure9.png" width="75%">
	<div class="figcaption">Lower bound from Lander-Waterman calculation, the read
	complexity necessary for the greedy algorithm and the
  de Bruijn graph algorithm to succeed (with probability \(1-\epsilon\)), and Ukkonen's
	lower bound for successful assembly (w. p. \(1-\epsilon\)).</div>
</div>


## <a id='multi'></a>Making k smaller

By taking advantage of the fact that we do not need to bridge **all** interleaved repeats with k-mers, we come up with modified versions of the de Bruijin algorithm. We set k  $$<< \ \ell_{\text{interleaved}}$$, and we do something special for the long interleaved repeats, which are few in numbers.

### <a id='simple'></a>Simple Bridging

The problem we had when k <= $$\ell_{\text{interleaved}}$$+ 1 was that, we have confusion when finding the Eulerian path when traversing through all the edges, as covered in the previous lecture (Refer to examples of de Bruijin graphs in Lecture 8). When multiple Eulerian paths exist, we cannot guarantee a correct reconstruction.

We can circumvent this problem by using the reads (L-mers) themselves to resolve the conflicts. In the figure below, with k < $$\ell_{\text{interleaved}}$$, there were two potential Eulerian paths, where one traverses the green segment first or the pink segment first.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture9/Figure1.png" width="90%">
	<div class="figcaption">Bridging read resolves one repeat and the unique Eulerian
path resolves the other.</div>
</div>

However, by incorporating the information in the bridging read, the we can reduce the number of Eulerian paths to one:  
	1. Find the bridging read on the graph, in this case on the top right.  
	2. Since we know that orange segment must follow the green segment, replicate the black node and create a separate path from green - black - orange.

Information from bridging reads simplify the graph.

At this point, our conditions for a successful assembly is as follows:  
	1. All interleaved repeats (except triple repeats) are singly bridged.  
	2. k > $$\ell_{\text{triple}}$$ (length of the longest triple repeat).

The performance of this algorithm is shown in the figure below. Note that even though this reduces the number of reads we need, it is still not as close to the lower bound as we hope. Can we do better?

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture9/Figure2.png" width="75%">
	<div class="figcaption">Lower bound from Lander-Waterman calculation, the read
	complexity necessary for the greedy algorithm, the
  de Bruijn graph algorithm, and the SimpleBridging algorithm to succeed (with probability \(1-\epsilon\)), and Ukkonen's
	lower bound for successful assembly (w. p. \(1-\epsilon\)).</div>
</div>

### <a id='simple'></a>Multibridging

The algorithm we outlined above had k > $$\ell_{\text{triple}}$$ as a condition, which allowed us to ignore this case. Triple repeats are special in that, even when it is singly bridged, there is still ambiguity to the Eulerian path.

We can modify the algorithm further to get around the ambiguity. If the triple repeats are triple-bridged (meaning that every copy of the repeat has a bridging read), then we can separate the repeat node into three different distinct nodes that each connect to distinct adjacent nodes.

In the figure below, if we have three reads that each bridge a copy of the grey triple repeat, then we can resolve the conflicts.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture9/Figure3.png" width="90%">
	<div class="figcaption">If all three copies of a triple repeat are bridged,
  one can resolve them locally.</div>
</div>

With this in mind, our conditions for success then becomes [Bresler, Bresler, Tse, 2013](http://arxiv.org/abs/1301.0068):

1. Triple repeats are ALL bridged.
2. Interleaved repeats are singly bridged
3. Coverage


We also see that the performance of the multibridging algorithm is close to that of the lower bound.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture9/Figure4.png" width="75%">
	<div class="figcaption">Lower bound from Lander-Waterman calculation, the read
	complexity necessary for the greedy algorithm, the
  de Bruijn graph algorithm, the SimpleBridging algorithm, and the MultiBridging algorithm to succeed (with probability \(1-\epsilon\)), and Ukkonen's
	lower bound for successful assembly (w. p. \(1-\epsilon\)).</div>
</div>

## <a id='readoverlap'></a>Assembly problem revisited: read-overlap graphs

So far we have looked at versions of the algorithm called the de Bruijin algorithm. This algorithm essentially takes these long reads and chops them up into shorter, k-mers. Then we realize that the k-mers do not contain enough information, and we bring back some of the important repeats to resolve conflicts.

This seems like a strage paradigm, since the reads are the ones that contain all the information to begin with. A more natural class of algorithm is called the read-overlap algorithm, which is actually the original approach to assembly.

### <a id='read1'></a>Read-overlap graphs

Instead of thinking about k-mers, we should think about reads themselves. Using this idea, we reconstruct a graph where all the nodes of the graph are reads, without any k-mer transformation. Then, we connect them by edge. Each edge measures the amount of overlap that each read has with each other. The number on each edge is the amount of extension that one would get by putting the reads together.

For example, if you have two reads ACGCA and CGCAT, you would get an extension of 1 (overlap of 4) when the reads are put together to form ACGCAT. An example of such a read-length graph is shown below.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture9/Figure5.png" width="75%">
	<div class="figcaption">A read overlap graph contains the  original sequence
  as a hamiltonian path.</div>
</div>

This in some sense, this is the most natural representation of an assembly problem. The assembly problem then becomes taking a path that goes through every single node in the graph, while also minimizing the sum of the weights (maximize the overlap).

This path is called the Generalized Hamiltonian Path, a path that visits every node at least once, while maintaining the minimum sum of weights. We may need to visit a node multiple times due to repeats.

It turns out that this problem is NP-hard. This is one of the main motivation for solving the de Bruijin graph.

### <a id='info'></a>Information limit and solving instances of a NP-hard problem

With some of the insights gathered on the problem, we can try to get enough structure to "solve" this instances of this problem, that is in general NP-hard problem.

Let us see what the most basic algorithm does in terms of the read-overlap graph - the Greedy algorithm. The greedy algorithm essentially picks the largest overlap, and never worry about the other overlaps, and maintains only that one edge. This vastly simplifies the graph, with only one outgoing edge from each node.

Greedy's pitfall is that when the true path visits a node twice, it will fail. This is an oversimplification of the generalized Hamiltonian path problem.

Going back to our performance figure, we see that the Greedy algorithm lives in the red region, where the read length is long enough to cover **all** repeats. That leaves the blue region, where reconstruction is still possible but we may need to visit the nodes more than once.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture9/Figure6.png" width="75%">
	<div class="figcaption">Information limits in the read-overlap graph framework.</div>
</div>

Then we ask ourselves, do we need to visit a node more than 2 times? This refers to an unbridged triple repeat situation, in which reconstruction is not possible anyway. In the figure below, we notice that either the blue or red path is possible.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture9/Figure7.png" width="75%">
	<div class="figcaption">This shows that we can not visit a read more than two reads unless
  a triple repeat is not bridged.</div>
</div>

The information analysis shows us that the Greedy is an oversimplification, but we do not need to visit a node more than twice; this stands on the left of the lower bound (figure below). We need an algorithm that visits each node no more than twice.

<div class="fig figcenter fighighlight">
  <img src="/assets/lecture9/Figure8.png" width="75%">
	<div class="figcaption"> The use of "Not-so-greedy" to achieve theoretic limits.</div>
</div>

This algorithm is called the "Not-so-greedy" algorithm that keeps exactly two best extensions for each node, and throws away all else. The complexity is linear with the number of reads. In the green region, we can overcome the NP-hardness of the Hamiltonian problem.

### <a id='weakness'></a>Weakness of this framework of algorithm design

We note that the design of algorithms like Not-so-greedy which are theoretic
optimal are designed assuming that the genome can be assembled completely. These are
useful when we have where one does not bridge repeats, but bridges all interleaved
repeats. In practice, there are few such data-sets. Here, one usually is in regimes where either all repeats are bridged
(for example the [Pacbio _E. coli_ data-set](https://github.com/PacificBiosciences/DevNet/wiki/E.-coli-Bacterial-Assembly)),
or even interleaved repeats are not bridged (for example the
[Pacbio human chromosome 1 data-set](https://github.com/PacificBiosciences/DevNet/wiki/H_sapiens_54x_release)).
This makes algorithms like Not-so-greedy to be of limited appeal in practice.  

Thus practically in the Read-Overlap graph framework, the greedy algorithm, and
algorithms like [string graph](http://bioinformatics.oxfordjournals.org/content/21/suppl_2/ii79.abstract)
still rule the roost currently.
