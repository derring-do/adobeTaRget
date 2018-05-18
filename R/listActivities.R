#' listActivities
#'
#' @return data.frame of all activities
#' @export
#' @import httr dplyr
#'
#' @examples listActivities()
listActivities <- function() {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBE_BEARER_TOKEN")
  checkRenviron("ADOBEIO_API_KEY")
  r <- GET(url = paste0("https://mc.adobe.io/", Sys.getenv("ADOBE_TENANT_NAME"), "/target/activities"),
           add_headers("Authorization" = paste("Bearer", Sys.getenv("ADOBE_BEARER_TOKEN")),
                       "Content-Type" = "application/vnd.adobe.target.v1+json",
                       "X-Api-Key" = Sys.getenv("ADOBEIO_API_KEY")
           )
  )
  
  activities <- content(r, "parsed", "application/json") 
  activities <- lapply(activities$activities, data.frame, stringsAsFactors = FALSE) %>% bind_rows %>% arrange(desc(modifiedAt)) 
  return(activities)
}