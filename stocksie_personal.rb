#!/usr/bin/env ruby 

require 'stocksie'
require 'stocksie_personal_config'
require 'optparse'
require 'yaml'

def load_or_config(config)
  if File.exist?("./stocksie_data.yaml")
    YAML.load(File.open("./stocksie_data.yaml","r"))
  else
    config.config
  end 
end

# need to refactor options output. current string chaining is ugly. 
# learn to iterate through a hash of nested arrays
def optparse(monies,config) 
  OptionParser.new(banner = nil, width = 15, indent =' ' * 4) do |opts|  
    opts.banner = "Usage:  #{$0} [-option]"
    opts.on('-c', '--config', 'configure evaluation data for script')   { config.config }
    opts.on('-m', 'shares vesting per month')                           { puts "#{config.indent}#{monies.monthly}" }
    opts.on('-M', 'dollar amount vesting per month')                    { puts "#{config.indent}$#{monies.value_monthly}" }  
    opts.on('-t', 'months vested')                                      { puts "#{config.indent}#{monies.grant.months_at_company}" }
    opts.on('-v','total shares vested')                                 { puts "#{config.indent}#{monies.vest_total}" }
    opts.on('-V', 'total dollar amount vested')                         { puts "#{config.indent}$#{monies.value_vested}" }
    opts.on('-r', 'unvested shares')                                    { puts "#{config.indent}#{monies.remaining}" }
    opts.on('-R', 'unvested dollar amount')                             { puts "#{config.indent}$#{monies.value_remain}" }
    opts.on('-g', 'total options granted')                              { puts "#{config.indent}#{monies.grant.grant_total}" }
    opts.on('-G', 'total value of options granted')                     { puts "#{config.indent}$#{monies.value_total}" }
    opts.help
    opts.on_head('Options:')
  end
end

def parse_option(optparse)
  if ARGV.empty?
    puts optparse.banner
  elsif ARGV[0] == "-" || ARGV[0].match(/^[a-zA-Z]/)
    puts optparse
  else
    begin optparse.parse!
    rescue OptionParser::InvalidOption => e
      puts e
      puts optparse
      exit 1
    end
  end
end


config = StocksieConfig::Config.new
parse_option(optparse(load_or_config(config),config))
