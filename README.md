# DerpyTools
![GitHub commit activity (branch)](https://img.shields.io/github/commit-activity/t/derpycoder/derpy_tools)
![GitHub top language](https://img.shields.io/github/languages/top/derpycoder/derpy_tools)
![GitHub](https://img.shields.io/github/license/derpycoder/derpy_tools)
![GitHub repo size](https://img.shields.io/github/repo-size/derpycoder/derpy_tools)
![GitHub Repo stars](https://img.shields.io/github/stars/derpycoder/derpy_tools)

![Metadata Checker](https://github.com/derpycoder/derpy_tools/assets/25662120/a271b6a8-339c-4a0a-af3f-1c19b13dc335)


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

#### Meta Routes

- /stats
- /version
- /health
- /release

## TODO (App)

### Blog
![Table of Contents](https://github.com/derpycoder/derpy_tools/assets/25662120/2555b87d-f929-4f78-85df-d3394b898e10)


- [ ] Reach feature parity with Ghost Blog
  - [x] Routing
  - [x] Table of Contents
  - [x] Reading time estimation
  - [x] Human readable dates & relative time
  - [x] Footer Nav Button
  - [x] Related Posts
  - [x] Resizable Images using Imgproxy
  - [x] Routing
  - [x] HTTP/3, Brotli, AVIF like modern features achieved
  - [x] Keyboard Shortcuts
  - [ ] Proper code snippet embed
  - [ ] Code snippet copy button
  - [ ] Recent Posts
  - [ ] Blog main page
  - [ ] Tags page
  - [ ] Metadata
    - [ ] LD Json
    - [ ] Atom feed
    - [ ] Sitemap
  - [ ] Componetize all blog post elements
  - [ ] URL auto-embed, with auto image extraction
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
  - [ ] Social Share
  - [ ] Cookie Consent
  - [ ] Contact Form

### Tools
![Command pallete Keyboard Shortcut](https://github.com/derpycoder/derpy_tools/assets/25662120/2fc2c396-bb01-4fb4-9b79-df4a35d8fe09)

- [ ] URL Beaver
  - [ ] Metadata Analyzer (WIP)
  - [ ] UTM Builder (WIP)
  - [ ] URL Shortener
  - [ ] Referral link manager
  - [ ] Wordle

### Authentication & Authorization
![Auth Flow](https://github.com/derpycoder/derpy_tools/assets/25662120/9c5c6c40-61dd-4caa-9dd4-886a9774ba49)

- [ ] Authentication
  - [x] Basic Auth
  - [ ] Google OAuth
  - [ ] GitHub OAuth
  - [x] Designed Auth pages to look fabulous

- [ ] Authorization
  - [ ] Add policies to restrict apps and routes to certain users
  - [ ] Add super user through an env variable


### Misc
![Derpy Tools](https://github.com/derpycoder/derpy_tools/assets/25662120/b236b7f0-9d72-473c-be7f-695a8cac965d)

- [x] Heartbeat
- [x] Offline Indicator
- [x] Dark Mode
- [x] Content Security Policy
- [x] Permissions Policy
- [x] Source Code Inspect
- [x] Image lazy loading
- [x] Tailwind Custom Config
- [x] CSP Nonce added to Live Dashboard & Inline Styles/Scripts
- [x] Caddy Error Routes
- [x] Varnish cache to cache Images
- [x] Added meta routes
- [x] Moved to Bandit server
- [x] Env variables split into multiple files
- [x] 404 & 500 Pages added
- [ ] UUID7
- [ ] Local storage to persist user inputs
- [ ] Build Server Side Analytics using Clickhouse

## TODO (Local)

- [ ] Litestream backup download to get a copy of production db for local testing
- [ ] Setup live book & live documentation/playground

## TODO (Stg / Prod)

- [ ] Add commands to run in staging & production
- [ ] Setup Varnish
- [ ] Setup Imgproxy
- [ ] Systemd encryption of env files
- [ ] Reduce the number of bash scripts using variables
