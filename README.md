
<!-- README.md is generated from README.Rmd. Please edit that file -->

# markovtext

<!-- badges: start -->
<!-- badges: end -->

A deeply unserious package for generating random text that mimics a
given input text using Markov chains.

## Installation

You can install the development version of markovtext from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("chris31415926535/markovtext")
```

## Overview

The package has two main functions: `markovtext::get_word_freqs()`
generates a word-frequency table, and `markovtext::generate_text()` uses
that table to generate random text. It also includes a few sample
word-frequency tables to get you started.

## Example: Generating text based on built-in datasets

This package truly has something for everyone.

### For the Doug Ford superfans

Perhaps you are a [Doug Ford](https://en.wikipedia.org/wiki/Doug_Ford)
superfan, and your only wish in life is for a never-ending source of
wisdom from Ontario’s 26th Premier. Today is your lucky day, for nirvana
is only one function call away:

``` r
dougford_text <- markovtext::generate_text(markovtext::wordfreqs_dougford_3grams, word_length = 100)
```

``` r
dougford_text
```

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| I made a commitment to ontario. You have sent to queen’s park a team that will continue. I want to thank each of you, and united our party, and tonight the people of this great province, a new day has dawned on ontario! A day of opportunity, a mandate for the people. A government with integrity, a vision for the people of ontario have spoken. People from every corner of this province has never seen before. Prosperity that will benefit every resident of ontario have spoken. People from every |

### For three-year-olds who just won’t go to sleep

Or perhaps you’re a beleaguered parent facing a three-year-old with an
insatiable demand for Dr. Seuss bedtime stories. Again, I’ve got you
covered:

``` r
seuss_text <- markovtext::generate_text(markovtext::wordfreqs_catinthehat_3grams, word_length = 100)
```

``` r
seuss_text
```

|                                                                                                                                                                                                                                                                                                                                                                                                      |
|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| I will pick up all the things that went on there that day? Should we do? And sally. We shook their two hands. But I like to fly kites, said the fish. And he gave them a pat. They like, said the cat. In this box are two things, said the cat in the pot. They will hit! Oh, so tame! They have come here to play. They should not fly kites in a house! Make them go! They have come here to play |

## Example: Generating text based on your own inputs

### Creating a word-frequency table

To create a word-frequency table, you can supply a character vector or a
data.frame with a column named “text.”

Here we’ll build our table based on this famous aphorism from the
philosopher [James Robert
Brown](https://en.wikipedia.org/wiki/James_Robert_Brown):

``` r
library(markovtext)

text <- "I can do wheelin', I can do dealin',
         But I don't do no damn squealin'.
         I can dig rappin', I'm ready! I can dig scrappin'.
         But I can't dig that backstabbin'."

wordfreqs <- markovtext::get_word_freqs(text, n_grams = 3)
```

### Generating text

Generating text is a simple call to `generate_text()`.

``` r
new_text <- markovtext::generate_text(wordfreqs, word_length = 50)
```

``` r
new_text
```

|                                                                                                                                                                                                   |
|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| I can do wheelin, I can do wheelin, I can dig rappin, i’m ready! I can dig rappin, i’m ready! I can do dealin, but I can’t dig that backstabbin. I can dig rappin, i’m ready! I can dig scrappin. |

Note that leading and trailing punctuation is trimmed.
