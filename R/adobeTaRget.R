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

