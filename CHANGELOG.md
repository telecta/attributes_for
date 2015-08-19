# Changelog

## [0.4.1] - 2015-08-18
### Added
- Use `phony_rails` to format phone numbers.

### Fixed
- Zero values for duration not displayed. Now showing '0'.

## [0.4.0] - 2015-08-07
### Added
- `duration` helper. Displays and integer in days, hours, minutes and
  seconds

### Fixed
- Handle installation in projects using SASS.

## [0.3.2] - 2015-08-06
### Changed
- Rewrote implementation using method_missing

## [0.3.1] - 2015-08-06
### Fixed
- Fixed stylesheet loading (insert 'require' during installation).

## [0.3.0] - 2015-08-05
### Added
- All formatting methods now takes a block. The contents of the block
  will be displayed after the label.

## [0.2.0] - 2015-08-04
### Added
- `boolean` formatting helper, will show 'Yes' or 'No' depending on
  attribute value.
- Install generator. Copies locales into project.

## [0.1.1] - 2015-08-04
### Fixed
- Disabeling label with format helpers shows unescaped HTML.
