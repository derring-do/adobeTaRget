# adobeTaRget
R Package for Adobe Target API [WIP]

```
# Get/exchange tokens at beginning of session
reticulate::py_run_file(dir(path.package("adobeTaRget"), "ExchangeJWT.py", full.names=TRUE))  
py$ExchangeJWT(path.to.config, path.to.secret")
Sys.setenv("ADOBEIO_BEARER_TOKEN" = ini::read.ini(path.to.config)$enterprise$access_token)

# Then can do:
listActivities()
getActivityChangelog("123456")
```
