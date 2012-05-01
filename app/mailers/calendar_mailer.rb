class CalendarMailer < ActionMailer::Base
  default from: "bos-notifications@cafe.berkeley.edu"
  
  def updated_calendar(calendar)
    @calendar = calendar
    #mail(:to => cal.user.email, :subject => "Updated Calendar").deliver
    #mail(:to => admins, :subject => "Updated Calendar").deliver
    #mail(:to => scheds, :subject => "Updated Calendar").deliver
    mail(:to => "michael.treger+bostesting@gmail.com", :subject => "Updated Calendar").deliver
  end
  
end
