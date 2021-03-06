% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_data.R
\name{include_columns_for_ui_checkboxes}
\alias{include_columns_for_ui_checkboxes}
\title{Values for custom UI sidebar checkbox filtering}
\usage{
include_columns_for_ui_checkboxes(new_df, columns_for_ui_checkboxes = NULL)
}
\arguments{
\item{new_df}{A "data_dok" tibble produced by \code{transform_regular}}

\item{columns_for_ui_checkboxes}{Character. Character or factor column(s) in dataset.
Include sets of checkboxes in the app sidebar for
convenient filtering of corpus.
Typical useful for columns with a small set of unique
(and short) values.
Checkboxes will be arranged by \code{sort()},
unless \code{columns_for_ui_checkboxes}
is a vector of factors, in which case the order will be according to
factor level order (easy relevelling with \code{forcats::fct_relevel()}).
To use a different
label in the sidebar than the columnn name,
simply pass a named character vector to \code{columns_for_ui_checkboxes}.
If \code{columns_for_ui_checkboxes} includes a column which is not
present in dataset, it will be ignored.}
}
\value{
List: column_names; values. Or NULL.
}
\description{
Values for custom UI sidebar checkbox filtering
}
\keyword{internal}
