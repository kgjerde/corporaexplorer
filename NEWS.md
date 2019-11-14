# corporaexplorer 0.6.3.9000

## API changes

* Added `search_options` argument to `run_corpus_explorer()`, and moved the
arguments
`use_matrix`,
`regex_engine`,
`optional_info`,
`allow_unreasonable_patterns`
there.
* Added `plot_options` argument (with several possibilities to
customise plot colours etc.) to `run_corpus_explorer()`,
and moved the `max_docs_in_wall_view` setting there.

## Other

* Greatly simplified deployment to Shiny Server and shinyapps.io etc. (#19). See [article](https://kgjerde.github.io/corporaexplorer/articles/deployment.html) on the package website.
* Improved app experience on small screens (avoiding cluttering of ui elements).
* Updated LICENSE file with license for jQuery.scrollTo.
* Plot minimum height set to 50.
* Minor app CSS twitches.

# corporaexplorer 0.6.3

## API changes

* Add `ui_options` argument to run_corpus_explorer().
* Add `search_input` argument to run_corpus_explorer().

## Bug fixes

* Print method for corporaexplorerobject now works properly
* Open but empty "Filter corpus" field no longer disables time filtering

## Other

* Documentation moved to https://kgjerde.github.io/corporaexplorer
