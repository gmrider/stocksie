#!/usr/bin/env ruby

class CompanyVal
  attr_accessor :common_share, :preferred_share, :valuation, :outstanding_share
  
  def initialize (common_share, preferred_share,valuation, outstanding_share)
    @common_share = common_share
    @preferred_share = preferred_share
    @valuation = valuation
  end
end

class OptionsGrant
#need to add some edge cases.  ie months_vested can't be more than the vesting period
#also, tie vesting cliff to when actual vesting occurs

  attr_accessor :grant_date, :grant_total, :strike, :vesting_period, :vesting_cliff
  
  def initialize(grant_date, grant_total, strike, vesting_period, vesting_cliff)
    @grant_date = grant_date   
    @grant_total = grant_total
    @strike = strike
    @vesting_period = vesting_period
    @vesting_cliff = vesting_cliff
  end
  
  def months_vested
    x = grant_date.split('/')
    month = x[0].to_i
    day = x[1].to_i
    year = x[2].to_i
    date_current = Time.new
    date_start = Time.mktime(year,month,day)
    months = (date_current.year * 12 + date_current.month) - (date_start.year * 12 + date_start.month)
    if (date_current.day - date_start.day) < 0
      months - 1
    else
      months
    end  
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

  def remaining
    self.grant.grant_total - (self.monthly * self.grant.months_vested)
  end
  
  def vest_total
    (self.monthly * self.grant.months_vested).to_i
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