---
layout: page
mathjax: true
permalink: /labhours/labhour1/
---
## Lab Hour 1: Tutorial on Terminal and iPython

Friday 8 April 2016

---

Install [Anaconda](https://www.continuum.io/downloads), which will provide you with all the Python packages you will need for many Stanford courses. These packages include numpy, scipy, matplotlib, and jupyter (iPython notebooks).

Some example files to play around with can be found [here](data-science-sequencing.github.io/assets/labhour1/lab1examples.zip). These files are from a real dataset, which is publicly available [here](http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE65360).

A tutorial on working in the Terminal can be found [here](/assets/labhour1/).

A tutorial on working in iPython can be downloaded [here](/assets/labhour1/ipython_basics.ipynb). You can start the notebook by going to Terminal, navigating to the directory containing the newly downloaded $$\texttt{ipython_basics.ipynb}$$, and executing the command
```
ipython notebook
```
, which opens the jupyter home directory in your browser. Double-click the notebook to get started.

You can convert the notebook to a basic python script using the command:
```
ipython nbconvert --to PYTHON
```

One thing we did not cover in detail were NumPy and SciPy. We highly recommend going through [this tutorial](http://cs231n.github.io/python-numpy-tutorial/) for getting up to speed.
