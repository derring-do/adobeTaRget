# adobeTaRget
Wrapper functions for selected Adobe Target APIs
https://developers.adobetarget.com/api/#introduction

## Prerequisites

<details><summary>Adobe IO API Configuration</summary>

1. Get System Admin rights for Adobe IO

1. Generate public certificate and private key per https://helpx.adobe.com/in/marketing-cloud-core/kb/adobe-io-authentication-step-by-step.html:
    - Generate `secret.pem` and `certificate.pem` via:         
      ```bash
      openssl req -nodes -text -x509 -newkey rsa:2048 -keyout secret.pem -out certificate.pem -days 356
      ```

    - Convert `secret.key` to `secret.pem` via: 

      ```bash
      openssl pkcs8 -topk8 -inform PEM -outform DER -in secret.pem -nocrypt > secret.key
      ```
1. Set up New Integration in Adobe IO: Go to https://console.adobe.io > "New Integration" > "Access and API" > select Adobe Solution (Target) > Enter Integration details > Upload `certificate.pem`

1. Use `adobeTaRget::set_adobe_io_credentials()` to set credentials --- or manually populate .Renviron with the following from the IO Console and the directory where you saved secret.pem:

    ```
    adobe_io_ims_host = ims-na1.adobelogin.com
    adobe_io_ims_endpoint_jwt = /ims/exchange/jwt
    adobe_io_org_id = xxx@AdobeOrg
    adobe_io_api_key = xxx
    adobe_io_client_secret = xxx
    adobe_io_tech_acct_id = xxx@techacct.adobe.com
    adobe_io_priv_key_filename = xxx/secret.pem
    ```

</details>
<br>

## Usage

```r
library(adobeTaRget)
library(dplyr)
exchangeJWTforBearerToken()
```
```r
## ADOBEIO_BEARER_TOKEN set
## Bearer eyJ4NXUi ... (truncated)
```
---
```r
# List Activities
activities <- listActivities() %>% filter(grepl("test", name)) %>% select(-thirdPartyId)

# start = manual start datetime; startsAt = scheduled start
activities
```
```r
##       id type       state                    name           lifetime.start
## 1 246022   ab deactivated Temp test A/A Null Test 2018-09-10T19:50:40.000Z
## 2 171022   xt deactivated          Spotlight test                     <NA>
## 3 170870   ab deactivated     JM - Text size test                     <NA>
##               lifetime.end priority           modifiedAt start startsAt
## 1 2018-09-10T19:52:19.000Z        0 2018-10-16T20:13:14Z  <NA>     <NA>
## 2                     <NA>        0 2017-04-06T18:55:01Z  <NA>     <NA>
## 3                     <NA>        0 2017-04-05T20:48:22Z  <NA>     <NA>
##   endsAt
## 1   <NA>
## 2   <NA>
## 3   <NA>
```
---
```r
# Get AB Performance Report
getAbPerformanceReport("246022")
```
```r
## $reportParameters
## $reportParameters$activityId
## [1] 246022
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
## [1] "2018-09-10T19:00Z/2018-09-10T20:00Z"
## 
## 
## $activity
## $activity$id
## [1] 246022
## 
## $activity$thirdPartyId
## [1] "f28a0acd-96f2-4e37-a12a-525c1eec7739"
## 
## $activity$type
## [1] "ab"
## 
## $activity$state
## [1] "deactivated"
## 
## $activity$name
## [1] "Temp test A/A Null Test"
## 
## $activity$priority
## [1] 0
## 
## $activity$modifiedAt
## [1] "2018-10-16T20:13:14Z"
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
## [1] "Null change"
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
## [1] 1071
## 
## $report$statistics$totals$visitor$totals$conversions
## [1] 0
## 
## 
## 
## $report$statistics$totals$visit
## $report$statistics$totals$visit$totals
## $report$statistics$totals$visit$totals$entries
## [1] 1080
## 
## $report$statistics$totals$visit$totals$conversions
## [1] 0
## 
## 
## 
## $report$statistics$totals$impression
## $report$statistics$totals$impression$totals
## $report$statistics$totals$impression$totals$entries
## [1] 1320
## 
## $report$statistics$totals$impression$totals$conversions
## [1] 0
## 
## 
## 
## $report$statistics$totals$landing
## $report$statistics$totals$landing$totals
## $report$statistics$totals$landing$totals$entries
## [1] 1320
## 
## $report$statistics$totals$landing$totals$conversions
## [1] 0
## 
## 
## 
## 
## $report$statistics$experiences
## $report$statistics$experiences[[1]]
## $report$statistics$experiences[[1]]$experienceLocalId
## [1] 1
## 
## $report$statistics$experiences[[1]]$totals
## $report$statistics$experiences[[1]]$totals$visitor
## $report$statistics$experiences[[1]]$totals$visitor$totals
## $report$statistics$experiences[[1]]$totals$visitor$totals$entries
## [1] 1071
## 
## $report$statistics$experiences[[1]]$totals$visitor$totals$conversions
## [1] 0
## 
## 
## 
## $report$statistics$experiences[[1]]$totals$visit
## $report$statistics$experiences[[1]]$totals$visit$totals
## $report$statistics$experiences[[1]]$totals$visit$totals$entries
## [1] 1080
## 
## $report$statistics$experiences[[1]]$totals$visit$totals$conversions
## [1] 0
## 
## 
## 
## $report$statistics$experiences[[1]]$totals$impression
## $report$statistics$experiences[[1]]$totals$impression$totals
## $report$statistics$experiences[[1]]$totals$impression$totals$entries
## [1] 1320
## 
## $report$statistics$experiences[[1]]$totals$impression$totals$conversions
## [1] 0
## 
## 
## 
## $report$statistics$experiences[[1]]$totals$landing
## $report$statistics$experiences[[1]]$totals$landing$totals
## $report$statistics$experiences[[1]]$totals$landing$totals$entries
## [1] 1320
## 
## $report$statistics$experiences[[1]]$totals$landing$totals$conversions
## [1] 0
```

---
```r
# View Changelog
getActivityChangelog("246022", activities)
```
```r
## $`246022`
##             modifiedAt activityParameters.state.previousValue
## 1 2018-10-16T20:13:13Z                                  saved
## 2 2018-09-10T19:52:19Z                               approved
## 3 2018-09-10T19:50:40Z                                  saved
## 4 2018-09-10T19:50:25Z                                   <NA>
##   activityParameters.state.changedValue changedValue     id
## 1                           deactivated         <NA> 246022
## 2                                 saved         <NA> 246022
## 3                              approved         <NA> 246022
## 4                                  <NA>        saved 246022
##                      name type startsAt endsAt
## 1 Temp test A/A Null Test   ab     <NA>   <NA>
## 2 Temp test A/A Null Test   ab     <NA>   <NA>
## 3 Temp test A/A Null Test   ab     <NA>   <NA>
## 4 Temp test A/A Null Test   ab     <NA>   <NA>
```