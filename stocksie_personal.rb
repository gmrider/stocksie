#!/usr/bin/env ruby 

# need to work on the precision for rounding.  Using mixed floats and integers for approximations
require 'stocksie'
require 'stocksie_personal_config'
require 'optparse'
require 'yaml'


def stocksie_help
	puts
  puts "  Options:"
  puts "    [-c] [--config] configure evaluation data for script"
  puts "    [-m] shares vesting per month"
  puts "    [-M] dollar amount vesting per month"
  puts "    [-t] months vested"
  puts "    [-v] total shares vested"
  puts "    [-V] total dollar amount vested"
  puts "    [-r] unvested shares"
  puts "    [-R] unvested dollar amount"
  puts "    [-g] total options granted"
  puts "    [-G] total value of options granted"
  puts
end

def error_message
  puts 
  puts "ERROR:  Illegal option, for help use [help | -h | --help]"
  puts "usage:  [-c | --config | -m | -M | -t | -v | -V | -r | -R | -g | -G]"
  puts
  exit
end

if ARGV.empty?
	error_message
end

def load_data
  monies = YAML.load(File.open("./stocksie_data.yaml","r"))
	return monies
end

if File.exist?("./stocksie_data.yaml")
	monies = load_data
	config = StocksieConfig::Config.new
	# need to write a line to return an error message if an option doesn't exist
	OptionParser.new do |opts|
		opts.on('-c', '--config')  						{ config.config }
		opts.on('-h', '--help')								{ stocksie_help; exit }
		opts.on('-m')													{ puts config.indent + monies.monthly.to_s }
		opts.on('-M')													{ puts config.indent + "$" + monies.value_monthly.to_s }	
		opts.on('-t')													{ puts config.indent + monies.grant.months_at_company.to_s }
		opts.on('-v')													{ puts config.indent + monies.vest_total.to_s }
		opts.on('-V')													{ puts config.indent + "$" + monies.value_vested.to_s }
		opts.on('-r')													{ puts config.indent + monies.remaining.to_s }
		opts.on('-R')													{ puts config.indent + "$" + monies.value_remain.to_s }
		opts.on('-g')													{ puts config.indent + monies.grant.grant_total.to_s }
		opts.on('-G')													{ puts config.indent + "$" + monies.value_total.to_s }
		
		begin opts.parse!
		rescue OptionParser::InvalidOption => e
		  puts e
		  puts error_message
		  exit 1
		end
	end
	# if data file doesn't exist for serialization, you can still run config against the script
else
	config.config
end


