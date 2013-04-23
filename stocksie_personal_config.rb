#!/usr/bin/env ruby

require 'stocksie'
require 'yaml'

module StocksieConfig
  class Config
    def indent
      "=> "
    end

    def spacing
      ">> "
    end

    def clear
      system("clear")
    end

    def get_input
      STDIN.gets.chomp
    end

		# input needed to evaluate company valuation
		# write logic for input validation, example, strike price must be >= 0
		# could rewrite each string as a class and could assign a method as a get_input method
		# duplicates messages keys to input keys setting ea
		# prints messages and returns user input to hash input
		# need to write input validation
		# learn reflection to determine data types.  Ideas for input validation.  learn reflection.
		def user_input_to_hash
			keys = [:common, :preferred, :valuation, :outstanding, :grant_date, 
							:grant_amount, :strike, :vesting_term, :vesting_cliff]

			values = []

			prompts = ["current strike price:  ", 
								"preferred price per share:  ", 
								"company valuation/market cap:  ", 
								"shares outstanding:  ", 
								"grant date (MM/DD/YYYY):  ", 
								"total shares granted:  ", 
								"strike price:  ", 
								"vesting term (in months):  ", 
								"vesting cliff (in months):  "]

			prompts.each { |x| print "#{spacing}#{x}"; values << get_input }
			Hash[keys.zip(values)]	
		end
		
    def initialize_stocksie
      arguments = user_input_to_hash
      company = CompanyVal.new(
        arguments[:common].to_f,
        arguments[:preferred].to_f,
        arguments[:valuation].to_i,
        arguments[:outstanding].to_i)
      grant = OptionsGrant.new(
        arguments[:grant_date],
        arguments[:grant_amount].to_i,
        arguments[:strike].to_f,
        arguments[:vesting_term].to_i,
        arguments[:vesting_cliff].to_i)
      options_vesting = OptionsVesting.new(company,grant)
      options_vesting
    end

    def save_data(object)
      File.open("stocksie_data.yaml", "w+") do |file|
        file.puts YAML.dump(object)
      end
    end

    def save_data_message
      if File.exist?("./stocksie_data.yaml")
        puts "#{indent}SUCCESS    Data configured"
        puts "      File: stocksie_data.yanl created in current directory"
        puts
      else
        puts "#{indent}ERROR    Config failed"
        puts "      File: stocksie_data.yanl not created"
        puts
      end
    end

    def config
      clear
      save_data(initialize_stocksie)
      save_data_message
    end
  end
end




