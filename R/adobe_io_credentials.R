#' Check for requisite .Renviron variables; alert if missing
#'
#' @param var (character) name of variable
#'
#'
#' @param var 
#'
#' @return Error message if .Renviron not set
#' @export
#'
#' @examples checkRenviron("API_KEY")
checkRenviron <- function(var) {
  if(Sys.getenv(var) == "") { stop(paste0("You need to add ", var, " to .Renviron (and start a new session after doing so)"))  }
}

#' Install Adobe IO credentials in a .config file and .Renviron for repeated use
#' ripped from ropensci/Qualtrics pkg (will cite properly)
#' @param ims_host 
#' @param ims_endpoint_jwt 
#' @param org_id 
#' @param api_key 
#' @param client_secret 
#' @param tech_acct 
#' @param priv_key_filename 
#' @param ADOBE_TENANT_NAME 
#' @param ADOBEIO_CONFIG_PATH 
#'
#' @return
#' @export
#'
#' @examples
#' set_adobe_io_credentials(ims_host = "xxx", 
#' ims_endpoint_jwt = "xxx",
#' org_id = "xxx",
#' api_key = "xxx",
#' client_secret = "xxx",
#' tech_acct = "xxx",
#' priv_key_filename = "xxx",
#' ADOBE_TENANT_NAME = "xxx",
#' ADOBEIO_CONFIG_PATH = "xxx"
#' )
#' 
#' set_adobe_io_credentials(ims_host = "asdf", 
#' ims_endpoint_jwt = "xxx",
#' org_id = "xxx",
#' api_key = "xxx",
#' client_secret = "xxx",
#' tech_acct = "xxx",
#' priv_key_filename = "xxx",
#' ADOBE_TENANT_NAME = "xxx",
#' ADOBEIO_CONFIG_PATH = "xxx",
#' overwrite=TRUE,
#' install=TRUE)
set_adobe_io_credentials <- function(ims_host, 
                                 ims_endpoint_jwt,
                                 org_id,
                                 api_key,
                                 client_secret,
                                 tech_acct_id,
                                 priv_key_filename,
                                 ADOBE_TENANT_NAME,
                                 ADOBEIO_CONFIG_PATH,
                                 overwrite=FALSE,
                                 install=FALSE
                                 ) {
    argsList <- as.list(match.call())[-1]
    argsList <- argsList[which(!grepl("adobe_io_credentials|overwrite|install", names(argsList)))]
    names(argsList) <- paste0("adobe_io_", names(argsList))
  
    if (install) {
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    if (file.exists(renv)) {
      # Backup original .Renviron before doing anything else here.
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if (!file.exists(renv)) {
      file.create(renv)
    }
    else {
      if (isTRUE(overwrite)) {
        message("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")
        oldenv <- readLines(renv)
        newenv <- oldenv[!grepl("^adobe_io_", oldenv)]
        writeLines(newenv, renv)  # remove previous entries (will append new later)
      }
      else {
        tv <- readLines(renv)
        if (any(grepl("^adobe_io_", tv))) {
          stop("Credentials already exist. You can overwrite them with the argument overwrite=TRUE", call. = FALSE)
        }
      }
    }
    
    # Append to .Renviron file
    write(paste0(names(argsList), "=", argsList, collapse = "\n"), renv, append = TRUE)
    
    } else {
      do.call(Sys.setenv, argsList)
      message("Credentials set for this session. To install your credentials for use in future sessions, run this function with `install=TRUE`.")
    }
}
  
#' Create temporary .config file for ExchangeJWT.py using variables set in adobe_io_credentials()
#'
#' @return
#' @export
#' @import ini 
#'
#' @examples
#' make_exchange_jwt_config()
make_exchange_jwt_config <- function() {
  configFile <- tempfile(fileext = ".config")
  configText <- list()
  configText[["server"]] <- list(ims_host = Sys.getenv("adobe_io_ims_host"),
                                 ims_endpoint_jwt = Sys.getenv("adobe_io_ims_endpoint_jwt"))
  
  configText[["enterprise"]] <- list(org_id = Sys.getenv("adobe_io_org_id"),
                                     api_key = Sys.getenv("adobe_io_api_key"),
                                     client_secret = Sys.getenv("adobe_io_client_secret"),
                                     tech_acct = Sys.getenv("adobe_io_tech_acct_id"),
                                     priv_key_filename = Sys.getenv("adobe_io_priv_key_filename"))
  
  ini::write.ini(configText, configFile)
  Sys.setenv("ADOBEIO_CONFIG_PATH"=normalizePath(configFile, winslash = "/"))
}

#' Exchange JWT for Bearer token (POST)
#' Wrapper for Adobe IO API call
#' Writes Bearer token to the config file; write bearer token to renviron
#' 
#' @param secret.pem.path 
#'
#' @return Bearer token that works for 24 hours needed for all Target API calls
#' @export
#' @import reticulate ini
#'
#' @examples exchangeJWTforBearerToken()
exchangeJWTforBearerToken <- function(
  secret.pem.path = Sys.getenv("adobe_io_priv_key_filename")
  ) {
  make_exchange_jwt_config()
  config.path <- Sys.getenv("ADOBEIO_CONFIG_PATH")
  reticulate::py_run_file(dir(path.package("adobeTaRget"), "ExchangeJWT", full.names=TRUE))  # source function
  
  reticulate::py$ExchangeJWT(config.path, secret.pem.path)
  
  Sys.setenv("ADOBEIO_BEARER_TOKEN" = paste0("Bearer " , ini::read.ini(config.path)$enterprise$access_token))
  if(!is.null(Sys.getenv("ADOBEIO_BEARER_TOKEN")) ) {
    message("ADOBEIO_BEARER_TOKEN set")
    message(paste(substr(Sys.getenv("ADOBEIO_BEARER_TOKEN"), 1, 15), "... (truncated)"))
  }
}

#' Format standard headers for Adobe Target API calls
#'
#' @return
#' @export
#' @import httr
#' @examples
#' adobe_target_api_headers()
adobe_target_api_headers <- function(api.version="v3") {
  httr::add_headers(
    "authorization" = Sys.getenv("ADOBEIO_BEARER_TOKEN"),
    "cache-control" = "no-cache",
    "Accept" = paste0("application/vnd.adobe.target.", api.version, "+json"),
    "x-api-key" = Sys.getenv("adobe_io_api_key")
  )
}
