adobeTaRget
================
derring-do
2019-08-08

## Prerequisites

<details>

<summary>Adobe IO API Configuration</summary>

1.  Get System Admin rights for Adobe IO

2.  Generate public certificate and private key per
    <https://helpx.adobe.com/in/marketing-cloud-core/kb/adobe-io-authentication-step-by-step.html>:
    
      - Generate `secret.pem` and `certificate.pem` via:
        
        ``` bash
        openssl req -nodes -text -x509 -newkey rsa:2048 -keyout secret.pem -out certificate.pem -days 356
        ```
    
      - Convert `secret.key` to `secret.pem` via:
        
        ``` bash
        openssl pkcs8 -topk8 -inform PEM -outform DER -in secret.pem -nocrypt > secret.key
        ```

3.  Set up New Integration in Adobe IO: Go to <https://console.adobe.io>
    \> “New Integration” \> “Access and API” \> select Adobe Solution
    (Target) \> Enter Integration details \> Upload `certificate.pem`

4.  Use `adobeTaRget::set_adobe_io_credentials()` to set credentials —
    or manually populate .Renviron with the following from the IO
    Console and the directory where you saved secret.pem:
    
        adobe_io_ims_host = ims-na1.adobelogin.com
        adobe_io_ims_endpoint_jwt = /ims/exchange/jwt
        adobe_io_org_id = xxx@AdobeOrg
        adobe_io_api_key = xxx
        adobe_io_client_secret = xxx
        adobe_io_tech_acct_id = xxx@techacct.adobe.com
        adobe_io_priv_key_filename = xxx/secret.pem

</details>

<br>

## Usage

### Get stats and paradata for activities

``` r
library(adobeTaRget)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
exchangeJWTforBearerToken()
```

    ## ADOBEIO_BEARER_TOKEN set

    ## Bearer eyJ4NXUi ... (truncated)

``` r
# List Activities
activities <- listActivities() %>% filter(grepl("AA Test", name)) %>% select(-thirdPartyId)
activityId <- activities$id

# start = manual start datetime; startsAt = scheduled start
activities
```

    ##       id type state                name           lifetime.start
    ## 1 297037   ab saved AA Test for CI Test 2019-06-25T15:34:04.000Z
    ##               lifetime.end priority           modifiedAt start startsAt
    ## 1 2019-07-09T18:36:53.000Z        0 2019-07-09T18:36:53Z  <NA>     <NA>
    ##   endsAt
    ## 1   <NA>

