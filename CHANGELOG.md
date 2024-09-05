# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- `additional_args` support to `live_grep_args()`

## 1.1.0 - 2024-06-09

### Added

- New shortcut functions `grep_word_under_cursor_current_buffer` and `grep_word_visual_selection_current_buffer` (#82) - contributed by @LLMChild

### Changed

- Mention `to_fuzzy_refine` shortcut in README (#80) - contributed by @ilan-schemoul
- Shortcut functions do now support opts (#82) - contributed by @LLMChild

### Fixed

- Visual selection now also works when selecting backwards (#69) - contributed by @ajenkinski

## 1.0.0 - 2023-08-28

### Added

- Telescope live grep args now has a Changelog and Tags
