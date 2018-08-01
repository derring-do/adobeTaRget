#' listActivities
#' Wrapper for List Activities API call (http://developers.adobetarget.com/api/#list-activities)
#' @return data.frame of all activities
#' @export
#' @import httr dplyr
#'
#' @examples listActivities()
listActivities <- function() {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- GET(url = paste0("https://mc.adobe.io/", Sys.getenv("ADOBE_TENANT_NAME"), "/target/activities"),
           add_headers("Authorization" = Sys.getenv("ADOBEIO_BEARER_TOKEN"),
                       "Content-Type" = "application/vnd.adobe.target.v1+json",
                       "X-Api-Key" = Sys.getenv("ADOBEIO_API_KEY")
           )
  )
  if(r$status_code == 200) {
    activities <- content(r, "parsed", "application/json") 
    activities <- lapply(activities$activities, data.frame, stringsAsFactors = FALSE) %>% bind_rows %>% arrange(desc(modifiedAt)) 
    return(activities) 
  } else {
    stop(r)
  }
}



