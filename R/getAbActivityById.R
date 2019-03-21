#' Get AB Activity by ID
#' Wrapper for Get AB Activity by ID API call 
#' Fetch the current definition of an AB activity if it is found as referenced by the id.
#' http://developers.adobetarget.com/api/#get-ab-activity-by-id
#'
#' @param activityId 
#'
#' @return json
#' @export
#' @import httr dplyr
#'
#' @examples getAbActivityById("12345")
getAbActivityById <- function(activityId) {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- httr::GET(url = glue::glue("https://mc.adobe.io/{yourtenantname}/target/activities/ab/{activityId}", 
                                  yourtenantname = Sys.getenv("ADOBE_TENANT_NAME"), 
                                  activityId = activityId), 
                 add_headers("authorization" = Sys.getenv("ADOBEIO_BEARER_TOKEN"),
                             "Accept" = "application/vnd.adobe.target.v3+json",
                             "X-Api-Key" = Sys.getenv("ADOBEIO_API_KEY")
                 )
  )
  if(r$status_code == 200) {
    report <- content(r, as="text", type="application/json") %>% jsonlite::fromJSON(simplifyVector = FALSE)
    return(report) 
  } else {
    stop(r)
  }
}
