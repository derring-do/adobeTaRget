#' Get AB Performance Report
#' Wrapper for Get AB Performance Report API call 
#'
#' @param activityId 
#'
#' @return json
#' @export
#' @import httr dplyr
#'
#' @examples getAbPerformanceReport("12345")
getAbPerformanceReport <- function(activityId) {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- httr::GET(url = glue::glue("https://mc.adobe.io/{yourtenantname}/target/activities/ab/{activityId}/report/performance", 
                                  yourtenantname = Sys.getenv("ADOBE_TENANT_NAME"), 
                                  activityId = activityId), 
                 add_headers("Authorization" = Sys.getenv("ADOBEIO_BEARER_TOKEN"),
                             "Content-Type" = "application/vnd.adobe.target.v1+json",
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