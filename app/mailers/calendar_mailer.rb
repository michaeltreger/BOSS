class CalendarMailer < ActionMailer::Base
  default from: "boss.cafe1@gmail.com"
  
  def updated_calendar(calendar)
    @calendar = calendar
    subject = "[#{User.find(calendar.owner).initials}] Schedule Updated"
    mail(:to => calendar.user.email, :subject => subject).deliver
    mail(:to => Group.find(User::ADMINISTRATOR).email, :subject => subject).deliver
    mail(:to => Group.find(User::SCHEDULER).email, :subject => subject).deliver
  end
  
end
