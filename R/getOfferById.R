#' Get Offer by ID
#' Wrapper for Get Audience by ID API call 
#' Retrieves the contents of an offer given an offer id.
#' http://developers.adobetarget.com/api/#list-offers
#' @param offerId 
#' @return json
#' @export
#' @import httr dplyr
#'
#' @examples getOfferById("12345")
getOfferById <- function(offerId) {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- httr::GET(url = glue::glue("https://mc.adobe.io/{yourtenantname}/target/offers/content/{offerId}", 
                                  yourtenantname = Sys.getenv("ADOBE_TENANT_NAME"), 
                                  offerId = offerId), 
                 add_headers("authorization" = Sys.getenv("ADOBEIO_BEARER_TOKEN"),
                             "Accept" = "application/vnd.adobe.target.v2+json",
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
