# nmj.business.github.io

Business website for NMJ, built with [Jekyll](https://jekyllrb.com/) and hosted
on GitHub Pages.

## Local development

```bash
bundle install
bundle exec jekyll serve
```

The site is then available at <http://localhost:4000>.

## Testing

This repository treats the built site as its test surface. CI
(`.github/workflows/ci.yml`) runs on every push and pull request to `main` and:

1. **Builds** the site with `jekyll build` — a broken build fails the check.
2. **Validates** the generated HTML with
   [html-proofer](https://github.com/gjtorikian/html-proofer), catching broken
   internal links, missing images, and malformed markup.
3. **Scans for accessibility issues** with
   [pa11y-ci](https://github.com/pa11y/pa11y-ci), checking every page in the
   sitemap against **WCAG 2.1 AA**. New pages are discovered automatically via
   `sitemap.xml`, so no CI edits are needed as the site grows.

Run the same checks locally before pushing:

```bash
# Build + HTML/link validation
bundle exec jekyll build
bundle exec htmlproofer ./_site --disable-external --allow-hash-href

# Accessibility scan (requires Node): serve the built site, then run pa11y-ci
npm install
python3 -m http.server 8080 --directory _site &
npm run test:a11y
```

### Suggested next steps for test coverage

As the site grows, consider adding:

- **External link checking** — drop `--disable-external` (run on a schedule to
  avoid flaky CI from third-party outages).
- **Performance / SEO budgets** — [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci).
- **Content linting** — `markdownlint` and a spellchecker over Markdown sources.
- **JavaScript unit tests** — if interactive JS is added, cover it with Jest or
  Vitest (where conventional code-coverage metrics apply).
