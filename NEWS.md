# corporaexplorer 0.7.0.9000

## Breaking API changes

* Removed `normalise` argument from `prepare_data()`
* Added `within_group_identifier` and `tile_length_range` arguments in `prepare_data()` (leading to new order of arguments)

## New functions

* Included demo apps: Jane Austen's novels and State of the Union adresses,
with data from the `janeaustenr` and `sotu` packages, respectively. See `run_janeausten_app()` and `run_sotu_app()`
* Added `directly_explore()` convenience function

## Other

* Minimum corpus plot height is again 100.

# corporaexplorer 0.7.0

## Breaking API changes

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
