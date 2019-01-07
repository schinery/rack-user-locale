# frozen_string_literal: true

require "helper"
require "basic_rack_app"

class RackUserLocaleTest < Minitest::Test
  describe Rack::UserLocale do
    before do
      I18n.enforce_available_locales = false
    end

    describe "without accepted_locales set" do
      before do
        def app
          Rack::Builder.new do
            use Rack::UserLocale

            run BasicRackApp.new
          end
        end

        I18n.default_locale = :en
        I18n.locale = :en
      end

      it "should have I18n.locale set to :en" do
        assert_equal :en, I18n.locale
      end

      describe "when a locale cookie is set" do
        before do
          get "http://example.com/", {}, "HTTP_COOKIE" => "user-locale=be"
        end

        it "should have I18n.locale set to :be" do
          assert_equal :be, I18n.locale
        end

        it "should not set a cookie in the response" do
          assert_equal nil, last_response["Set-Cookie"]
        end
      end

      describe "when from HTTP_ACCEPT_LANGUAGE headers" do
        describe "with a single locale" do
          before do
            get "http://example.com/", {}, "HTTP_ACCEPT_LANGUAGE" => "fr-be", "SCRIPT_NAME" => "/"
          end

          it "should have I18n.locale set to :fr" do
            assert_equal :fr, I18n.locale
          end

          it "should set a cookie in the response" do
            assert_equal "user-locale=fr; path=/", last_response["Set-Cookie"]
          end
        end

        describe "with an multiple locales" do
          before do
            get "http://example.com/", {},
                "HTTP_ACCEPT_LANGUAGE" => "de-DE;q=0.8,de;q=0.8,no-NO;q=1.0,no;q=0.7,ru-RU;q=0.7,sv-SE;q=0.4,sv;q=0.3,nl-BE;q=0.9",
                "SCRIPT_NAME" => "/"
          end

          it "should have I18n.locale set to :no" do
            assert_equal :no, I18n.locale
          end

          it "should set a cookie in the response" do
            assert_equal "user-locale=no; path=/", last_response["Set-Cookie"]
          end
        end
      end

      describe "when both a cooke and HTTP_ACCEPT_LANGUAGE headers are set" do
        before do
          get "http://example.com/", {}, "HTTP_COOKIE" => "user-locale=af",
                                         "HTTP_ACCEPT_LANGUAGE" => "ar-sa", "SCRIPT_NAME" => "/"
        end

        it "should have I18n.locale set to :af" do
          assert_equal :af, I18n.locale
        end

        it "should not set a cookie in the response" do
          assert_equal nil, last_response["Set-Cookie"]
        end
      end

      describe "when nothing is changed" do
        before do
          get "http://example.com/", {}, "SCRIPT_NAME" => "/"
        end

        it "should have I18n.locale set to :en" do
          assert_equal :en, I18n.locale
        end

        it "should set a cookie in the response" do
          assert_equal "user-locale=en; path=/", last_response["Set-Cookie"]
        end
      end
    end

    describe "with accepted_locales set" do
      before do
        def app
          Rack::Builder.new do
            use Rack::UserLocale, accepted_locales: %i[en es fr de ja nl]

            run BasicRackApp.new
          end
        end

        I18n.default_locale = :en
        I18n.locale = :en
      end

      it "should have I18n.locale set to :en" do
        assert_equal :en, I18n.locale
      end

      describe "when a locale cookie is set" do
        before do
          get "http://example.com/", {}, "HTTP_COOKIE" => "user-locale=es", "SCRIPT_NAME" => "/"
        end

        it "should have I18n.locale set to :es" do
          assert_equal :es, I18n.locale
        end

        it "should not set a cookie in the response" do
          assert_equal nil, last_response["Set-Cookie"]
        end
      end

      describe "when from HTTP_ACCEPT_LANGUAGE headers" do
        describe "with an accepted locale" do
          before do
            get "http://example.com/", {}, "HTTP_ACCEPT_LANGUAGE" => "fr-be", "SCRIPT_NAME" => "/"
          end

          it "should have I18n.locale set to :fr" do
            assert_equal :fr, I18n.locale
          end

          it "should set a cookie in the response" do
            assert_equal "user-locale=fr; path=/", last_response["Set-Cookie"]
          end
        end

        describe "with an multiple locales" do
          describe "at different weights" do
            before do
              get "http://example.com/", {},
                  "HTTP_ACCEPT_LANGUAGE" => "de-DE;q=0.8,de;q=0.8,no-NO;q=0.7,no;q=0.7,ru-RU;q=0.7,sv-SE;q=0.4,sv;q=0.3,nl-BE;q=0.9",
                  "SCRIPT_NAME" => "/"
            end

            it "should have I18n.locale set to :nl" do
              assert_equal :nl, I18n.locale
            end

            it "should set a cookie in the response" do
              assert_equal "user-locale=nl; path=/", last_response["Set-Cookie"]
            end
          end

          describe "at the same weight" do
            before do
              get "http://example.com/", {},
                  "HTTP_ACCEPT_LANGUAGE" => "fr,en,ja", "SCRIPT_NAME" => "/"
            end

            it "should have I18n.locale set to :fr" do
              assert_equal :fr, I18n.locale
            end

            it "should set a cookie in the response" do
              assert_equal "user-locale=fr; path=/", last_response["Set-Cookie"]
            end
          end
        end

        describe "without an accepted locale" do
          before do
            get "http://example.com/", {}, "HTTP_ACCEPT_LANGUAGE" => "ar-sa", "SCRIPT_NAME" => "/"
          end

          it "should have I18n.locale set to :en" do
            assert_equal :en, I18n.locale
          end

          it "should set a cookie in the response" do
            assert_equal "user-locale=en; path=/", last_response["Set-Cookie"]
          end
        end
      end

      describe "when both a cooke and HTTP_ACCEPT_LANGUAGE headers are set" do
        before do
          get "http://example.com/", {}, "HTTP_COOKIE" => "user-locale=ja",
                                         "HTTP_ACCEPT_LANGUAGE" => "fr-be", "SCRIPT_NAME" => "/"
        end

        it "should have I18n.locale set to :ja" do
          assert_equal :ja, I18n.locale
        end

        it "should not set a cookie in the response" do
          assert_equal nil, last_response["Set-Cookie"]
        end
      end

      describe "when nothing is changed" do
        before do
          get "http://example.com/", {}, "SCRIPT_NAME" => "/"
        end

        it "should have I18n.locale set to :en" do
          assert_equal :en, I18n.locale
        end

        it "should set a cookie in the response" do
          assert_equal "user-locale=en; path=/", last_response["Set-Cookie"]
        end
      end
    end
  end
end
