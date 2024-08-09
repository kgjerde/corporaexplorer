
<!-- README.md is generated from README.Rmd. Please edit that file -->

# corporaexplorer: An R package for dynamic exploration of text collections

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/corporaexplorer)](https://cran.r-project.org/package=corporaexplorer)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![R build
status](https://github.com/kgjerde/corporaexplorer/workflows/R-CMD-check/badge.svg)](https://github.com/kgjerde/corporaexplorer/actions)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.01342/status.svg)](https://doi.org/10.21105/joss.01342)
[![Mentioned in Awesome
R](https://awesome.re/mentioned-badge.svg)](https://github.com/qinwf/awesome-R)
<!-- badges: end -->

> **“I really like the application and its simplicity. It looks great
> and is very functional. … a nice addition to text analysis tools.”**  
> *–[Kenneth Benoit](https://github.com/kbenoit), creator of
> [quanteda](https://quanteda.io/), professor of computational social
> science at
> [LSE](https://www.lse.ac.uk/Methodology/People/Academic-Staff/Kenneth-Benoit/Kenneth-Benoit)*

> **“I really enjoyed interacting with corporaexplorer.** **This is
> exciting work that opens up doors for non-technical users.”**  
> *–[Tyler Rinker](https://github.com/trinker), creator of
> [sentimentr](https://github.com/trinker/sentimentr) and
> [qdap](https://github.com/trinker/qdap)*

<!-- HTML here, in order to add custom font colour in Github Pages-->
<blockquote>
<p style="color:green">
<strong>– Featured in RStudio’s “R Views” blog’s
<a href="https://rviews.rstudio.com/2019/10/29/sept-2019-top-40-new-r-packages/"><strong><i>“Top
40 New R Packages”</i></strong></a></strong>
</p>
</blockquote>
<blockquote>
<p style="color:green">
<strong>– Included in
<a href="https://CRAN.R-project.org/view=NaturalLanguageProcessing"><i>CRAN
Task View: Natural Language Processing</i></a></strong>
</p>
</blockquote>
<hr>

<br>

<img src="https://github.com/kgjerde/corporaexplorer/raw/master/man/figures/readme_illustration.png" width="100%" />

*<sup>Illustration</sup> <sup>screenshots</sup>*

## What is corporaexplorer?

**corporaexplorer** is an R package that uses the `Shiny` graphical user
interface framework for dynamic exploration of text collections.

**corporaexplorer** is designed for use with a wide range of text
collections; one example could be a collection of tens of thousands of
documents scraped from a governmental website; another example could be
the collected works of a novelist; a third example could be the chapters
of a single book.

**corporaexplorer**’s intended primary audience are qualitatively
oriented researchers who rely on close reading of textual documents as
part of their academic activity, but the package should also be a useful
supplement for those doing quantitative textual research and wishing to
visit the texts under study. Finally, by offering a convenient way to
explore any character vector, it can also be useful for a wide range of
other R users.

While collecting and preparing the text collections to be explored
requires some familiarity with R programming, using the Shiny apps for
exploring and extracting documents from the corpus should be fairly
intuitive also for those with no programming knowledge, once the apps
have been set up by a collaborator. Thus, the aim is for the package to
be useful for anyone with a rudimentary knowledge of R – or with
collaborators who have such knowledge.

## Installation

To install the released version from CRAN, simply run the following from
an R console:

``` r
install.packages("corporaexplorer")
```

Alternatively, to install the development version from GitHub, run the
following from an R console:

``` r
install.packages("devtools")
devtools::install_github("kgjerde/corporaexplorer")
```

**corporaexplorer** works on Mac OS, Windows and Linux. (The Shiny apps
look much clunkier on Windows than on the other platforms, but the apps
are fully functional.)

## How to cite

Please cite the following paper if you use **corporaexplorer** in your
research.

> Gjerde, Kristian Lundby. 2019. “corporaexplorer: An R package for
> dynamic exploration of text collections.” *Journal of Open Source
> Software* 4 (38): 1342. <https://doi.org/10.21105/joss.01342>.

For a BibTeX entry, use the output from
`citation(package = "corporaexplorer")`.

## Usage

For usage instructions and example corpora, see the [package web
page](https://kgjerde.github.io/corporaexplorer/).

## Demo apps

The package includes two demo apps.

To explore Jane Austen’s novels (data accessed through the
[**janeaustenr**](https://github.com/juliasilge/janeaustenr) package):

``` r
library(corporaexplorer)
run_janeausten_app()
```

To explore the US presidents’ State of the Union addresses (data
accessed through the the
[**sotu**](https://CRAN.R-project.org/package=sotu) package):

``` r
library(corporaexplorer)
run_sotu_app()
```

For more info, see
<https://kgjerde.github.io/corporaexplorer/articles/jane_austen.html>
and <https://kgjerde.github.io/corporaexplorer/articles/sotu.html>, and
also the [function
references](https://kgjerde.github.io/corporaexplorer/reference/index.html).

## A note on platforms and encoding

**corporaexplorer** works on Mac OS, Windows and Linux, and there are
some important differences in how R handles text on the different
platforms. If you are working with plain English text, there will most
likely be no issues with encoding on any platform. Unfortunately,
working with non-[ASCII](https://en.wikipedia.org/wiki/ASCII) encoded
text in R (e.g. non-English characters), *can* be complicated – in
particular on Windows.

**On Mac OS or Linux**, problems with encoding will likely not arise at
all. If problems do arise, they can typically be solved by making the R
“locale” unicode-friendly
(e.g. `Sys.setlocale("LC_ALL", "en_US.UTF-8")`). NB! This assumes that
the text is UTF-8 encoded, so if changing the locale in this way does
not help, make sure that the text is encoded as UTF-8 characters.
Alternatively, if you can ascertain the character encoding, set the
locale correspondingly.

**On Windows**, things can be much more complicated. The most important
thing is to check carefully that the texts appear as expected in
`corporaexplorer`’s apps, and that the searches function as expected. If
there are problems, a good place to start is a blog post with the
telling title [“Escaping from character encoding hell in R on
Windows”](https://www.r-bloggers.com/2016/06/escaping-from-character-encoding-hell-in-r-on-windows/).

For (a lot) more information about encoding, see [this informative
article](https://kunststube.net/encoding/) by David C. Zentgraf.

## Contributing

Contributions in the form of feedback, bug reports and code are most
welcome. Ways to contribute:

- Contact [me](mailto:klg@nupi.no) by email.
- Issues and bug reports: [File a GitHub
  issue](https://github.com/kgjerde/corporaexplorer/issues).
- Fork the source code, modify, and issue a [pull
  request](https://docs.github.com/articles/creating-a-pull-request-from-a-fork/)
  through the [project GitHub
  page](https://github.com/kgjerde/corporaexplorer).
