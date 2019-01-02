# Data Filterer
This script filters out lines from a text file based on specified filters. 

## Usage
`perl filter.pl --file FILE --filter FILTER [OPTIONS]`

The output of the filtered result will be a file with a `-filtered` appended to its name.

**Note:** If a line starts with a whitespace, it is treated as a continuation of the previous line.

## Options
`--file FILE`  
**Required.** Input file to filter by.

`--filter F1 [--filter F2 --filter F3 ...]`  
**Required.** Data to filter out. For multiple filters, specify this option multiple times.

`--keep K1 [--keep K2 --keep K3 ...]`  
**Optional.** Data to not be filtered out. If a line contains the filtered string and the keep string, the keep string takes precendence and the line won't be filtered out. For multiple keep keywords, specify this option multiple times.

`--ignoreheaders`  
**Optional.** Number of headers to ignore. If not provided, all rows will be evaluated.

`--caseinsensitive`  
**Optional.** Do case-insensitive filter.

`--help`  
**Optional.** Display the help message.

## Example
A sample data has been provided under `example.csv`. Data is randomly generated. Any resemblance to real persons, living or dead, is purely coincidental.
