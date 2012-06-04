class SubstitutionMailer < ActionMailer::Base
  default from: "boss.cafe1@gmail.com"

  def posted_sub(sub)
    @sub = sub
    subject = "#{sub.entry.start_time.strftime('%m/%d: %I:%M%p')} - #{sub.entry.end_time.strftime('%I:%M%p')} at #{sub.entry.lab.initials} (#{sub.from_user.initials})"
    if @sub.to_user
      mail(:to => sub.to_user.email, :subject => subject).deliver
      if Group.find(User::ADMINISTRATOR)
        mail(:to => Group.find(User::ADMINISTRATOR).email, :subject => subject).deliver
      end
      if Group.find(User::SCHEDULER)
        mail(:to => Group.find(User::SCHEDULER).email, :subject => subject).deliver
      end
    else
      mail(:to => Group.find(User::ALL_USERS).email, :subject => subject).deliver
    end
  end

  def taken_sub(sub, targetUser)
    @sub = sub
    @targetUser = targetUser
    subject = "#{sub.entry.start_time.strftime('%m/%d: %I:%M%p')} - #{sub.entry.end_time.strftime('%I:%M%p')} at #{sub.entry.lab.initials} for #{sub.from_user.initials rescue 'XX'} taken by #{targetUser.initials}"
    if targetUser
      mail(:to => targetUser.email, :subject => subject).deliver
    end
    if sub.from_user
      mail(:to => sub.from_user.email, :subject => subject).deliver
    end
    if Group.find(User::ADMINISTRATOR)
      mail(:to => Group.find(User::ADMINISTRATOR).email, :subject => subject).deliver
    end
    if Group.find(User::SCHEDULER)
      mail(:to => Group.find(User::SCHEDULER).email, :subject => subject).deliver
    end
  end
end
