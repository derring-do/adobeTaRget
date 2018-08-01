#' getAudienceById
#' Wrapper for Get Audience by ID API call (http://developers.adobetarget.com/api/#get-audience-by-id)
#' @return data.frame of all activities
#' @export
#' @import httr dplyr jsonlite
#'
#' @examples getAudienceById("12345")
getAudienceById <- function(audienceId) {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- GET(paste0("https://mc.adobe.io/", Sys.getenv("ADOBE_TENANT_NAME"), "/target/audiences/", audienceId), 
           add_headers("authorization" = Sys.getenv("ADOBEIO_BEARER_TOKEN"),
                       "x-api-key" = Sys.getenv("ADOBEIO_API_KEY"),
                       "cache-control" = "no-cache",
                       "content-type" = "application/vnd.adobe.target.v1+json")
  )
  
  if(r$status_code == 200) {
    audienceDef <- content(r, "text") %>% fromJSON
    return(audienceDef) 
  } else {
    stop(r)
  }
}
