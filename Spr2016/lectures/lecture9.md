---
layout: page
mathjax: true
permalink: /Spr2016/lectures/lecture9/
---
## Lecture 9: Assembly - Multibridging and Read-Overlap Graphs

Monday 25 April 2016

_Scribed by Min Cheol Kim and revised by the course staff_



## Topics

In the last lecture, we discussed a practical algorithm based on the de Bruijin graph structure.
In this lecture, we examine a tweak of the de Bruijin structure (k-mers)
that has better performance. We then discuss the notion of read-overlap graphs.

1.	<a href='#review'>Review of de Bruijin algorithm</a>
2.	<a href='#multi'>Making k smaller</a>
    - <a href='#simple'>Simple bridging</a>
    - <a href='#triple'>Multibridging</a>
3. <a href='#readoverlap'>Assembly problem revisited: read-overlap graphs</a>
    - <a href='#read1'>Read-overlap graph</a>
    - <a href='#info'>Information limit and solving instances of an NP-hard problem</a>  


## <a id='review'></a>Review of de Bruijin algorithm

de Bruijin Graph Algorithm:  

1. Chop L-mers (reads) into k-mers, the basic units of the algorithm.  
2. Build the de Bruijin graph from the k-mers.  
3. Find the Eulerian Path.

Conditions for de Bruijin to succeed:  

1. k - 1 > $$\ell_{\text{interleaved}}$$ (length of the longest interleaved repeat)  
2. DNA is k-covered (the reads cover all bases in the DNA, and each read has k-overlap with at least one other read)

Observe that the de Bruijin graph algorithm can achieve perfect assembly at shorter
read lengths than Greedy, but the coverage depth must be very high (even worse than
Greedy in some cases!). This comes from the condition on bridging
(k - 1 > $$\ell_{\text{interleaved}}$$), which requires that the k-mers must bridge
**every** interleaved repeat.

For the lower bound, the necessary condition for reconstruction is that the interleaved repeats are bridged by the reads (not k-mers). There are only a few long interleaved repeats, and it is overkill to bridge all those with k-mers. We have the information to cover these interleaved repeats with the L-mer (reads) themselves, but we are not using this information by chopping them all into k-mers.

<div class="fig figcenter fighighlight">
  <img src="assets/lecture8/Figure9.png" width="75%">
	<div class="figcaption">Lower bound from the Lander-Waterman calculation, the read
	complexity necessary for the greedy algorithm and the
  de Bruijn graph algorithm to succeed (w. p. \(1-\epsilon\)), and Ukkonen's
	lower bound for successful assembly (w. p. \(1-\epsilon\)).</div>
</div>


## <a id='multi'></a>Making k smaller

By taking advantage of the fact that we do not need to bridge **all** interleaved repeats with k-mers, we can come up with modified versions of the de Bruijin algorithm. We set k  $$<< \ \ell_{\text{interleaved}}$$, and we do something special for the long interleaved repeats, which are few in numbers.

### <a id='simple'></a>Simple Bridging

The problem we had when k $$\leq \ell_{\text{interleaved}}$$+ 1 was that we have confusion when finding the Eulerian path when traversing through all the edges, as covered in the previous lecture (Refer to examples of de Bruijin graphs in Lecture 8). When multiple Eulerian paths exist, we cannot guarantee a correct reconstruction.

We can circumvent this problem by using the reads (L-mers) themselves to resolve the conflicts. In the figure below, with k < $$\ell_{\text{interleaved}}$$, there were two potential Eulerian paths: one traverses the green segment first and the other traverses the pink segment first.

<div class="fig figcenter fighighlight">
  <img src="assets/lecture9/Figure1.png" width="90%">
	<div class="figcaption">After resolving a node using a bridging read, we can find a unique Eulerian
path through the graph.</div>
</div>

By incorporating the information in the bridging read, however, we can reduce the number of Eulerian paths to one. In other words, we can resolve the ambiguity in the graph as follows:  

1. Find the bridging read on the graph, in this case on the top right.  
2. Since we know that the orange segment must follow the green segment, replicate the black node and create a separate green - black - orange path.

Information from bridging reads simplify the graph.

At this point, our conditions for a successful assembly is as follows:


1. All interleaved repeats (except triple repeats) are singly bridged.  
2. k-1 > $$\ell_{\text{triple}}$$ (length of the longest triple repeat).

The performance of this algorithm is shown in the figure below. Note that even though this reduces the number of reads we need, it is still not as close to the lower bound as we hope. Can we do better?

<div class="fig figcenter fighighlight">
  <img src="assets/lecture9/Figure2.png" width="75%">
	<div class="figcaption">Lower bound from the Lander-Waterman calculation, the read
	complexity necessary for the greedy algorithm, the
  de Bruijn graph algorithm, and the SimpleBridging algorithm to succeed (w. p. \(1-\epsilon\)), and Ukkonen's
	lower bound for successful assembly (w. p. \(1-\epsilon\)).</div>
</div>

### <a id='simple'></a>Multibridging

The algorithm we outlined above had k - 1 > $$\ell_{\text{triple}}$$ as a condition, which allowed us to guarantee the bridging of all copies of all triple repeats. A triple repeat is a special type of interleaved repeat in that there may still be ambiguity to the Eulerian path even if the repeat is bridged.

