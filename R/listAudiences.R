#' listAudiences
#' Wrapper for List Audiences API call (http://developers.adobetarget.com/api/#list-audiences)
#' @return data.frame of all activities
#' @export
#' @import httr dplyr jsonlite
#'
#' @examples listAudiences()
listAudiences <- function() {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- GET(url = paste0("https://mc.adobe.io/", Sys.getenv("ADOBE_TENANT_NAME"), "/target/audiences"),
           add_headers("Authorization" = Sys.getenv("ADOBEIO_BEARER_TOKEN"),
                       "Content-Type" = "application/vnd.adobe.target.v1+json",
                       "X-Api-Key" = Sys.getenv("ADOBEIO_API_KEY")
           )
  )
  if(r$status_code == 200) {
    audiences <- (content(r, "text") %>% fromJSON)$audiences %>% data.frame
    return(audiences) 
  } else {
    stop(r)
  }
}
