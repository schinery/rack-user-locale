# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack/user-locale/version"

Gem::Specification.new do |spec|
  spec.name = "rack-user-locale"
  spec.version = Rack::UserLocale::VERSION
  spec.authors = ["Stuart Chinery"]
  spec.email = ["stuart.chinery@gmail.com"]
  spec.summary = "A Rack module for getting and setting a user's locale"
  spec.description = "A Rack module for getting and setting a user's locale via a cookie or browser default language."
  spec.homepage = "https://github.com/schinery/rack-user-locale"
  spec.license = "MIT"

  spec.files = Dir[
    "lib/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md",
    "VERSION"
  ]

  spec.add_dependency "i18n", ">= 0.6.6"
  spec.add_dependency "rack", ">= 1.6.11"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.12"
  spec.add_development_dependency "minitest-fail-fast", "~> 0.1"
  spec.add_development_dependency "minitest-macos-notification", "~> 0.1"
  spec.add_development_dependency "minitest-reporters", "~> 1.4"
  spec.add_development_dependency "rack-test", "~> 1.1"
  spec.add_development_dependency "rake", "~> 13.0"
end
