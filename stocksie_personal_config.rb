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

    # got input validation to work, validates input less than 0 and a data format
    # re-write at some point to make cleaner.  Possibly break into a class or other methods.
    def get_input_and_validate(prompt)
      begin
      x = STDIN.gets.chomp
        unless prompt.include? "MM/DD/YYYY"
          x = Float(x)
          raise ArgumentError, "#{indent}Input can't be less than 0 :)" if x < 0
        else 
          raise ArgumentError, "#{indent}Input should be date format MM/DD/YYYY :)" if x.match(/\d?\d\/\d{2}\/\d{4}/) == nil    
          x = x
        end
      rescue ArgumentError => e
          puts e.message
          print "#{spacing}Please try again:  "
          retry
      end
      return x
    end
    
    # input needed to evaluate company valuation
    # could rewrite each string as a class and could assign a method as a get_input method
    # duplicates messages keys to input keys setting ea
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

      prompts.each { |x| print "#{spacing}#{x}"; values << get_input_and_validate(x) }
      Hash[keys.zip(values)]  
    end

    # need to find a better way to initialize objects
    def initialize_stocksie
      arguments = user_input_to_hash
      company = CompanyVal.new(
        arguments[:common],
        arguments[:preferred],
        arguments[:valuation],
        arguments[:outstanding])
      grant = OptionsGrant.new(
        arguments[:grant_date],
        arguments[:grant_amount],
        arguments[:strike],
        arguments[:vesting_term],
        arguments[:vesting_cliff])
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
        puts "      File: stocksie_data.yaml created in current directory"
        puts
      else
        puts "#{indent}ERROR    Config failed"
        puts "      File: stocksie_data.yaml not created"
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




