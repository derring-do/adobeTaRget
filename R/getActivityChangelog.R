#' getActivityChangelog
#'
#' @param activityId (character) activityId returned by listActivities()
#' @param activities output of listActivities
#'
#' @return data.frame of a single activity's events
#' @export
#' @import httr dplyr
#'
#' @examples getActivityChangelog("123456"); if only one supplied, you get a list instead of df
getActivityChangelog <- Vectorize(function(activityId, activities="") {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBE_BEARER_TOKEN")
  checkRenviron("ADOBEIO_API_KEY")
  r <- GET(url = paste0("https://mc.adobe.io/", Sys.getenv("ADOBE_TENANT_NAME"), "/target/activities/", activityId, "/changelog"),
           add_headers("Authorization" = paste("Bearer", Sys.getenv("ADOBE_BEARER_TOKEN")),
                       "Content-Type" = "application/vnd.adobe.target.v1+json",
                       "X-Api-Key" = Sys.getenv("ADOBEIO_API_KEY")
           )
  )
  r.parsed <- content(r, "parsed", "application/json") 
  changelog <- lapply(r.parsed$activityChangelogs, data.frame, stringsAsFactors = FALSE) %>% 
    bind_rows %>% 
    mutate(name=activities$name[activities$id == activityId],
           type=activities$type[activities$id == activityId]) 
  return(as.data.frame(changelog))
}, "activityId", SIMPLIFY=FALSE)

#' Extract start-/stop-related details from getActivityChangelog() output
#'
#' @param changelog 
#'
#' @return data.frame
#' @export
#'
#' @examples extractChangelogTiming(getActivityChangelog("12345"))
extractChangelogTiming <- function(changelog) {
  if(!("activityParameters.state.previousValue" %in% names(changelog))) { 
    warning(paste(as.data.frame(changelog)$name[1], "will be NA because it has no activityParameters.state.previousValue")) 
    NA
  } else {
    changelog %>%   
      mutate(status = paste0(activityParameters.state.previousValue, "-", activityParameters.state.changedValue)) %>%
      filter(status != "NA-NA") %>%
      select(modifiedAt, status, name)
  }
}

