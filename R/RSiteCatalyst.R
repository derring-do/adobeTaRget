#' Queue A4T Report 
#' @description
#' Uses RSiteCatalyst::QueueTrended() to get metrics for an Adobe Target AB activity that have Adobe Analytics as the reporting source (A4T)\cr
#'
#' @param activityId character
#' @param date.granularity See RSiteCatalyst::QueueTrended(); Defaults to year since that's the highest level of aggregation; if your test spans two calendar years, you'll have to aggregate
#' @param reportMeta boolean. If TRUE, appends duration and id to results of RSiteCatalyst::QueueTrended()
#' @param reportsuite.id See RSiteCatalyst::QueueTrended();
#' @param metrics See RSiteCatalyst::QueueTrended() ;
#' @param elements See RSiteCatalyst::QueueTrended() ;
#' @param ... additional arguments to RSiteCatalyst::QueueTrended()
#' @return
#' @export
#'
#' @examples
#' # Error if activity doesn't report to Adobe Analytics 
#' \dontrun{
#' QueueA4TReport(activityId = "297037", reportMeta=FALSE)
#' }
#' 
#' QueueA4TReport(activityId = "298487", reportMeta=FALSE) # reports uniquevisitors by default
#' QueueA4TReport(activityId = "298487", metrics = c("uniquevisitors", "visits"), reportMeta=FALSE) # or specify additional metrics, e.g., conversion
#' QueueA4TReport(activityId = "298487", reportMeta=TRUE) # reports uniquevisitors by default

QueueA4TReport <- function(activityId, reportsuite.id = Sys.getenv("ADOBE_REPORTSUITEID"), metrics = "uniquevisitors", elements = c("activity", "experience"), date.granularity = "year", reportMeta = TRUE, ...) {
  
  a  <- adobeTaRget::getAbActivityById(activityId)
  if(is.null(a$analytics)) {stop(sprintf("Activity %s does not report to Analytics; RSiteCatalyst cannot retrieve data.", activityId))}
  
  pr <- adobeTaRget::getAbPerformanceReport(activityId)
  if(pr$report$statistics$totals$visitor$totals$entries == 0) {stop(sprintf("Activity %s has no visitor traffic.", activityId))}
  
  ri <- adobeTaRget::getAbReportInterval(activityId)

  report <- RSiteCatalyst::QueueTrended(date.from = ri$start, date.to = ri$end, 
                                        reportsuite.id = reportsuite.id, 
                                        metrics = metrics, elements = elements, 
                                        date.granularity = date.granularity, search = adobeTaRget::getAbActivityById(activityId)$name, ...)
  
  if(nrow(report) == 0) {stop("Report contains 0 rows")}
  
  if(reportMeta) {
    report$datetime <- as.POSIXct(report$datetime)
    report$activity_duration <- ri$length
    report$activity_range <- paste0(ri$start, " to ", ri$end)
    report$activityId <- activityId
  }
  
  return(report)
}

