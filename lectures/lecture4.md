---
layout: page
mathjax: true
permalink: /lectures/lecture4/
---
## Lecture 4: Nanopore Sequencing Technology

_Guest Lecture by Bikash Sabata, VP of Software, Genia Technologies_

Wednesday 6 April 2016

_Scribed by Reesab Pathak and revised by the course staff_



## Topics

1.	<a href='#history'>History of Genia</a>
2.	<a href='#nanopore'>Nanopore-based sequencing technology</a>
- <a href='#ic'>Integrated circuit technology</a>
- <a href='#singlemolecule'>Single molecule sequencing machine</a>
- <a href='#solution'>Genia sequencing solution</a>
- <a href='#datarates'>Data rates</a>
3.	<a href='#future'>Context and the future for Genia</a>

## <a id='history'></a>History of Genia
[Genia](http://www.geniachip.com/) was founded in March 2009 by Roger Chen, Stefan Roever, Pratima Rao and Randy Davis and was [acquired by Roche](http://www.roche.com/media/store/releases/med-cor-2014-06-02.htm) in June 2014. Genia views its technology as a fourth-generation sequencing technology, rivaled by Oxford Nanopore sequencing technology. This assumes that the Pacific Biosciences sequencing is third generation. Genia's technology is different from [Oxford Nanopore's sequencing technology](https://www.youtube.com/watch?v=3UHw22hBpAk).

## <a id='nanopore'></a>Nanopore-based sequencing technology
Genia's sequencing technology is a combination of electronics and molecular biology. Genia uses single molecule sequencing (using nanopores) and an integrated circuit to allow high-fidelity, robust, scalable, electrical detection at low cost. At the heart of Genia's technology is the nanopore, a cleverly engineered biomolecule in the shape of a pore. Genia's nanopore is a modified version of the hemolysin nanopore naturally found in Streptococcus.

<div class="fig figcenter fighighlight">
  <img src="https://upload.wikimedia.org/wikipedia/en/f/f4/AHL_DNA.GIF" width="30%">
  <div class="figcaption">An example nanopore biomolecule from Wikipedia. </div>
</div>

The single molecule sequencing technique has ushered in a new capability: long read sequencing. Genia is still working on developing the sequencing technology before getting to the market. The goal of Genia is to get to $100/genome for sequencing. A secondary goal is to scale sequencing at a rapid rate.

### <a id='ic'></a> Overview of the technology
Genia leverages integrated circuit design to provide massively parallel sequencing. Genia uses electrode wells of 4.5 microns in width per nanopore. Scaling the sequencing technology enables faster turnaround times at a lower per genome sequencing cost. Currently there are 128,000 wells per plate, and Genia uses organic pores in the well.

At the lowest level, Genia creates a microscopic chemistry lab inside the a well of the chip. The nanopore machine consists of 3 main components:

- nanopore
- polymerase
- nucleotide tags (modified dNTPs)

The DNA to be sequenced is held by the polymerase on top of the nanopore. In reality, the polymerase is a bit above the pore but the two biomolecules are held together by a linker. The size ratio of a single pore to its containing well is analogous to the size ratio of a football to a football stadium.

### <a id='singlemolecule'></a> Single molecule sequencing machine

The Single Molecule Sequencing (SMS) design enables long accurate reads without the use of PCR. This is possible because the sensing technology for picovolts is much better with the IC design than with second generation sequencing technology and sensing individual photons.

<div class="fig figcenter fighighlight">
  <img src="http://sequencing.roche.com/content/internet/corporate/diagnostics/sequencing/en_US/home/research---development/nanopore-sequencing/_jcr_content/mainParsys/bigimage/image.img.png/1428073121706.png" width="30%">
  <div class="figcaption">An example SMS design from http://sequencing.roche.com/. </div>
</div>

The SMS machine is placed on top of a lipid bilayer inside the wells of the IC. There is a single, engineered, high-fidelity polymerase on top of the nanopore. Each base has a nucleotide tag that provides an electrical signal through a unique electrical signature. When the polymerase attaches a base, the tag is pulled through the pore of the polymerase, creating an electric potential difference across the lipid bilayer. The electrical current must go through the pore, changing the capacitance and providing a signal. The incorporation of each nucleotide provides a unique signal. Genia also has more [information available online](http://sequencing.roche.com/research---development/nanopore-sequencing.html) about this technology. Importantly, the tags are not  fluorescent tag.

### <a id='solution'></a> Genia sequencing solution
There is a common electrode at the top of the cell.  We can therefore model the nanopore as a resistor, the lipid bilayer (which provides a dielectric) as a capacitor, and the overall system as a simple RC circuit. The DNA tags provide different resistance changes. The tags are designed so that singals from different nucleotides are well-separated.

Base-calling is a signal processing problem but is not as difficult as the Illumina base-calling problem given the large separation in voltage drops per nucleotide. The data coming from the sequencer is extremely noisy. The main source of noise in Genia sequencing is dynamical biochemistry. All molecules involved are constantly moving in the well and interacting in unpredictable ways with each other. Additionally, the tag does not flow smoothly through the pore. Since other pores are hanging in the well (and just didn’t get inserted into the lipid bilayer), they may also be moving around and grabbing things. But the DNA, linker, nanopore complex are held together tightly thanks to covalent bonds.

### <a id='datarates'></a> Data rates
The current Genia system has 128K wells on a sequencing chip. Signal sampling occurs at 2000 measurements per second. A single Genia experiment can last from 1 to 10 hours, though it often takes less time when running standard sequencing protocols. Data is acquired, currently, at 256 MB per second. Overall, close to 1 TB of data is generated per hour. Genia currently generates about 40-60 TB of data per day (200,000 computing hours or 22 years for a single PC), and Genia expects to scale the data acquisition to 8GB per second. In the near future, Genia could be generating as much as 200 TB per day.

## <a id='future'></a>Context and the future for Genia
Recently, Roche has been acquiring companies for sample extraction, enrichment, sequencing, data analysis, and reporting. The acquisition of Genia was part of Roche’s larger effort to create better medical diagnostics. The future of Genia lies in building more scalable instrumentation at lower costs. Genia aims to build a fast affordable and accurate sequencing solution. Some advantages include no PCR, no optics or complicated fluidics, simple sample preparation, and a relatively cheap instrument has a in terms of cost per machine and per sample.
