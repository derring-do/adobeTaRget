#' List Offers
#' @description 
#' Retrieve the list of previously-created content offers.
#' \url{https://developers.adobetarget.com/api/#list-offers}
#' @return data.frame of all activities; see \href{https://developers.adobetarget.com/api/#list-offers}{Sample Response}
#' @export
#' @import httr dplyr jsonlite
#'
#' @examples 
#' listOffers()
listOffers <- function() {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- GET(url = paste0("https://mc.adobe.io/", Sys.getenv("ADOBE_TENANT_NAME"), "/target/offers"),
           adobe_target_api_headers(api.version="v2")
  )
  if(r$status_code == 200) {
    offers <- (content(r, "text") %>% fromJSON)$offers %>% data.frame
    return(offers) 
  } else {
    stop(r)
  }
}

#' Get Offer by ID
#' @description 
#' Retrieves the contents of an offer given an offer id (usually HTML)
#' \url{https://developers.adobetarget.com/api/#get-offer-by-id}
#' @param offerId 
#' @return json; see \href{https://developers.adobetarget.com/api/#get-offer-by-id}{Sample Response}
#' @export
#' @import httr dplyr
#'
#' @examples getOfferById("483105")
getOfferById <- function(offerId) {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- httr::GET(url = glue::glue("https://mc.adobe.io/{yourtenantname}/target/offers/content/{offerId}", 
                                  yourtenantname = Sys.getenv("ADOBE_TENANT_NAME"), 
                                  offerId = offerId), 
                 adobe_target_api_headers(api.version="v2")
  )
  if(r$status_code == 200) {
    report <- content(r, as="text", type="application/json") %>% jsonlite::fromJSON(simplifyVector = FALSE)
    return(report) 
  } else {
    stop(r)
  }
}

#' Update Offer by ID
#' @description 
#' Updates the content offer referenced by the id specified in the URL.
#' \url{https://developers.adobetarget.com/api/#update-offer-by-id}
#' @param offerId 
#'
#' @return
#' @export
#'
#' @examples
#' updateOfferById(offerId="535745", offerName="asdf", updatedContent="<b>asdf</b>")

updateOfferById <- function(offerId, offerName, updatedContent, api.version = "v2") {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  
  r <- httr::PUT(url = glue::glue("https://mc.adobe.io/{yourtenantname}/target/offers/content/{offerId}",
                                  yourtenantname = Sys.getenv("ADOBE_TENANT_NAME"),
                                  offerId = offerId),
                 config = c(adobe_target_api_headers(api.version=api.version),
                            content_type(paste0("application/vnd.adobe.target.", api.version, "+json"))
                 ),
                 body = jsonlite::toJSON(list(name=offerName, content=updatedContent), auto_unbox = TRUE)
  )
  if(r$status_code == 200) {
    report <- content(r, as="text", type="application/json") %>% jsonlite::fromJSON(simplifyVector = FALSE)
    return(report) 
  } else {
    stop(r)
  }
}
