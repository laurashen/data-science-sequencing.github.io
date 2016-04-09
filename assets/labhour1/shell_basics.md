---
layout: page
mathjax: true
permalink: /assets/labhour1/
---

## Shell Basics

Starting with the Terminal, log into Stanford's Corn server.

```
ssh SUNETID@corn.stanford.edu
```

You can view the contents of your current directory using the ```ls``` command. Create a new directory using

```
mkdir EE372Lab1
```

and change your working directory to this new directory using

```
cd EE372Lab1
```

You can move up a directory using

```
cd ..
```

Download the examples we're using for this tutorial using the command

```
wget data-science-sequencing.github.io/assets/labhour1/lab1examples.zip
```

Unzip the zipped files

```
unzip data-science-sequencing.github.io/assets/labhour1/lab1examples.zip
```

You can remove a file with

```
rm lab1examples.zip
```

Type "yes" if the Terminal asks you if you're sure you want to remove the file. You can use the ```mv``` command to move files. For example, we can use the following command to move the lab1example_GSM file up a directory.

```
mv lab1example_GSM ../
```

```awk``` is a powerful tool that lets you easily lets you do some initial processing on a file of interest. We will go through a few examples below.

If you want to split each line of a file based on a substring "R1", you can do

```
awk -F "R1" '{print $0"\t"$1"\t"$2}' lab1example_SRR
```

The "-F" option indicates what substring you want to split on. This will split "SRR1234" into "SR" and "234", and it will split "helloR1worldR1!!" into "hello", "world", and "!!". The portion of the command in the single quotes tells awk how to process each line of the file. ```print $0``` will print out the entire line, ```print $1``` will print out the first part of the line (after splitting), and ```print $2``` will print the second part of the line. The way we used awk here with the file lab1example_SRR will result in the entire line being printed out followed by a tab, followed by "SR", followed by the a number. We can also print out the the row index using "NR":

```
awk '{print NR}' lab1example_SRR
```

the last number printed here will be the number of lines in the file (1632). We can also print out the length of each row:

```
awk '{print length($0)}' lab1example_SRR
```

which will be 10 in this case for all 1632 rows.

The lab1example_fastq file contains 1000 reads from a sequencing experiment. Every 4 lines correspond to 1 read (you can learn more about fastq files using this [tutorial](http://nbviewer.jupyter.org/github/BenLangmead/comp-genomics-class/blob/master/notebooks/FASTQ.ipynb)). We can use awk to extract only the sequences with

```
awk '{if (NR % 4 == 2) print $0}' lab1example_fastq > reads
```

The "> reads" here saves the output of the command to the left of the ">" in a file called "reads".

Another powerful tool is ```sed```, and we'll use only its substitution feature here. We can replace every "A" with "a" in the newly made "reads" file with

```
sed 's/A/a/g' reads
```

The "s" indicates substitution, and the "g" indicates global (every "A" will be substituted with "a"). Similarly, we can delete all "A"s with

```
sed 's/A//g' reads
```

There are a few ways to view a file. ```cat``` prints the entire content of a file into the Terminal. If you are handling big files, you may not want this. ```head``` allows you to print the first only the first 10 lines of a files. You can use

```
head -n 20 reads
```

to print the first 20 lines of the "reads" file.

You can use ```cat``` and ">" to easily create a new file. Typing

```
cat > temp
```

followed by 1, 11, 2, 27, 14 (hitting return after typing each number) will create a file called "temp" with these 5 numbers occupying 5 lines.

```
sort temp
```

will sort the lines of this file lexographically, which is different than numerically. You will need to use

```
sort -n temp
```

to sort the file numerically. We showed above how you can use ```awk``` to count the number of lines in a file. We can also count the number of lines in the "reads" file using

```
wc -l reads
```

To look at the number of unique reads, we must first ```sort``` the reads files, save it as some intermediate file (i.e. ```sort reads > reads_sorted```), and then use the command

```
uniq reads_sorted
```

We can save the output of this command as another file "reads_uniq" and count the number of reads in this file with ```wc -l```. You should get 997 as your answer (i.e. there are 997 unique reads out of 1000 total reads).

The last tool we will talk about is ```grep```, which allows you to select rows that contain a particular string. For example,

```
grep "ATACAA" reads
```

will select the lines in "reads" that contain "ATACAA" in them.

```
grep -v “A” reads
```

will select the lines in "reads" that do NOT contain "A" in them. There should only be 2 lines that satisfy this condition.

The last thing we'll talk about is the concept of piping. Rather than saving intermediate files (like we did with "reads_sorted" above), we can use the pipe operator ```|``` to stream the output of one tool as the input to the next tool. For example,

```
cat reads | grep "ATACAA" | grep -v "TTT" | wc -l
```

will first print all the lines of "reads", select lines with the "ATACAA" string, then select lines that do not have the "TTT" string before counting how many lines there are. This command answers the question: "Of the 1000 reads in the reads file, how many of them contain the subsequence ATACAA but not the subsequence TTT?"

We can also rewrite an above set of commands that counted the number of unique reads in the "reads" file with

```
sort reads | uniq | wc -l
```

The piping operator works with ```awk``` and ```sed``` too, of course. If we started with the fastq file rather than the reads file, we can still count the number of unique reads using

```
awk '{if (NR % 4 == 2) print $0}' lab1example_fastq | sort | uniq | wc -l
```

A LOT more can be done with the command line tools discussed here. You can find out more about these and other tools [here](http://ss64.com/bash/).
