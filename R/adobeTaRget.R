#' INTERNAL: Check for requisite .Renviron variables; alert if missing
#'
#' @param var (character) name of variable
#'
#' @keywords internal
checkRenviron <- function(var) {
  if(Sys.getenv(var) == "") { stop(paste0("You need to add ", var, " to .Renviron (and start a new session after doing so)"))  }
}

