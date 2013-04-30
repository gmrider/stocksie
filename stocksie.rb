#!/usr/bin/env ruby

require 'date'

class CompanyVal
  attr_reader :common_share, :preferred_share, :valuation, :outstanding_share
  
  def initialize(options)
    options.each do |opt,val|
      send("#{opt}=", val) if respond_to? "#{opt}="
    end
  end
  
  def common_share=(x)
    @common_share= Float(x)
  end
  
  def preferred_share=(x)
    @preferred_share= Float(x)
  end
  
  def valuation=(x)
    @valuation= Integer(x)
  end
  
  def outstanding_share=(x)
    @outstanding_share= Integer(x)
  end
end

class OptionsGrant
  attr_reader :grant_date, :grant_total, :strike, :vesting_period, :vesting_cliff
  
  def initialize(options = {})
    options.each do |opt,val|
      send("#{opt}=", val) if respond_to? "#{opt}="
    end
  end
  
  def grant_date=(x)
    @grant_date= String(x)
  end
  
  def grant_total=(x)
    @grant_total= Integer(x)
  end
  
  def strike=(x)
    @strike = Float(x)
  end
  
  def vesting_period=(x)
    @vesting_period= Integer(x)
  end
  
  def vesting_cliff=(x)
    @vesting_cliff= Integer(x)
  end
  
=begin
    if vesting_period < vesting_cliff
      raise "ERROR:  Vesting cliff needs to be less than vesting period!"
    end
    if strike < 0 
      raise "ERROR:  Strike needs to be 0 or greater!"
    end
=end
  #write logic that checks to make sure that the months that have passed are greater than the vesting cliff
  def months_at_company
    date_current = Time.new
    date_start = Date.strptime(grant_date, "%m/%d/%Y")
    months = (date_current.year * 12 + date_current.month) - (date_start.year * 12 + date_start.month)
    return months - 1 if date_current.day - date_start.day < 0
    return months
  end
end

class OptionsVesting
  attr_accessor :company, :grant
  attr_reader :value_per_share
  
  def initialize(company, grant)
    @company = company
    @grant = grant
  end
  
  def monthly
    self.grant.grant_total / self.grant.vesting_period
  end

  def months_vested
    if grant.months_at_company < grant.vesting_cliff
      return 0
    else
      grant.months_at_company
    end
  end

  def remaining
    self.grant.grant_total - (self.monthly * self.grant.months_at_company)
  end
  
  def vest_total
    (self.monthly * self.grant.months_at_company).to_i
  end
  
  def value_per_share
    @value_per_share = self.company.preferred_share - self.grant.strike
  end
  
  def value_monthly
    (self.value_per_share * self.monthly).to_i
  end
  
  def value_total
    (self.value_per_share * self.grant.grant_total).to_i
  end
  
  def value_vested
    (self.value_per_share * self.vest_total).to_i
  end
  
  def value_remain
    (self.value_total - self.value_vested).to_i
  end
end