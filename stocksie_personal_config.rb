#!/usr/bin/env ruby

require 'stocksie'
require 'yaml'

module StocksieConfig
  class Formatting  
    def indent
      "=> "
    end

    def spacing
      ">> "
    end

    def clear
      system("clear")
    end
  end

  class Data < Formatting
    # input needed to evaluate company valuation
    # could rewrite each string as a class and could assign a method as a get_input method
    def company_hash
      company = {
        :keys => [
          :common_share, 
          :preferred_share, 
          :valuation, 
          :outstanding_share, 
          ],
        :prompts => [
          "current strike price:  ", 
          "preferred price per share:  ", 
          "company valuation/market cap:  ", 
          "shares outstanding:  "
          ]
        }
    end
    
    def grant_hash
      grant = {
        :keys => [  
          :grant_date, 
          :grant_total, 
          :strike, 
          :vesting_period, 
          :vesting_cliff
          ],
        :prompts => [
          "grant date (MM/DD/YYYY):  ", 
          "total shares granted:  ", 
          "strike price:  ", 
          "vesting term (in months):  ", 
          "vesting cliff (in months):  "
          ]
        }
    end
  end


  class Config < Data
    # got input validation to work, validates input less than 0 and a data format
    # re-write at some point to make cleaner.  Possibly break into a class or other methods.    
    def get_input_and_validate(prompt)
      begin
        x = STDIN.gets.chomp
        unless prompt.include? "MM/DD/YYYY"
          x = Float(x)
          raise ArgumentError, "#{indent}Input can't be less than 0 :)" if x < 0
        else 
          raise ArgumentError, "#{indent}Input should be date format MM/DD/YYYY :)" if x.match(/\d?\d\/\d?\d\/\d{4}/) == nil    
          x = x
        end
      rescue ArgumentError => e
          puts e.message
          print "#{spacing}Please try again:  "
          retry
      end
      return x
    end
    
    def prompt_to_hash(hash = {})
      values = []
      hash[:prompts].each { |prompt| print "#{spacing}#{prompt}" ; values << get_input_and_validate(prompt) } 
      Hash[hash[:keys].zip(values)]
    end
    
    def initialize_stocksie
      OptionsVesting.new(CompanyVal.new(prompt_to_hash(company_hash)),OptionsGrant.new(prompt_to_hash(grant_hash)))
    end

    def save_data(object)
      File.open("stocksie_data.yaml", "w+") { |file| file.puts YAML.dump(object) }
    end

    def save_data_message
      success = ["\n", "#{indent}SUCCESS    Data configured", "      File: stocksie_data.yaml created in current directory", "\n"]
      failure = ["\n", "#{indent}ERROR    Config failed", "      File: stocksie_data.yaml not created", "\n"]
      return success.each { |line| puts line } if File.exist?("./stocksie_data.yaml")
      failure.each { |line| puts line }
    end

    def config
      clear
      save_data(initialize_stocksie)
      save_data_message
    end
  end
end




