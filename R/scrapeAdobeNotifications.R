#' [DEPRECATED] Scrape Adobe Experience Cloud notification feed for start and complete times
#'
#' NOTE: The feed doesn't pick up on activity name changes because there is no unique ID persisted
#' Only try this if you can't get the System Admin privileges to use the API
#'
#' @param useDocker boolean 
#' @param feed_scraper_js path to javascript file to scrape feed
#'
#' @return data.frame
#' @import RSelenium 
#' @export
#'
#' @examples tests <- testCalendar(useDocker=FALSE)
scrapeAdobeNotifications <- function(useDocker=TRUE, feed_scraper_js=dir(path.package("adobeTaRget"), pattern= "feed2.js", full.names = TRUE)) {
  if(useDocker == TRUE) {
    # shell("docker pull selenium/standalone-chrome")
    shell("docker run --rm -d -p 4445:4444 selenium/standalone-chrome")
    docker.container.id <- gsub(" ", "", strsplit(shell("docker ps -a", intern = TRUE)[2], "selenium")[[1]][1])

    remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome")
    remDr$open()
  } else {
    rD <- rsDriver(browser = c("chrome"))
    remDr <- rD[['client']]
  }

  # Login
  remDr$navigate("https://hbr.marketing.adobe.com")
  if(remDr$getTitle()[[1]] != "Adobe Experience Cloud") { stop("Page title != Adobe Experience Cloud; fields to scrape may have changed.") }

  loginButton <- remDr$findElement(using = "css", value = paste0("button[id='mac-ims-login']"))
  loginButton$clickElement()
  Sys.sleep(2)
  if(remDr$getTitle()[[1]] != "Sign in - Adobe ID") { stop("Page title != Sign in - Adobe ID; fields to scrape may have changed.") }

  username <- remDr$findElement(using = "css", value = "input[id='adobeid_username']")
  username$sendKeysToElement(list(Sys.getenv("ADOBE_CLOUD_EMAIL")))
  if(remDr$findElement(using = "css selector", value = "input[id='adobeid_username']")$getElementAttribute("value")[[1]][1] == "") { stop("username input failed") }

  body <- remDr$findElement(using = "css", value = "body")  # key out of username input so it will accept pw
  body$clickElement()
  Sys.sleep(2)

  pw <- remDr$findElement(using = "css", value = "input[id='adobeid_password']")
  pw$sendKeysToElement(list(Sys.getenv("ADOBE_CLOUD_PW")))
  if(remDr$findElement(using = "css", value = "input[id='adobeid_password']")$getElementAttribute("value")[[1]][1] == "") { stop("password input failed") }

  remDr$findElement(using = "css", value = paste0("button[id='sign_in']"))$clickElement()
  Sys.sleep(2)
  if(remDr$getTitle()[[1]] != "Experience Cloud Feed") { stop("Page title != Experience Cloud Feed; failed to advance from sign-in") }

  # Go to feed
  remDr$navigate("https://hbr.marketing.adobe.com/notifications.html")
  Sys.sleep(2)
  if(remDr$getTitle()[[1]] != "Notifications") { stop("Page title != Notifications; failed to navigate") }

  # Scroll to bottom, clicking LOAD MORE along the way until you get to the earliest known item
  scrollDown <- function() {
    webElem <- remDr$findElement(using = "css", value = "body")
    webElem$clickElement()
    webElem$sendKeysToElement(list(key = "end"))
    message(try(remDr$executeScript("return document.querySelector(\"div[class='notifications ng-scope']\").children.length", args=list(webElem))))
  }

  while(remDr$executeScript("return typeof(document.querySelector(\"div[mac-time-ago='2017-02-08T02:00:05.205Z']\")) && document.querySelector(\"div[mac-time-ago='2017-02-08T02:00:05.205Z']\") != null",
                      args=list("dummy"))[[1]][1]==FALSE) {
    replicate(10, scrollDown())
    try(remDr$findElement(using = "css", value = paste0("button[class*='loadMoreButton']"))$clickElement())
    Sys.sleep(1)
  }

  # Expand all the things
  remDr$executeScript("for(var boxes = document.querySelectorAll(\"div[class=\'notification-group-header omegaEvent\']\"), i = 0; i < boxes.length; i++) {
    boxes[i].click()}", args = list("dummy"))  # give this a second to take
  # for(var boxes = document.querySelectorAll("div[class='notification-group-header omegaEvent']"), i = 0; i < boxes.length; i++) { boxes[i].click() }
  Sys.sleep(5)
  if(remDr$executeScript("return document.querySelectorAll('div.cardBody').length", args = list("dummy"))[[1]][1] < 157 ) { stop("Expand failed") }

  # Scrape all the info
  script <- paste0(readLines(feed_scraper_js, warn = FALSE), collapse = "\n")
  feedBody <- remDr$findElement(using = "css selector", value = "body")
  feed <- remDr$executeScript(script, args = list(feedBody))

  if(useDocker == TRUE) {
    remDr$close()
    shell("docker container kill" %>% paste(docker.container.id))
    # shell("docker rm" %>% paste(docker.container.id))
  } else {
      rD$server$stop()
    }

  bind_rows(lapply(feed, data.frame, stringsAsFactors = FALSE)) %>%
    filter(grepl("A/B Test|Experience Targeting", titleStatus)) %>%
    separate("titleStatus", into = c("title", "status"), " activity was ")
}
