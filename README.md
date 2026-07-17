# nmj.business.github.io

Website for **Crisp Cut Studio Co** — an Etsy shop selling original SVG cut
files — built with [Jekyll](https://jekyllrb.com/) and hosted on GitHub Pages.

## Local development

```bash
bundle install
bundle exec jekyll serve
```

The site is then available at <http://localhost:4000>.

## Testing

This repository treats the built site as its test surface. The main CI
workflow (`.github/workflows/ci.yml`) runs on every push and pull request to
`main`:

1. **Builds** the site with `jekyll build` — a broken build fails the check.
2. **Validates** the generated HTML with
   [html-proofer](https://github.com/gjtorikian/html-proofer), catching broken
   internal links, missing images, and malformed markup.
3. **Scans for accessibility issues** with
   [pa11y-ci](https://github.com/pa11y/pa11y-ci), checking every page in the
   sitemap against **WCAG 2.1 AA**. New pages are discovered automatically via
   `sitemap.xml`, so no CI edits are needed as the site grows.
4. **Lints Markdown** with
   [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)
   (config in `.markdownlint-cli2.jsonc`).
5. **Spell-checks content** with [cspell](https://cspell.org/) over Markdown
   sources (project dictionary in `cspell.json`).
6. **Enforces performance / SEO budgets** with
   [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci)
   (thresholds in `lighthouserc.json`): SEO, accessibility, and best-practices
   must score ≥ 0.9; performance is reported as a warning since it varies by
   runner.

A separate scheduled workflow (`.github/workflows/external-links.yml`) checks
**outbound links** weekly (and on demand via *Run workflow*). It's kept out of
the per-PR checks so a third-party outage never blocks a merge.

Run the checks locally before pushing:

```bash
# Ruby + Node dependencies
bundle install
npm install

# 1-2. Build + internal HTML/link validation
bundle exec jekyll build
bundle exec htmlproofer ./_site --disable-external --allow-hash-href

# 3. Accessibility scan: serve the built site, then run pa11y-ci
python3 -m http.server 8080 --directory _site &
npm run test:a11y

# 4-5. Markdown lint + spell-check
npm run lint:md
npm run lint:spell

# 6. Performance / SEO budgets (audits the built _site)
npm run test:lighthouse
```

### Suggested next steps for test coverage

- **JavaScript unit tests** — not yet applicable (the site has no JavaScript).
  When interactive JS is added, cover it with [Jest](https://jestjs.io/) or
  [Vitest](https://vitest.dev/), where conventional code-coverage metrics apply.
