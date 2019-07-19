#' List Audiences
#' @description 
#' List all available audiences with options to filter and sort by each available field.
#' http://developers.adobetarget.com/api/#list-audiences
#' @return data.frame of all audiences; see [Sample Response](https://developers.adobetarget.com/api/#list-audiences)
#' @export
#' @import httr dplyr jsonlite
#'
#' @examples 
#' listAudiences()
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

#' Get Audience by ID
#' @description 
#' Get the audience definition specified by the provided id.
#' https://developers.adobetarget.com/api/#get-audience-by-id
#' @param audienceId 
#'
#' @return json; see [Sample Response](https://developers.adobetarget.com/api/#get-audience-by-id)
#' @export
#' @import httr dplyr
#'
#' @examples 
#' getAudienceById("3245850")
getAudienceById <- function(audienceId) {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- httr::GET(url = glue::glue("https://mc.adobe.io/{yourtenantname}/target/audiences/{audienceId}", 
                                  yourtenantname = Sys.getenv("ADOBE_TENANT_NAME"), 
                                  activityId = activityId), 
                 adobe_target_api_headers()
  )
  if(r$status_code == 200) {
    report <- content(r, as="text", type="application/json") %>% jsonlite::fromJSON(simplifyVector = FALSE)
    return(report) 
  } else {
    stop(r)
  }
}