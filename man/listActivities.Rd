% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/activities.R
\name{listActivities}
\alias{listActivities}
\title{List Activities}
\usage{
listActivities(encoding = "UTF-8")
}
\value{
data.frame; see \href{https://developers.adobetarget.com/api/#list-activities}{Sample Response}
}
\description{
Get a list of activities created in your Target account, with the ability to filter and sort by attributes.
\url{http://developers.adobetarget.com/api/#list-activities}
}
\examples{
exchangeJWT
listActivities()
}
