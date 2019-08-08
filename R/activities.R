#' List Activities
#' @description 
#' Get a list of activities created in your Target account, with the ability to filter and sort by attributes.
#' \url{http://developers.adobetarget.com/api/#list-activities}
#' @return data.frame; see \href{https://developers.adobetarget.com/api/#list-activities}{Sample Response}
#' @export
#' @import httr dplyr
#'
#' @examples 
#' exchangeJWT
#' listActivities()
listActivities <- function() {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- GET(url = paste0("https://mc.adobe.io/", Sys.getenv("ADOBE_TENANT_NAME"), "/target/activities"),
           adobe_target_api_headers()
  )
  if(r$status_code == 200) {
    activities <- content(r, "parsed", "application/json") 
    activities <- lapply(activities$activities, data.frame, stringsAsFactors = FALSE) %>% bind_rows %>% arrange(desc(modifiedAt)) 
    return(activities) 
  } else {
    stop(r)
  }
}

#' Get AB Activity by ID
#' @description 
#' Fetch the current definition of an AB activity if it is found as referenced by the id.
#' \url{http://developers.adobetarget.com/api/#get-ab-activity-by-id}
#'
#' @param activityId 
#'
#' @return json; see \href{https://developers.adobetarget.com/api/#get-ab-activity-by-id}{Sample Response}
#' @export
#' @import httr dplyr
#'
#' @examples 
#' getAbActivityById("298487")
getAbActivityById <- function(activityId) {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- httr::GET(url = glue::glue("https://mc.adobe.io/{yourtenantname}/target/activities/ab/{activityId}", 
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

#' Get AB Report Interval from Adobe Target getAbPerformanceReport()
#' @description 
#' Wrapper for getAbPerformanceReport adobeTaRget/Adobe Target API call (specifically reportInterval value)
#' Calculates duration for later
#'
#' @param activityId
#'
#' @return
#' @export
#'
#' @examples
getAbReportInterval <- function(activityId) {
  reportInterval <- adobeTaRget::getAbPerformanceReport(activityId)$reportParameters$reportInterval
  test_start  <- reportInterval %>% strsplit("/") %>% unlist %>% first %>% as.Date()
  test_end    <- reportInterval %>% strsplit("/") %>% unlist %>% last %>% as.Date()
  list(start = test_start, end = test_end, length = as.numeric(test_end-test_start))
  return(reportInterval)
}


#' Get Activity Changelog
#' @description 
#' Returns the changelog for a given activity id.
#' \url{https://developers.adobetarget.com/api/#get-activity-changelog}
#' @param activityId (character) activityId returned by \code{\link{listActivities}}
#' @param activities output of listActivities
#'
#' @return data.frame of a single activity's events; see \href{https://developers.adobetarget.com/api/#get-activity-changelog}{Sample Response}
#' @export
#' @import httr dplyr
#'
#' @examples 
#' getActivityChangelog("298487", activities) # if only one supplied, you get a list instead of df
getActivityChangelog <- Vectorize(function(activityId, activities) {
  checkRenviron("ADOBE_TENANT_NAME")
  checkRenviron("ADOBEIO_API_KEY")
  checkRenviron("ADOBEIO_BEARER_TOKEN")
  r <- GET(url = paste0("https://mc.adobe.io/", Sys.getenv("ADOBE_TENANT_NAME"), "/target/activities/", activityId, "/changelog"),
           adobe_target_api_headers(api.version = "v1")  # v3 doesn't work
  )
  
  if(r$status_code == 200) {
    r.parsed <- content(r, "parsed", "application/json") 
    
    changelog <- lapply(r.parsed$activityChangelogs, data.frame, stringsAsFactors = FALSE) %>% 
      bind_rows %>% 
      mutate(id=activityId,
             name=activities$name[activities$id == activityId],
             type=activities$type[activities$id == activityId],
             startsAt=activities$startsAt[activities$id == activityId],
             endsAt=activities$endsAt[activities$id == activityId]
      ) 
    return(as.data.frame(changelog))
  } else {
    stop(r)
  }
}, "activityId", SIMPLIFY=FALSE)



