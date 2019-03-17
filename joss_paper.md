---
title: 'corporaexplorer: an R package for dynamic exploration of text collections'
tags:
  - R
  - qualitative research
  - text analysis
  - corpora
  - Shiny
authors:
  - name: Kristian Lundby Gjerde
    orcid: 0000-0001-8291-6837
    affiliation: 1
affiliations:
 - name: Research Fellow, Norwegian Institute of International Affairs (NUPI)
   index: 1
date: 17 March 2019
bibliography: joss_bib.bib
---

# Background

Computer technology has profoundly changed the possibilities for doing research with text as data. Terms such as 'computational social science' [see @comp] and 'digital humanities'  [see @digitalhumanities] are now firmly established, indicative of how new methods have transformed whole fields of scholarly enquiry, enabling researchers to do things virtually unimaginable even a few years ago. For good reasons – computers excel in quantitative tasks – these advances have often been predominantly quantitatively oriented, and geared towards 'big data' of various size. Yet, developments in software and hardware have also opened up vast fields of immensely helpful -- and often unused -- possibilities for a great number of scholars engaged in various forms of *qualitative* text analysis.

# The ``corporaexplorer`` R package  

``corporaexplorer`` is an R package that uses the ``Shiny`` GUI (graphical user interface) framework for dynamic exploration of text collections, e.g. a collection of documents scraped from a governmental website or newspaper articles retrieved from a database. The intended primary audience is qualitatively oriented researchers in the social sciences and humanities who rely on close reading of textual documents as part of their academic activity -- and for whom a typical workflow often includes analysing a set of texts downloaded from a website based on keyword search in the website's internal search engine.

``corporaexplorer``'s main goal is to facilitate more powerful, transparent, rigid, and efficient workflows in these kinds of qualitative research. It aims to help researchers to conduct open-ended explorations of text collections, and to identify and extract texts for further scrutiny -- and to do this in a fast and user-friendly manner. The hope is also to encourage mixed methods in text analysis, by using ``corporaexplorer`` in  combination with the excellent R packages that are available for quantitative text analysis [for a highly useful review, see @welbers], and to encourage (where licenses so permit) sharing of text collections.

The ``corporaexplorer`` concept is simple, but has the potential to enhance many researchers' work with text collections in a powerful way. The main elements in the interactive apps include:  

* **Input**: The ability to filter the corpus and/or highlight documents based on search patterns (in main text or metadata) and date range.
* **Corpus visualisation**: An interactive calendar heat map (or alternatively a heat map with each document as base unit) of the corpus based on the search input.
* **Document visualisation and display**: Easy navigation to and within full text documents display with highlighted text.
* **Document retrieval**: Extraction of subsets of the corpus in a format suitable for close reading.  

The command line and graphical user interface of ``corporaexplorer``, as well as the packages's inner workings, are more thoroughly documented in the readme file included with the package. 

While collecting and preparing the text collections to be explored requires some R programming knowledge, using the Shiny apps for exploring and extracting documents from the corpus should be rather intuitive also for someone with no programming knowledge -- when the apps are first set up by a collaborator. Thus, the ambition is that the package should be useful for anyone with a rudimentary knowledge of R -- or who knows anyone with this knowledge.

# Main dependencies

``corporaexplorer`` is an R [@R] package.
The interactive apps are built with the ``Shiny`` [@shiny] framework.
The plots are built with ``ggplot2`` [@ggplot2].
For searches and string operations, ``stringi`` [@stringi]/``stringr`` [@stringr] and ``re2r`` [@re2r] are used (details can be found in the package documentation).
``data.table`` [@data.table] is used for fast search operations in the document term matrix.
For other data operations, functions from various ``tidyverse`` [@tidyverse] packages are used.
Other R packages utilised can be found in ``corporaexplorer``'s DESCRIPTION file.

# Acknowledgements
``corporaexplorer`` has been developed with support from the Research Council of Norway funded research project 'Evaluating Power Political Repertoires (EPOS),' project no. 250419.

# References
