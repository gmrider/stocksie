#!/usr/bin/env ruby 

# need to work on the precision for rounding.  Using mixed floats and integers for approximations
# If ./company_valation.txt and ./personal_grant.txt do not exist it will throw an error, need to write exception handling
# Ideally, it will determine whether ./company_valuation.txt and ./personal_grant.txt exit
# then prompt user to run config before trying other command line options.
# input on config method needs to be able to parse $2000 into 2000 as a int or float.
# if no command line options return an error requiring options.
# at some point may want to use optparse library, keep pushing this for fun...
 
require 'stocksie'

def indent
  "=> "
end

def spacing
  ">> "
end

def config
  ARGV.clear
  system("clear")

# input needed to evaluate the company stock grant  
  company_data = []
  print spacing + "current strike price:  "
  company_data << gets.chomp
  print spacing + "preferred price per share:  "
  company_data << gets.chomp
  print spacing + "company valuation/market cap:  "
  company_data << gets.chomp
  print spacing + "shares outstanding:  "
  company_data << gets.chomp

# input needed to evaluate personal options grant   
  personal_data = []
  print spacing + "grant Date (MM/DD/YYYY):  "
  personal_data << gets.chomp
  print spacing + "total shares granted:  "
  personal_data << gets.chomp
  print spacing + "stike price:  "
  personal_data << gets.chomp
  print spacing + "vesting term (in months):  "
  personal_data << gets.chomp
  print spacing + "vesting cliff (in months):  "
  personal_data << gets.chomp
  puts

#write company valutions data to a file called company_valution.txt
  output_data_company = company_data.join(',')
  company_file = File.open("company_valuation.txt",'w+')
  company_file.puts output_data_company
  company_file.close
  puts indent + "SUCCESS    Company data configured"
  puts "      File: company valution.txt created in current directory"

#write personal grant data to a file called personal_grant.txt
  output_data_personal = personal_data.join(',')
  personal_file = File.open("personal_grant.txt",'w+')
  personal_file.puts output_data_personal
  personal_file.close
  puts indent + "SUCCESS    Personal data configured"
  puts "      File: personal_grant.txt created in current directory"
end

if ARGV.empty?
  puts 
  puts "ERROR:  Illegal option, for help use [help | -h | --help]"
  puts "usage:  [-c | --config | -m | -M | -mv | -t | -T | -r | -R | -g | -G]"
  puts
  exit
end

if File.exist?("./company_valuation.txt") && File.exist?("./personal_grant.txt")
  company_info = File.read("company_valuation.txt").split(',')
      a = company_info[0].to_f
      b = company_info[1].to_f
      c = company_info[2].to_f
      d = company_info[3].to_i
  
  personal_info = File.read("personal_grant.txt").split(',')
      e = personal_info[0]
      f = personal_info[1].to_i
      g = personal_info[2].to_f
      h = personal_info[3].to_i
      i = personal_info[4].to_i   
    
  valuation_data = CompanyVal.new(a, b, c, d)
  options_data = OptionsGrant.new(e, f, g, h, i)
  monies = OptionsVesting.new(valuation_data, options_data) 
      
  vesting = ARGV[0].clone
  ARGV.clear

  # switch for selecting command line option
  case vesting
  when "-c", "--config"                                     # configure data for evaluation
    config
  when "-m"                                                 # shares vesting per month
    puts indent + monies.monthly.to_s
  when "-M"                                                 # dollar amount vesting per month
    puts indent + "$" + monies.value_monthly.to_s
  when "-mv"                                                # months vested
    puts indent + options_data.months_vested.to_s
  when "-t"                                                 # total shares vested
    puts indent + monies.vest_total.to_s
  when "-T"                                                 # total dollar amount vested
    puts indent + "$" + monies.value_vested.to_s
  when "-r"                                                 # number of shares remaining to be vested
    puts indent + monies.remaining.to_s
  when "-R"                                                 # total dollar amount of remaining shares
    puts indent + "$" + monies.value_remain.to_s
  when "-g"                                                 # total options granted
    puts indent + options_data.grant_total.to_s
  when "-G"                                                 # total value of options granted
    puts indent + "$" + monies.value_total.to_s
  when "-h", "--help"                                       # return options available on command line
    puts
    puts "  Options:"
    puts "    [-c] [--config] configure evaluation data for script"
    puts "    [-m] shares vesting per month"
    puts "    [-M] dollar amount vesting per month"
    puts "    [-mv] months vested"
    puts "    [-t] total shares vested"
    puts "    [-T] total dollar amount vested"
    puts "    [-r] unvested shares"
    puts "    [-R] unvested dollar amount"
    puts "    [-g] total options granted"
    puts "    [-G] total value of options granted"
    puts
  else
    puts
    puts "  ERROR:  Illegal option [#{vesting}], for help use [help | -h | --help]"
    puts "  usage:  [-c | --config | -m | -M | -mv | -t | -T | -r | -R | -g | -G]"
    puts
  end

elsif ARGV[0] == "-c" || ARGV[0] == "--config" 
  config

else
  puts "ERROR:  Please configure script to use"
  puts "to configure: COMMAND/PATH [ -c | --config]"
end

    

    

