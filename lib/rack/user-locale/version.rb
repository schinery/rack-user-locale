# frozen_string_literal: true

module Rack
  class UserLocale
    version_file = ::File.join(::File.dirname(__FILE__), "../../../VERSION")
    VERSION = ::File.read(version_file).split("\n").first
  end
end