``` r
# Get AB Performance Report (using Adobe Target API)
getAbPerformanceReport(activityId)
```

    ## No encoding supplied: defaulting to UTF-8.

    ## $reportParameters
    ## $reportParameters$activityId
    ## [1] 297037
    ## 
    ## $reportParameters$environmentId
    ## [1] 8705
    ## 
    ## $reportParameters$conversionMetricLocalIds
    ## $reportParameters$conversionMetricLocalIds[[1]]
    ## [1] 32767
    ## 
    ## 
    ## $reportParameters$reportInterval
    ## [1] "2019-06-25T15:00Z/2019-07-09T19:00Z"
    ## 
    ## 
    ## $activity
    ## $activity$id
    ## [1] 297037
    ## 
    ## $activity$thirdPartyId
    ## [1] "a5a8efb8-026f-48bb-a159-69f0e153cecb"
    ## 
    ## $activity$type
    ## [1] "ab"
    ## 
    ## $activity$state
    ## [1] "saved"
    ## 
    ## $activity$name
    ## [1] "AA Test for CI Test"
    ## 
    ## $activity$priority
    ## [1] 0
    ## 
    ## $activity$modifiedAt
    ## [1] "2019-07-09T18:36:53Z"
    ## 
    ## $activity$metrics
    ## $activity$metrics[[1]]
    ## $activity$metrics[[1]]$name
    ## [1] "Entry"
    ## 
    ## $activity$metrics[[1]]$metricLocalId
    ## [1] 0
    ## 
    ## 
    ## $activity$metrics[[2]]
    ## $activity$metrics[[2]]$name
    ## [1] "Display mboxes"
    ## 
    ## $activity$metrics[[2]]$metricLocalId
    ## [1] 2
    ## 
    ## 
    ## $activity$metrics[[3]]
    ## $activity$metrics[[3]]$name
    ## [1] "MY PRIMARY GOAL"
    ## 
    ## $activity$metrics[[3]]$metricLocalId
    ## [1] 32767
    ## 
    ## 
    ## 
    ## $activity$experiences
    ## $activity$experiences[[1]]
    ## $activity$experiences[[1]]$name
    ## [1] "Experience A"
    ## 
    ## $activity$experiences[[1]]$experienceLocalId
    ## [1] 0
    ## 
    ## 
    ## $activity$experiences[[2]]
    ## $activity$experiences[[2]]$name
    ## [1] "Experience B"
    ## 
    ## $activity$experiences[[2]]$experienceLocalId
    ## [1] 1
    ## 
    ## 
    ## 
    ## 
    ## $report
    ## $report$statistics
    ## $report$statistics$totals
    ## $report$statistics$totals$visitor
    ## $report$statistics$totals$visitor$totals
    ## $report$statistics$totals$visitor$totals$entries
    ## [1] 1839937
    ## 
    ## $report$statistics$totals$visitor$totals$conversions
    ## [1] 179585
    ## 
    ## 
    ## 
    ## $report$statistics$totals$visit
    ## $report$statistics$totals$visit$totals
    ## $report$statistics$totals$visit$totals$entries
    ## [1] 2563497
    ## 
    ## $report$statistics$totals$visit$totals$conversions
    ## [1] 222447
    ## 
    ## 
    ## 
    ## $report$statistics$totals$impression
    ## $report$statistics$totals$impression$totals
    ## $report$statistics$totals$impression$totals$entries
    ## [1] 3709620
    ## 
    ## $report$statistics$totals$impression$totals$conversions
    ## [1] 263970
    ## 
    ## 
    ## 
    ## $report$statistics$totals$landing
    ## $report$statistics$totals$landing$totals
    ## $report$statistics$totals$landing$totals$entries
    ## [1] 3709620
    ## 
    ## $report$statistics$totals$landing$totals$conversions
    ## [1] 263970
    ## 
    ## 
    ## 
    ## $report$statistics$totals$timeToConversion
    ## $report$statistics$totals$timeToConversion$totals
    ## $report$statistics$totals$timeToConversion$totals$total
    ## [1] 19636800612
    ## 
    ## $report$statistics$totals$timeToConversion$totals$sumOfSquares
    ## [1] 1.11414e+16
    ## 
    ## 
    ## 
    ## $report$statistics$totals$orders
    ## $report$statistics$totals$orders$totals
    ## $report$statistics$totals$orders$totals$count
    ## [1] 0
    ## 
    ## $report$statistics$totals$orders$totals$sales
    ## [1] 0
    ## 
    ## $report$statistics$totals$orders$totals$sumOfSquares
    ## [1] 0
    ## 
    ## $report$statistics$totals$orders$totals$outlierIncludedCount
    ## [1] 0
    ## 
    ## $report$statistics$totals$orders$totals$outlierIncludedSales
    ## [1] 0
    ## 
    ## $report$statistics$totals$orders$totals$outlierIncludedSumOfSquares
    ## [1] 0
    ## 
    ## 
    ## 
    ## 
    ## $report$statistics$experiences
    ## $report$statistics$experiences[[1]]
    ## $report$statistics$experiences[[1]]$experienceLocalId
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[1]]$totals
    ## $report$statistics$experiences[[1]]$totals$visitor
    ## $report$statistics$experiences[[1]]$totals$visitor$totals
    ## $report$statistics$experiences[[1]]$totals$visitor$totals$entries
    ## [1] 919771
    ## 
    ## $report$statistics$experiences[[1]]$totals$visitor$totals$conversions
    ## [1] 89577
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[1]]$totals$visit
    ## $report$statistics$experiences[[1]]$totals$visit$totals
    ## $report$statistics$experiences[[1]]$totals$visit$totals$entries
    ## [1] 1281390
    ## 
    ## $report$statistics$experiences[[1]]$totals$visit$totals$conversions
    ## [1] 110949
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[1]]$totals$impression
    ## $report$statistics$experiences[[1]]$totals$impression$totals
    ## $report$statistics$experiences[[1]]$totals$impression$totals$entries
    ## [1] 1854472
    ## 
    ## $report$statistics$experiences[[1]]$totals$impression$totals$conversions
    ## [1] 131704
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[1]]$totals$landing
    ## $report$statistics$experiences[[1]]$totals$landing$totals
    ## $report$statistics$experiences[[1]]$totals$landing$totals$entries
    ## [1] 1854472
    ## 
    ## $report$statistics$experiences[[1]]$totals$landing$totals$conversions
    ## [1] 131704
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[1]]$totals$timeToConversion
    ## $report$statistics$experiences[[1]]$totals$timeToConversion$totals
    ## $report$statistics$experiences[[1]]$totals$timeToConversion$totals$total
    ## [1] 9772042603
    ## 
    ## $report$statistics$experiences[[1]]$totals$timeToConversion$totals$sumOfSquares
    ## [1] 5.513682e+15
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[1]]$totals$orders
    ## $report$statistics$experiences[[1]]$totals$orders$totals
    ## $report$statistics$experiences[[1]]$totals$orders$totals$count
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[1]]$totals$orders$totals$sales
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[1]]$totals$orders$totals$sumOfSquares
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[1]]$totals$orders$totals$outlierIncludedCount
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[1]]$totals$orders$totals$outlierIncludedSales
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[1]]$totals$orders$totals$outlierIncludedSumOfSquares
    ## [1] 0
    ## 
    ## 
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[2]]
    ## $report$statistics$experiences[[2]]$experienceLocalId
    ## [1] 1
    ## 
    ## $report$statistics$experiences[[2]]$totals
    ## $report$statistics$experiences[[2]]$totals$visitor
    ## $report$statistics$experiences[[2]]$totals$visitor$totals
    ## $report$statistics$experiences[[2]]$totals$visitor$totals$entries
    ## [1] 920166
    ## 
    ## $report$statistics$experiences[[2]]$totals$visitor$totals$conversions
    ## [1] 90008
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[2]]$totals$visit
    ## $report$statistics$experiences[[2]]$totals$visit$totals
    ## $report$statistics$experiences[[2]]$totals$visit$totals$entries
    ## [1] 1282107
    ## 
    ## $report$statistics$experiences[[2]]$totals$visit$totals$conversions
    ## [1] 111498
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[2]]$totals$impression
    ## $report$statistics$experiences[[2]]$totals$impression$totals
    ## $report$statistics$experiences[[2]]$totals$impression$totals$entries
    ## [1] 1855148
    ## 
    ## $report$statistics$experiences[[2]]$totals$impression$totals$conversions
    ## [1] 132266
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[2]]$totals$landing
    ## $report$statistics$experiences[[2]]$totals$landing$totals
    ## $report$statistics$experiences[[2]]$totals$landing$totals$entries
    ## [1] 1855148
    ## 
    ## $report$statistics$experiences[[2]]$totals$landing$totals$conversions
    ## [1] 132266
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[2]]$totals$timeToConversion
    ## $report$statistics$experiences[[2]]$totals$timeToConversion$totals
    ## $report$statistics$experiences[[2]]$totals$timeToConversion$totals$total
    ## [1] 9864758009
    ## 
    ## $report$statistics$experiences[[2]]$totals$timeToConversion$totals$sumOfSquares
    ## [1] 5.627716e+15
    ## 
    ## 
    ## 
    ## $report$statistics$experiences[[2]]$totals$orders
    ## $report$statistics$experiences[[2]]$totals$orders$totals
    ## $report$statistics$experiences[[2]]$totals$orders$totals$count
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[2]]$totals$orders$totals$sales
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[2]]$totals$orders$totals$sumOfSquares
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[2]]$totals$orders$totals$outlierIncludedCount
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[2]]$totals$orders$totals$outlierIncludedSales
    ## [1] 0
    ## 
    ## $report$statistics$experiences[[2]]$totals$orders$totals$outlierIncludedSumOfSquares
    ## [1] 0

