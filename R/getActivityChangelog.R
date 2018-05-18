#' getActivityChangelog
#'
#' @param activityId (character) activityId returned by listActivities()
#'
#' @return data.frame of a single activity's events
#' @export
#' @import httr dplyr
#'
#' @examples getActivityChangelog("123456")
getActivityChangelog <- function(activityId) {
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
  changelog <- lapply(r.parsed$activityChangelogs, data.frame, stringsAsFactors = FALSE) %>% bind_rows
  return(changelog)
}
