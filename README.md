# DerpyTools

## Run Locally

1. `brew install go-task`
1. `task install:tools`
1. `task install:deps`
   
1. `task generate:caddy_cert`
1. `task setup:hosts`

1. `task start:imgproxy`
1. `task start:caddy`
1. `task start:server`

Visit [`localhost:4000`](http://localhost:4000) or [`https://derpytools.site`](https://derpytools.site)

## Todos (Local)

- [ ] Litestream backup download to get a copy of production db for local testing.
- [ ] Setup live book & live documentation / playground.

## Todos (Stg / Prod)

- [ ] Add commands to run in staging & production.
- [ ] Setup Varnish
- [ ] Setup Imgproxy

## Todos (App)

### Blog
- [ ] Reach feature parity with Ghost Blog
- [ ] Move blog posts
- [ ] Move misc pages from Ghost Blog

### Tools
- [ ] URL Beaver
  - [ ] Metadata Analyzer (WIP)
  - [ ] UTM Builder (WIP)
