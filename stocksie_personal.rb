#!/usr/bin/env ruby 
# need to work on the precision for rounding.  Using floats and integers for approximations

require 'stocksie'

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

puts
puts "$$$$$ Let me tell you about your options $$$$$"
puts "--#{options_data.months_vested} months vested."
puts "--$#{monies.value_vested} vested based on current valuation."
puts "--Currently vesting at a rate of #{monies.monthly} shares/month." 
puts "--That's about $#{monies.value_monthly} per month."
puts
