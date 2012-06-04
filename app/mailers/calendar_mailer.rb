class CalendarMailer < ActionMailer::Base
  default from: "boss.cafe1@gmail.com"

  def updated_calendar(calendar)
    @calendar = calendar
    subject = "[#{User.find(calendar.owner).initials}] Schedule Updated"
    mail(:to => calendar.user.email, :subject => subject).deliver
    if Group.find(User::ADMINISTRATOR) and Group.find(User::ADMINISTRATOR).email?
      mail(:to => Group.find(User::ADMINISTRATOR).email, :subject => subject).deliver
    end
    if Group.find(User::SCHEDULER) and Group.find(User::SCHEDULER).email?
      mail(:to => Group.find(User::SCHEDULER).email, :subject => subject).deliver
    end
  end

end
