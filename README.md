# DerpyTools

## Run Locally

- `brew install go-task`
- `task install:tools`
- `task install:deps`

- `task generate:caddy_cert`
- `task setup:hosts`

- `task start:imgproxy`
- `task start:caddy`
- `task start:server`

Visit [`localhost:4000`](http://localhost:4000) or [`https://derpytools.site`](https://derpytools.site)

## Todos (Local)

[ ] - Litestream backup download to get a copy of production db for local testing.
[ ] - Setup live book & live documentation / playground.

## Todos (Stg / Prod)

[ ] - Add commands to run in staging & production.
[ ] - Setup Varnish
[ ] - Setup Imgproxy

## Todos (App)

### Blog
[ ] - Reach feature parity with Ghost Blog
[ ] - Move blog posts
[ ] - Move misc pages from Ghost Blog

### Tools
[ ] - URL Beaver
  [ ] Metadata Analyzer (WIP)
  [ ] UTM Builder (WIP)
