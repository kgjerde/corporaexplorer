# corporaexplorer 0.8.4.9000

* re2 regex engine again included, now using the 're2' package. Thank you, @girishji!
See https://github.com/girishji/re2  
* Small UI fixes

# corporaexplorer 0.8.4

* Fixed bug where time selection slider widget in calendar view did not work (#25)

# corporaexplorer 0.8.3

* Fixed bugs and warning messages caused by changes in other packages (tibble and dplyr).
* Fixed special case of warnings occurring when visualising documents with zero hits (2270046)
* Changed the way colours are represented in document visualisation (63b3857)

# corporaexplorer 0.8.2

## re2r regex engine disabled
* Because 're2r' will be removed/archived by the CRAN maintainers.
See https://github.com/qinwf/re2r/issues/22.

## Other

* the apps now allow any mix of whitespace in input terms

# corporaexplorer 0.8.1.1

## New arguments

* Added `columns_for_ui_checkboxes` argument to prepare_data() in order to include
sidebar checkboxes for convenient filtering by categorical variable/column (not necessarily factor type, but most helpful when limited number of values in the variable) in the explorer app (`explore()`).

## Other

* Removed dependencies on packages forcats, shinycssloaders, and zoo.
* Fixed reactive issue leading to plots rendering twice when size was different from previous plot (now one has to click button to update plot size).
* Other minor bug fixes.
* Internal changes related to extension packages.

# corporaexplorer 0.8.0

## Breaking API changes

* **`run_corpus_explorer()` is deprecated and replaced with `explore()`.**
  + `explore()` works in the precise same way as `run_corpus_explorer()`, but is faster to type and makes a nice pair with the new `explore0()` function (see below).
  + `run_corpus_explorer()` still works (as a thin wrapper to `explore()`),
but yields a warning.
* Removed `normalise` argument from `prepare_data()`
* Added `within_group_identifier` and `tile_length_range` arguments in `prepare_data()` (leading to new order of arguments)

## New function

* Added `explore0()`, a convenience function to directly explore a data frame
or character vector without first creating a 'corporaexplorerobject'
with `prepare_data()`.

## Demo apps

* Included demo apps: Jane Austen's novels and State of the Union addresses,
with data from the `janeaustenr` and `sotu` packages, respectively. See `run_janeausten_app()` and `run_sotu_app()`

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
