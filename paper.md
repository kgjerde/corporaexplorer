---
title: 'corporaexplorer: An R package for dynamic exploration of text collections'
tags:
- qualitative research
- mixed methods
- text analysis
- corpora
- R
- Shiny
authors:
  - name: Kristian Lundby Gjerde
    orcid: 0000-0001-8291-6837
    affiliation: 1
affiliations:
 - name: Research Fellow, Norwegian Institute of International Affairs (NUPI)
   index: 1
date: 17 May 2019
bibliography: joss_bib.bib
---

# Background

Computer technology has profoundly changed the possibilities for doing research with text as data. Terms such as ‘computational social science’ [see @comp] and ‘digital humanities’ [see @digitalhumanities] are now firmly established, indicating how new methods have transformed entire fields of scholarly enquiry, enabling researchers to do things unimaginable even a few years ago. For good reasons -- computers excel in quantitative tasks -- these advances have been predominantly quantitatively oriented, geared towards ‘big data’ of various sizes. However, developments in software and hardware have also opened up vast fields of immensely helpful -- and often untapped -- possibilities for many scholars engaged in various forms of *qualitative* text analysis.

# The ``corporaexplorer`` R package  

``corporaexplorer`` is an R package that uses the ``Shiny`` GUI (graphical user interface) framework for dynamic exploration of text collections. The package is designed for use with a wide range of text collections; one example could be a collection of tens of thousands of documents scraped from a governmental website; another example could be the collected works of a novelist; a third example could be the chapters of a single book.

The intended primary audience are qualitatively oriented researchers in the social sciences and humanities who rely on close reading of textual documents as part of their academic activity. However, the package should also be useful for those doing quantitative textual research and wishing to have convenient access to the texts under study. The chief aim of ``corporaexplorer`` is to facilitate more powerful, transparent, and efficient workflows. While a typical use case would be an open-ended exploration of text collections in order to identify and extract texts for further scrutiny, the package is above all aimed at flexibility: it does not enforce any given workflow, but may play a small or larger role in many different research designs.

The intention is also to encourage mixed methods in text analysis, by using  ``corporaex-plorer`` in combination with the excellent R packages that are available for quantitative text analysis [for a highly useful review, see @welbers], and to encourage (licences permitting) the sharing of text collections. 

The ``corporaexplorer`` concept is simple, yet has the potential to enhance research work with text collections in a powerful way. Main elements in the interactive apps:

* **Input**: The ability to filter the corpus and/or highlight documents, based on search patterns (in main text or metadata, including date range).
* **Corpus visualisation**: An interactive heat-map of the corpus, based on the search input (calendar heat-map or heat-map where each tile represents one document, optionally grouped by metadata properties).
* **Document visualisation and display**: Easy navigation to and within full-text documents with pattern matches highlighted.
* **Document retrieval**: Extraction of subsets of the corpus in a format suitable for close reading.

The API and GUI of ``corporaexplorer``, as well as the inner workings of the package, are documented more thoroughly in the README file included with the package.

While collecting and preparing the text collections to be explored requires some familiarity with R programming, using the Shiny apps for exploring and extracting documents from the corpus should be fairly intuitive also for those with no programming knowledge, once the apps have been set up by a collaborator. Thus, the aim is for the package to be useful for anyone with a rudimentary knowledge of R -- or with collaborators who have such knowledge.

\bigskip
\begin{figure}[!tbh]
\centering
\includegraphics{man/figures/paper_illustration.png}
\caption{Illustration screenshots. To the left: part of interactive
corpus heat-map displaying occurences of Moses and Abraham in the
\emph{King James Bible}. In the middle: part of interactive corpus
calendar heat-map displaying occurences of `orthodox' in a collection of
transcripts from the Russian president's website. To the right: document
view with interactive document map and highlighted pattern matches.}
\end{figure}



# Main dependencies

``corporaexplorer`` is an R [@R] package.
The interactive apps are built with the ``Shiny`` [@shiny] framework.
The plots are built with ``ggplot2`` [@ggplot2].
For searches and string operations, ``stringi`` [@stringi]/``stringr`` [@stringr] and ``re2r`` [@re2r] are used (details can be found in the package documentation).
``data.table`` [@data.table] is used for fast search operations in the document term matrix.
For other data operations, functions from various ``tidyverse`` [@tidyverse] packages are used.
Other R packages utilised can be found in ``corporaexplorer``'s DESCRIPTION file.

# Acknowledgements
``corporaexplorer`` has been developed with support from the research project ‘Evaluating Power Political Repertoires (EPOS)’ (project no. 250419), funded by the Research Council of Norway.

# References
