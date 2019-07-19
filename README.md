# adobeTaRget
R Package for Adobe Target API [WIP]

## Prerequisites
1. Get System Admin rights for Adobe IO

1. Generate public certificate and private key per this [guide](https://helpx.adobe.com/in/marketing-cloud-core/kb/adobe-io-authentication-step-by-step.html):
    - Generate `secret.pem` and `certificate.pem` via:         
    ```bash
    openssl req -nodes -text -x509 -newkey rsa:2048 -keyout secret.pem -out certificate.pem -days 356
    ```

    - Convert `secret.key` to `secret.pem` via: 

    ```bash
    openssl pkcs8 -topk8 -inform PEM -outform DER -in secret.pem -nocrypt > secret.key
    ```
1. Set up New Integration in Adobe IO: Go to https://console.adobe.io > "New Integration" > "Access and API" > select Adobe Solution (Target) > Enter Integration details > Upload `certificate.pem`

1. Create `.config` file with new integration details, which will be used by ExchangeJWT.py and other functions

    ```
    [server]
    ims_host = ims-na1.adobelogin.com
    ims_endpoint_jwt = /ims/exchange/jwt

    [enterprise]
    org_id = xxx@AdobeOrg
    api_key = xxx
    client_secret = xxx
    tech_acct = xxx@techacct.adobe.com
    priv_key_filename = secret.pem
    jwt_token = will be populated
    access_token = will be populated
    ```
    
# Get/exchange tokens at beginning of session
exchangeJWTforBearerToken()

# Then can do:
listActivities()
getActivityChangelog("123456")
```