We can modify the algorithm further to get around the ambiguity. If the triple repeats are triple-bridged (meaning that every copy of the repeat is bridged by a read), then we can separate the repeat node into three different distinct nodes that each connect to distinct adjacent nodes. This is shown in the figure below.

<div class="fig figcenter fighighlight">
  <img src="assets/lecture9/Figure3.png" width="90%">
	<div class="figcaption">If all three copies of a triple repeat are bridged,
  one can resolve them locally.</div>
</div>

With this in mind, our conditions for success then becomes ([Bresler, Bresler, Tse, 2013](http://arxiv.org/abs/1301.0068)):

1. All copies of all triple repeats are bridged.
2. Interleaved repeats are singly bridged
3. Coverage (each base in the genome is covered by at least one read)


We also see that the performance of the multibridging algorithm is close to that of the lower bound.

<div class="fig figcenter fighighlight">
  <img src="assets/lecture9/Figure4.png" width="75%">
	<div class="figcaption">Lower bound from the Lander-Waterman calculation, the read
	complexity necessary for the greedy algorithm, the
  de Bruijn graph algorithm, the SimpleBridging algorithm, and the MultiBridging algorithm to succeed (w. p. \(1-\epsilon\)), and Ukkonen's
	lower bound for successful assembly (w. p. \(1-\epsilon\)).</div>
</div>

## <a id='readoverlap'></a>Assembly problem revisited: read-overlap graphs

So far we have looked at algorithms based on de Bruijin graphs. These algorithms essentially chop reads into shorter k-mers. Then we realized that the k-mers do not contain enough information, and we brought back some of the important reads to resolve conflicts.

This seems like a strange paradigm since the reads are the ones that contain all the information to begin with (why chop them up only to bring them back?). A more natural class of algorithms are based on read-overlap graphs, which is actually the original approach to assembly.

### <a id='read1'></a>Read-overlap graphs

Instead of thinking about k-mers, we should think about reads themselves. Using this idea, we reconstruct a graph where all the nodes of the graph are reads (without any k-mer transformation). Then, we connect every pair of nodes with an edge, building a complete graph. Each edge is associated with a number that indicates the amount of overlap between the two nodes (reads). Alternatively, we can also associate each edge with a number that indicates how much length we gain by joining the two reads.

An example of a read-length graph is shown below. If you have two reads ACGCA and CGCAT, you would get an extension of 1 (overlap of 4) when the reads are put together to form ACGCAT.

<div class="fig figcenter fighighlight">
  <img src="assets/lecture9/Figure5.png" width="75%">
	<div class="figcaption">A read overlap graph contains the  original sequence
  as a Hamiltonian path.</div>
</div>

In some sense, this is the most natural representation of the assembly problem. To solve the problem we would take a path that goes through every single node in the graph while also minimizing the sum of the extensions (or maximizing the sum of the overlaps).

This path is called the Generalized Hamiltonian Path, a path that visits every node at least once while maintaining the minimum sum of weights (note the difference between this and the Eulerian path). We may need to visit a node multiple times due to repeats.

It turns out that this problem is NP-hard. This is one of the main motivations for working with the de Bruijn graph instead.

### <a id='info'></a>Information limit and solving instances of an NP-hard problem

Under some assumptions, we can solve this problem, which is NP-hard in general.

Let us see what the most basic algorithm does in terms of the read-overlap graph - the Greedy algorithm. For each node, the Greedy algorithm picks the edge with the largest overlap going out, ignoring all other edges for that node. This vastly simplifies the graph with only one outgoing edge from each node.

Greedy's pitfall is that when the true path visits a node twice, the algorithm will fail. The approach is an oversimplification of the generalized Hamiltonian path problem.

Going back to our performance figure, we see that the Greedy algorithm lives in the red region where the read length is long enough to cover **all** repeats. That leaves the blue region where reconstruction is still possible but we may need to visit the nodes more than once.

<div class="fig figcenter fighighlight">
  <img src="assets/lecture9/Figure6.png" width="75%">
	<div class="figcaption">Information limits in the read-overlap graph framework.</div>
</div>

Note that we only need to visit a node more than 2 times if and only if there exists an unbridged triple repeat, but reconstruction in this situation is not possible anyway. In the figure below, we notice that we cannot determine whether we should traverse the blue or red path first.

<div class="fig figcenter fighighlight">
  <img src="assets/lecture9/Figure7.png" width="75%">
	<div class="figcaption"> Since a triple repeat is not bridged, we cannot determine whether we should traverse the blue or red path first.</div>
</div>

The information analysis shows us that the Greedy is an oversimplification, but we do not need to visit a node more than twice; this stands on the left of the lower bound (figure below). We need an algorithm that visits each node no more than twice.

<div class="fig figcenter fighighlight">
  <img src="assets/lecture9/Figure8.png" width="75%">
	<div class="figcaption"> The use of "Not-so-greedy" to achieve theoretic limits.</div>
</div>

This algorithm is called the "Not-so-greedy" algorithm, and it keeps exactly the two best extensions for each node. The complexity is linear with the number of reads. Therefore in the green region, we can overcome the NP-hardness of the Hamiltonian problem.
