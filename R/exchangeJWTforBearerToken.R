
#' Exchange JWT for Bearer token (POST)
#' Wrapper for Adobe IO API call
#' @return Bearer token that works for 24 hours and is to be used in all the Target API calls
#' @export
#' @import httr 
#'
#' @examples exchangeJWTforBearerToken()
exchangeJWTforBearerToken <- function() {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_JWT_TOKEN")
  r <- POST(url = "https://ims-na1.adobelogin.com/ims/exchange/jwt", 
            body = list("client_id"=Sys.getenv("ADOBEIO_API_KEY"),
                        "client_secret"=Sys.getenv("ADOBEIO_CLIENT_SECRET"),
                        "jwt_token"=Sys.getenv("ADOBEIO_JWT_TOKEN")
                        )
            )
  if(r$status_code == 200) {
    Sys.setenv(ADOBEIO_BEARER_TOKEN=paste0("Bearer ", content(r)$access_token))
    message("ADOBEIO_BEARER_TOKEN set for current R session")
  } else {
    stop(r)
  }
}

