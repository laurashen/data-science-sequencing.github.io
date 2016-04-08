## Future questions

### Naive aligner

1. Write a function that computes the edit distance between two strings. You can use standard libraries such as [editdistance](https://pypi.python.org/pypi/editdistance) to check the correctness of your function. The input should be two strings each of at least length 2. The output should be a float representing the edit distance between the two input strings.

2. Write a function that generates random reads. The input should be the number of reads generated $$N$$ and the length $$L$$ of each read generated. The output should be $$N$$ random length-$$L$$ sequences of nucleotides.

3. How can you use the above two functions to perform alignment? What issues do you see with this approach? (3-4 sentences).

4. For $$L$$ = 10, generate two reads of length $$L$$ and compute their edit distance. Average your result over 100 runs to obtain an estimate of the average edit distance $$\hat{d}_L$$ of two randomly generated reads of length $$L$$. Repeat for $$L$$ = 1, 100, 1000, and 10000. Plot $$\hat{d}_L$$ as a function of $$L$$ with error bars. Do you observe any trends? What can you say about how well random strings align? (1-2 sentences).
