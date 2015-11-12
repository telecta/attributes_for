# Changelog

## [0.7.1] - 2015-11-12
### Fixed
- Fix regression. Support `:id` option.

## [0.7.0] - 2015-11-09
### Added
- Wrap label and value in tags.
- `:defaults` options. Apply same options to all elements.
- `:wrapper` options (change default wrappers).
- `:label_html` and `:value_html` to set attributes on tags.

### Changed
- Improved implementation slightly.

## [0.6.1] - 2015-10-29
### Changed
- Updated dependencies.

## [0.6.0] - 2015-10-21
### Added
- `date` and `datetime` helpers formats/converts to date and datetime.

## [0.5.1] - 2015-12-10
### Fixed
- `attribute` helper explicitly casts integer to string.

## [0.5.0] - 2015-21-09
### Fixed
- Use font-awesome-rails `fa_icon` helper to handle icons. Icons are now
  positioned in front of content instead of wrapping it.
- Fixed tests.

### Changed
- Use options[:icon] to handle Font Awesome icons.
- Wrap key-val pairs with <span> tags.

## [0.4.4] - 2015-09-09
### Fixed
- Explicitly require dependencies.

## [0.4.3] - 2015-09-08
### Fixed
- Made `phone` more rubust, now normalizes phone number before
  formatting, thus handling plus and other characters.

## [0.4.2] - 2015-09-05
### Changed
- Use minitest instead of rspec
- Replaced `phony_rails` with `phony`.

### Fixed
- `string` helper now working as expected. Requires block to be passed
  for content.

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
