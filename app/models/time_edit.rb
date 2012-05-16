class TimeEdit < ActiveRecord::Base
  validates_presence_of :user_id, :calendar_id, :start_time, :duration

  def pay_period
    pay_period = start_time.month + start_time.year * 13  
    if start_time.day >= 15
      pay_period += 1
    end
    return pay_period
  end
end
