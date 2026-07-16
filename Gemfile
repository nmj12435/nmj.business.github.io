# Gemfile for the GitHub Pages site.
#
# GitHub Pages builds this repository with its own pinned set of gems, so the
# `github-pages` gem below keeps local builds in lockstep with what Pages runs.
# `html-proofer` is used by CI to validate the built HTML and links.

source "https://rubygems.org"

# Keeps local Jekyll in sync with the version GitHub Pages deploys.
gem "github-pages", group: :jekyll_plugins

# Test-time only: validates the generated _site/ output.
group :test do
  gem "html-proofer", "~> 5.0"
end

# Windows and JRuby do not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows.
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]
