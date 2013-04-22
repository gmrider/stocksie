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

    def prompt_user_return_input
      # input needed to evaluate company valuation
      # write logic for input validation, example, strike price must be >= 0
      messages =  { 
        :common         => "current strike price:  ", 
        :preferred      => "preferred price per share:  ",
        :valuation      => "company valuation/market cap:  ",
        :outstanding    => "shares outstanding:  ", 
        :grant_date     => "grant date (MM/DD/YYYY):  ",
        :grant_amount   => "total shares granted:  ",
        :strike         => "strike price:  ",
        :vesting_term   => "vesting term (in months):  ",
        :vesting_cliff  => "vesting cliff (in months):  "}
      # duplicates messages keys to input keys setting each value to nil            
      input = {}
      input = messages.each { |key,val| input[key] = nil}
      # prints messages and returns user input to hash input
      # need to write input validation
      print "#{spacing}#{messages[:common]}"
        input[:common] = get_input.to_f
      print "#{spacing}#{messages[:preferred]}"
        input[:preferred] = get_input.to_f
      print "#{spacing}#{messages[:valuation]}"
        input[:valuation] = get_input.to_i
      print "#{spacing}#{messages[:outstanding]}"
        input[:outstanding] = get_input.to_i
      print "#{spacing}#{messages[:grant_date]}"
        input[:grant_date] = get_input
      print "#{spacing}#{messages[:grant_amount]}"
        input[:grant_amount] = get_input.to_i
      print "#{spacing}#{messages[:strike]}"
        input[:strike] = get_input.to_f
      print "#{spacing}#{messages[:vesting_term]}"
        input[:vesting_term] = get_input.to_i
      print "#{spacing}#{messages[:vesting_cliff]}"
        input[:vesting_cliff] = get_input.to_i
      input
    end

    def initialize_stocksie
      arguments = prompt_user_return_input
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




