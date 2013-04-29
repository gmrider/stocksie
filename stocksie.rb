#!/usr/bin/env ruby

require 'date'

class CompanyVal
  attr_accessor :common_share, :preferred_share, :valuation, :outstanding_share
  
  def initialize (common_share=0, preferred_share=0,valuation=0, outstanding_share=0)
    @common_share = Float(common_share)
    @preferred_share = Float(preferred_share)
    @valuation = Integer(valuation)
    @outstanding_share = Integer(outstanding_share)
  end
end

class OptionsGrant
  attr_accessor :grant_date, :grant_total, :strike, :vesting_period, :vesting_cliff
  
  def initialize(grant_date=0, grant_total=0, strike=0, vesting_period=0, vesting_cliff=0)
    @grant_date = grant_date   
    @grant_total = Integer(grant_total)
    @strike = Float(strike)
    @vesting_period = Integer(vesting_period)
    @vesting_cliff = Integer(vesting_cliff)
=begin
    if vesting_period < vesting_cliff
      raise "ERROR:  Vesting cliff needs to be less than vesting period!"
    end
    if strike < 0 
      raise "ERROR:  Strike needs to be 0 or greater!"
    end
=end
  end

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