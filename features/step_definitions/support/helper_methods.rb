module MIST
  class HelperMethods

    class << self

      # Randomize the argument.
      # 'user<i1>', user<i2> and so on gets converted to user15 where 15 comes from config file
      # 'user<r2>' gets converted to userXX where XX are random numeric characters. 'user<r3>' would be userXXX
      # Supported <i>, <r1>, <r2>, <r3>, <r4>, <rn>
      # 'user<c1>' to 'user<cn>' or 'user<cn,5>' will have c1 to cn replaced with unique random number that stays constant for that run
      # To use user6210, admin3418, or tester521361 multiple times in the same scenario, use user<c1>, admin<c2>, or tester<c3,6> respectively
      # 'user<l>' and 'user<s>' would have timestamp_long and timestamp_short appended respectively
      # 'user<m>' will have medidata date format appended
      # @param arg [string] argument to be converted
      def randomize_arg(arg, app='coder')
        re = /\<\w+.*\>/
        value = arg.strip

        if value =~ re # Check if it has randomize parameter
          rand_identifier = value.split('<').last
          rand_identifier = rand_identifier.split('>').first
          type_of_rand = rand_identifier[0]

          case type_of_rand
            when 'i' # Add a constant at the end of arg. Used by only coder as of now
              sub_const = $config['utils']['apps'][app][rand_identifier].to_s
              raise "Couldn't find #{rand_identifier} for app #{app} in config/utils/apps" if sub_const.empty?
              value = value.gsub('<' + rand_identifier + '>', sub_const)
            when 'c' # Add a fixed random number
              if rand_identifier.match(',')
                my_count = rand_identifier.split(',')
                count = my_count.first.gsub('c', '').to_i
                rand_val = my_count.last.to_i
              else
                count = rand_identifier.gsub('c', '').to_i
                rand_val = 4
              end

              rand_number = $faker.number.number(rand_val)

              unless $fix_randoms.has_key?(count)
                $fix_randoms.store(count, rand_number)
              end

              value = value.gsub('<' + rand_identifier + '>', $fix_randoms.fetch(count))
            when 'r' # Add random number(s) based on the number provided
              count = rand_identifier.gsub('r', '').to_i
              value = value.gsub('<' + rand_identifier + '>', $faker.number.number(count))
            when 'l' # timestamp long
              value = value.gsub('<' + rand_identifier + '>', $faker.timestamp_long)
            when 's' # timestamp short
              value = value.gsub('<' + rand_identifier + '>', $faker.timestamp_short)
            when 'm' # medidata date format
              value = value.gsub('<' + rand_identifier + '>', $faker.medidata_date_format)
            else
              raise "Unknown randomizer: #{type_of_rand}"
          end
        end
        value
      end

      # Converts and returns any item to symbol, replaces space with underscore
      # @param param [String]
      def symbolize_arg(param)
        if param.is_a? String
          param.downcase.gsub(' ', '_').to_sym
        else
          param
        end
      end

      #Returns the value of the sticky if it exist else it will return the value passed
      #@param name [String] Name of the sticky
      #@param value [String] Value is optional, nil by default
      def sticky_exist?(name, value=nil)
        name = symbolize_arg(name)
        if $sticky.has_key?(name)
          $sticky[name]
        else
          $sticky[name] = randomize_arg(value)
        end
      end

      # Creates a CSV file with specified data at given path
      # @param data [Hash] CSV data
      def create_csv(data, filepath)
        File.delete filepath if File.exists? filepath
        CSV.open(filepath, "wb") do |csv|
          csv << data.first.keys # adds the attributes name on the first line
          data.each do |hash|
            csv << hash.values
          end
        end
      end

      # Converts a page file name e.g. "Add Objective" to "add_objective" to be as a method name on a MediTAF::UI::Aplication object.
      # @param name [String] a page name expressed space-separated Camel Case
      # @return [String] a snake-case form of the "name"
      def to_page_file(name)
        name.gsub(/[\/ ]/, '_').downcase
      end
    end
  end
end
