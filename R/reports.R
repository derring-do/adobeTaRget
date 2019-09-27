#' Get AB Performance Report
#' @description 
#' Retrieve the performance report data for the AB activity referenced by the provided id.
#' \url{https://developers.adobetarget.com/api/#get-ab-performance-report}
#' @param activityId 
#'
#' @return json; see \href{https://developers.adobetarget.com/api/#get-ab-performance-report}{Sample Response}
#' @export
#' @import httr dplyr
#'
#' @examples getAbPerformanceReport("12345")
getAbPerformanceReport <- function(activityId, encoding = "UTF-8") {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- httr::GET(url = glue::glue("https://mc.adobe.io/{yourtenantname}/target/activities/ab/{activityId}/report/performance", 
                                  yourtenantname = Sys.getenv("ADOBE_TENANT_NAME"), 
                                  activityId = activityId), 
                 add_headers("Authorization"=  Sys.getenv("ADOBEIO_BEARER_TOKEN"),
                             "Content-Type" = "application/vnd.adobe.target.v1+json",
                             "X-Api-Key" = Sys.getenv("ADOBEIO_API_KEY")
                 )
  )
  if(r$status_code == 200) {
    report <- content(r, as="text", type="application/json", encoding) %>% jsonlite::fromJSON(simplifyVector = FALSE)
    return(report) 
  } else {
    stop(r)
  }
}