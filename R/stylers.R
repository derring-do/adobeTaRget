
#' Extract start-/stop-related details from getActivityChangelog() output
#'
#' @param changelog 
#'
#' @return data.frame
#' @export
#'
#' @examples 
#' extractChangelogTiming(getActivityChangelog("298487"))
extractChangelogTiming <- function(changelog) {
  if(!("activityParameters.state.previousValue" %in% names(changelog))) { 
    warning(paste(as.data.frame(changelog)$name[1], "will be NA because it has no activityParameters.state.previousValue")) 
    NA
  } else {
    changelog %>%   
      mutate(status = paste0(activityParameters.state.previousValue, "-", activityParameters.state.changedValue)) %>%
      filter(status != "NA-NA") %>%
      select(modifiedAt, startsAt, endsAt, status, name, type, id)
  }
}

