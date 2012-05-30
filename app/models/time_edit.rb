class TimeEdit < ActiveRecord::Base
  validates_presence_of :user_id, :calendar_id, :start_time, :duration

  def pay_period
    TimeEdit.pay_period_function(start_time)
  end
  
  def self.pay_period_function(time)
    pay_period = time.month + time.year * 13  
    if time.day >= 15
      pay_period += 1
    end
    return pay_period
  end
end