``` r
# Get report for more metrics and breakdowns using RSiteCatalyst under the hood
library(RSiteCatalyst)
```

    ## Warning: package 'RSiteCatalyst' was built under R version 3.4.4

``` r
RSiteCatalyst::SCAuth(key = Sys.getenv("SCAUTH_KEY"), secret = Sys.getenv("SCAUTH_SECRET"), company = Sys.getenv("SCAUTH_CO"))
```

    ## [1] "Credentials Saved in RSiteCatalyst Namespace."

``` r
adobeTaRget::QueueA4TReport(activityId = "298487") %>%
  mutate(activity = "AB",
         experience = c("A", "B"),
         uniquevisitors = c(12345, 54321)
         ) 
```

    ## No encoding supplied: defaulting to UTF-8.

    ## No encoding supplied: defaulting to UTF-8.
    ## No encoding supplied: defaulting to UTF-8.
    ## No encoding supplied: defaulting to UTF-8.

    ## [1] "Requesting URL attempt #1"
    ## [1] "Requesting URL attempt #2"
    ## [1] "Received trended report."

    ## Warning in is.na(elements[i, ]$classification): is.na() applied to non-
    ## (list or vector) of type 'NULL'

    ## Warning in is.na(elements[i, ]$classification): is.na() applied to non-
    ## (list or vector) of type 'NULL'

    ##     datetime activity experience uniquevisitors segment.id segment.name
    ## 1 2019-07-19       AB          A          12345                        
    ## 2 2019-07-19       AB          B          54321                        
    ##   activity_duration           activity_range activityId
    ## 1                20 2019-07-19 to 2019-08-08     298487
    ## 2                20 2019-07-19 to 2019-08-08     298487

