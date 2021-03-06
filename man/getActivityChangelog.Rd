% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/activities.R
\name{getActivityChangelog}
\alias{getActivityChangelog}
\title{Get Activity Changelog}
\usage{
getActivityChangelog(activityId, activities, encoding = "UTF-8")
}
\arguments{
\item{activityId}{(character) activityId returned by \code{\link{listActivities}}}

\item{activities}{output of listActivities}
}
\value{
data.frame of a single activity's events; see \href{https://developers.adobetarget.com/api/#get-activity-changelog}{Sample Response}
}
\description{
Returns the changelog for a given activity id.
\url{https://developers.adobetarget.com/api/#get-activity-changelog}
}
\examples{
getActivityChangelog("298487", activities) # if only one supplied, you get a list instead of df
}
