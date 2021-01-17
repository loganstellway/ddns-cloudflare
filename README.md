## DDNS for CloudFlare

Simple dynamic DNS script written in Go to get client IP info.
This is meant to be used in tandem with the [IPInfo server](https://github.com/loganstellway/ipinfo), however it should be able to work fine with other compatible API's (that return a JSON object with an `ip` property).

## Docker

**Image**

[`lstellway/ddns-cloudflare`](https://hub.docker.com/r/lstellway/ddns-cloudflare)

**Environment Variables**

-   `DDNS_URL` - URL to IP info API (eg. [IPInfo server](https://github.com/loganstellway/ipinfo))
-   `CF_API_TOKEN` - CloudFlare API token
-   `CF_ZONE_ID` - CloudFlare zone ID
-   `CF_RECORD_NAME` - Comma-separated list of record names (eg. `subdomain.example.com,subdomain1.example.com`)