``` r
# View Changelog
getActivityChangelog(activityId, activities)
```

    ## [[1]]
    ##             modifiedAt activityParameters.state.previousValue
    ## 1 2019-07-09T18:36:53Z                               approved
    ## 2 2019-06-25T15:34:04Z                                  saved
    ## 3 2019-06-25T15:16:13Z                                   <NA>
    ## 4 2019-06-25T15:15:34Z                                   <NA>
    ##   activityParameters.state.changedValue
    ## 1                                 saved
    ## 2                              approved
    ## 3                                  <NA>
    ## 4                                  <NA>
    ##   activityParameters.trafficPercentage.previousValue
    ## 1                                               <NA>
    ## 2                                               <NA>
    ## 3                                                  5
    ## 4                                               <NA>
    ##   activityParameters.trafficPercentage.changedValue changedValue     id
    ## 1                                              <NA>         <NA> 297037
    ## 2                                              <NA>         <NA> 297037
    ## 3                                                50         <NA> 297037
    ## 4                                              <NA>        saved 297037
    ##                  name type startsAt endsAt
    ## 1 AA Test for CI Test   ab     <NA>   <NA>
    ## 2 AA Test for CI Test   ab     <NA>   <NA>
    ## 3 AA Test for CI Test   ab     <NA>   <NA>
    ## 4 AA Test for CI Test   ab     <NA>   <NA>

``` r
# Get AB Report Interval
getAbReportInterval(activityId)
```

    ## No encoding supplied: defaulting to UTF-8.

    ## $start
    ## [1] "2019-06-25"
    ## 
    ## $end
    ## [1] "2019-07-09"
    ## 
    ## $length
    ## [1] 14

### Get and modify offer info

``` r
offers <- sapply(getAbActivityById("301540")$options, function(x) {setNames(x$offerId, x$name)})
```

    ## No encoding supplied: defaulting to UTF-8.

``` r
offers
```

    ## Offer2 Offer3 
    ## 583019 583639

``` r
getOfferById(offers[2]) 
```

    ## No encoding supplied: defaulting to UTF-8.

    ## $id
    ## [1] 583639
    ## 
    ## $name
    ## [1] "Offer3"
    ## 
    ## $content
    ## [1] "<b>new content</b>"
    ## 
    ## $modifiedAt
    ## [1] "2019-08-08T20:27:27Z"

``` r
updateOfferById(offers[2], names(offers[2]), "<b>new content</b>")
```

    ## No encoding supplied: defaulting to UTF-8.

    ## $id
    ## [1] 583639
    ## 
    ## $name
    ## [1] "Offer3"
    ## 
    ## $content
    ## [1] "<b>new content</b>"
    ## 
    ## $modifiedAt
    ## [1] "2019-08-08T20:30:38Z"
