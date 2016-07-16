# MediTAFFaker is a module that provides random fake data for uid codes, random numbers, timestamp  based on the Faker gem
#
#*********************************************************************************************************************S**c*#
require 'MediTAF/utils/configuration'
require 'faker'

require 'i18n'

I18n.enforce_available_locales = true
I18n.reload!

module MediTAF
  module Utils
    class Base < Faker::Base

      class << self
        def stringify(param, *params)
          "#{param}#{params.join()}"
        end

        protected
        def random_generator
          rand(1000..9999)
        end
      end
    end

    # TimeStamp: a class that provides the current date time format
    class MediTAFFaker < Base
      class << self

        ##using Faker address
        def address
          Faker::Address
        end

        # using Faker name
        def name
          Faker::Name
        end

        # using Faker code
        def code
          Faker::Code
        end

        # using Faker number
        def number
          Faker::Number
        end

        # using Faker phone_number
        def phone_number
          Faker::PhoneNumber
        end

        # Default representation of the current date format
        def timestamp
          DateTime.now.strftime()
        end

        # Default representation of the current date format
        def medidata_date_format
          DateTime.now.strftime("%d-%b-%Y")
        end

        # Long representation of the current date format - Missing Year
        def timestamp_long
          DateTime.now.strftime("%m%d%H%M%S%6N")
        end

        # Short representation of the current date format with minutes, seconds and micro seconds
        def timestamp_short
          DateTime.now.strftime("%M%S%6N")
        end

        # Complete representation of the current date format including picosecons
        def timestamp_complete
          DateTime.now.strftime("%m-%d-%Y:%H%M%S.%12N")
        end

        # Random: a class that displays a random string in the MD5 format based on DateTime as string
        def random
          random_generator.to_s
        end

        # UID: a class that displays a random string in the MD5 format based on DateTime as string
        def uid
          Digest::MD5.hexdigest(DateTime.now.strftime("%m-%d-%Y:%H%M%S.%12N")).to_s
        end

        # Code: a class that inherits from Faker:Code. It provides UID (32/40-bit length).
        def uid_md5(no_dash=true)
          no_dash ? generate_32_bit_checkmateUID_without_dash : generate_32_bit_checkmateUID_with_dash
        end

        def uid_sha1(no_dash=true)
          no_dash ? generate_40_bit_checkmateUID_without_dash : generate_40_bit_checkmateUID_with_dash
        end

        private

        def generate_32_bit_checkmateUID_with_dash
          regexify(/[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/)
        end

        def generate_32_bit_checkmateUID_without_dash
          regexify(/[a-f0-9]{32}/)
        end

        def generate_40_bit_checkmateUID_with_dash
          regexify(/[a-f0-9]{12}-([a-f0-9]{4}-){4}[a-f0-9]{12}/)
        end

        def generate_40_bit_checkmateUID_without_dash
          regexify(/[a-f0-9]{40}/)
        end

      end
    end
  end
end