# CLAUDE.md

Project memory for Claude Code. Loaded automatically at the start of every
session in this repo. Keep it concise and current — when something meaningful
changes, update this file in the same PR.

## What this is

The marketing website for **Crisp Cut Studio Co**, an Etsy shop selling
original SVG cut files (for Cricut, Silhouette, Glowforge). It's a static
**Jekyll** site on **GitHub Pages**. It is only a storefront front door — it
links out to Etsy and has nothing to do with orders/listings/payments (those
live on Etsy).

## Key facts

- **Live site:** <https://nmj12435.github.io/nmj.business.github.io/> (project
  site, served at the `/nmj.business.github.io/` subpath because the repo is
  not named `nmj12435.github.io`).
- **Etsy shop:** <https://crispcutstudioco.etsy.com>
- **Contact email:** `nmj.businessplan@gmail.com` (also `site.email` in
  `_config.yml`).
- **Theme:** minima, with overrides in `assets/main.scss`.

## How it's built & deployed

- **Push to `main` = live.** `.github/workflows/deploy.yml` builds the site and
  deploys to Pages on every push to `main` (and via manual `workflow_dispatch`).
  Pages source is "GitHub Actions" (enabled once in repo Settings).
- The deploy build passes `--baseurl "${{ steps.pages.outputs.base_path }}"`,
  so the project-site subpath is handled automatically — do not hardcode it.
- Local dev: `bundle install && bundle exec jekyll serve`.

## CI checks (must pass before merge)

`.github/workflows/ci.yml` runs on every PR and does: Jekyll build →
html-proofer (internal links) → pa11y-ci (**WCAG 2.1 AA**, via sitemap) →
markdownlint → cspell → Lighthouse (`lighthouserc.json`: SEO/accessibility/
best-practices must be ≥ 0.9; performance only warns).
`.github/workflows/external-links.yml` checks outbound links weekly.

Run locally before pushing (needs `bundle install` + `npm install`):

```bash
bundle exec jekyll build
bundle exec htmlproofer ./_site --disable-external --allow-hash-href
python3 -m http.server 8080 --directory _site &   # then:
npm run test:a11y && npm run lint:md && npm run lint:spell && npm run test:lighthouse
```

## Conventions & gotchas

- **Workflow:** one change per PR; let CI go green; then merge (squash). Develop
  on a feature branch, never commit straight to `main`.
- **Accessibility is enforced.** Any new color must meet WCAG AA contrast
  (≥ 4.5:1) or the a11y/Lighthouse checks fail. Existing safe values live in
  `assets/main.scss` (brand teal `#0d5b62`, links `#0e7490`).
- **UTF-8 locale:** CI sets `LANG/LC_ALL=C.UTF-8` so html-proofer/nokogiri
  parse non-ASCII content (em dashes, curly quotes). Keep that if adding jobs.
- **Etsy is exempt** from the external-link check — Etsy returns 403 to bots,
  which would be a false failure.
- **cspell** only checks Markdown; add new proper nouns to `cspell.json`.
- **Base path:** never hardcode `/nmj.business.github.io`; it comes from
  `configure-pages`. The CI/test build uses dev mode (root-relative links).

## Open TODOs

- **Brand colors are placeholders.** The teal palette is an interpretation, not
  the real brand palette (Etsy blocked automated color extraction). Swap the
  three brand values at the top of `assets/main.scss` when real hex codes /
  logo are provided.
- **Optional:** rename the repo to `nmj12435.github.io` for a clean root URL
  (`https://nmj12435.github.io/`). Base-path handling already adapts.
- **JS unit tests:** not applicable until the site adds interactive JavaScript.
