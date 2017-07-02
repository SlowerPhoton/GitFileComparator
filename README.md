# GitFileComparator
Script to compare a file across different releases

Specify the file (respectively the relative path to it) you want to get compared before you run the script. It is stored in the variable `FILE`.

The script then downloads the necessary repository and all versions of the file `FILE` across all tags. It stores the ouput in `result_*.txt` file. 

The result file is a table using ';' as a delimeter. Row starting with *"BRANCH:"* specifies the branch, the first column all tags for the branch. If there is an asterisk symbol '\*' in the second column, then file `FILE` from this tag differs from the previous one. Branches are separated by an empty row. 

Currently supports OpenSSL and LibTomCrypt GitHub repositories, but the script is easy enough to modify for any repository.
