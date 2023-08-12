# DerpyTools

## Run Locally

1. `brew install go-task`
1. `task install:tools`
1. `task install:deps`
---
1. `task generate:caddy_cert`
1. `task setup:hosts`
---
1. `task start:imgproxy`
1. `task start:caddy`
1. `task start:server`

---

Visit [`localhost:4000`](http://localhost:4000) or [`https://derpytools.site`](https://derpytools.site)

## TODO (App)

### Blog
- [ ] Reach feature parity with Ghost Blog
  - [x] Routing
  - [x] Table of Contents
  - [x] Footer Nav Button
  - [x] Related Posts
  - [x] Resizable Banner Image
  - [x] Routing
  - [ ] Proper code snippet embed
  - [ ] Code snippet copy button
  - [ ] Recent Posts
  - [ ] Blog main page
  - [ ] Tags page
  - [ ] Meta Data
    - [ ] LD Json
    - [ ] Atom feed
    - [ ] Sitemap
  - [ ] Componetize all blog post elements
  - [ ] URL auto embed, with auto image extraction
  - [ ] File uploader with cropping & compression
  - [ ] Lqip
  - [ ] Meilisearch for Command Palette
  ---
- [ ] Move blog posts
  - [ ] Taskfile
  - [ ] Multipass
  - [ ] Image Compression
  ---
- [ ] Move misc pages from Ghost Blog
  - [ ] Privacy Policy
  - [ ] Terms & Conditions
  - [ ] About
  - [ ] Social share
  - [ ] Cookie Consent
  - [ ] Contact Form
  ---
- [ ] Build Server Side Analytics using Clickhouse

### Tools
- [ ] URL Beaver
  - [ ] Metadata Analyzer (WIP)
  - [ ] UTM Builder (WIP)
  - [ ] URL Shortener
  - [ ] Referral link manager
  - [ ] Wordle

### Misc

- [x] Heartbeat
- [x] Offline Indicator
- [x] Dark Mode
- [ ] UUID7
- [ ] Local storage to persist user inputs


## TODO (Local)

- [ ] Litestream backup download to get a copy of production db for local testing
- [ ] Setup live book & live documentation / playground

## TODO (Stg / Prod)

- [ ] Add commands to run in staging & production
- [ ] Setup Varnish
- [ ] Setup Imgproxy
- [ ] Systemd encryption of env files
- [ ] Reduce number of bash scripts using variables
