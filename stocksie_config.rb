#!/usr/bin/env ruby -wKU
# this is a script to write config files that will be used by stocksie_magic
# to determine company valuation data and personal grant info

system("clear")

puts "***Configuring Company Data***"
print "company name:  "  
company_name = gets.chomp

company_data = []
print "common price per share (current strike/409a):  "
company_data << gets.chomp
print "preferred price per share:  "
company_data << gets.chomp
print "company valuation/market cap:  "
company_data << gets.chomp
print "number of outstanding shares:  "
company_data << gets.chomp

puts

puts "***Configuring Personal Data***"
personal_data = []
print "what is your grant date (MM/DD/YYYY):  "
personal_data << gets.chomp
print "how many shares where you granted:  "
personal_data << gets.chomp
print "what is your strike price:  "
personal_data << gets.chomp
print "over how many months does your initial grant vest:  "
personal_data << gets.chomp
print "what is your vesting cliff (in months):  "
personal_data << gets.chomp

puts

#write company valutions data to a file called company_valution.txt
output_data_company = company_data.join(',')
company_file = File.open("company_valuation.txt",'w+')
company_file.puts output_data_company
company_file.close


#write personal grant data to a file called personal_grant.txt
output_data_personal = personal_data.join(',')
personal_file = File.open("personal_grant.txt",'w+')
personal_file.puts output_data_personal
personal_file.close
