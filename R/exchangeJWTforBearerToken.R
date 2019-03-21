
#' Exchange JWT for Bearer token (POST)
#' Wrapper for Adobe IO API call
#' @return Bearer token that works for 24 hours and is to be used in all the Target API calls
#' @export
#' @import reticulate 
#'
#' @examples exchangeJWTforBearerToken()
exchangeJWTforBearerToken <- function(path.to.config = Sys.getenv("ADOBEIO_CONFIG_PATH"), path.to.pem = Sys.getenv("ADOBEIO_PEM_PATH")) {
  reticulate::py_run_file(dir(path.package("adobeTaRget"), "ExchangeJWT", full.names=TRUE))  # source function
  py$ExchangeJWT(path.to.config, path.to.pem)
  Sys.setenv("ADOBEIO_BEARER_TOKEN" = paste0("Bearer " , ini::read.ini(path.to.config)$enterprise$access_token))
  if( !is.null(Sys.getenv("ADOBEIO_BEARER_TOKEN")) ) {
    message("ADOBEIO_BEARER_TOKEN set")
  }
  }
