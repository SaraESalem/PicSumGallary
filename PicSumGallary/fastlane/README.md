fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### create_app

```sh
[bundle exec] fastlane create_app
```

Create app on developer portal and App Store Connect if needed

----


## iOS

### ios bump

```sh
[bundle exec] fastlane ios bump
```

Bump version

### ios signing

```sh
[bundle exec] fastlane ios signing
```

(1) Sync signing

### ios build

```sh
[bundle exec] fastlane ios build
```

(2) Build binary

### ios release

```sh
[bundle exec] fastlane ios release
```

(3) Release binary

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
