class SubstitutionMailer < ActionMailer::Base
  default from: "bos-notifications@cafe.berkeley.edu"
  
  def posted_sub(sub)
    @sub = sub
    if @sub.to_user
      #mail(:to => sub.to_user.email, :subject => "Posted Sub").deliver
      #mail(:to => admins, :subject => "Posted Sub").deliver
      #mail(:to => scheds, :subject => "Posted Sub").deliver
    else
      #mail(:to => everyone, :subject => "Posted Sub").deliver
    end
    mail(:to => "michael.treger+bostesting@gmail.com", :subject => "#{sub.entry.start_time.strftime('%m/%d: %I:%M%p')} - #{sub.entry.end_time.strftime('%I:%M%p')} at #{sub.entry.lab.initials} (#{sub.from_user.initials})").deliver
  end
  
  def taken_sub(sub, targetUser)
    @sub = sub
    @targetUser = targetUser
    #mail(:to => targetUser.email, :subject => "Taken Sub").deliver
    #mail(:to => sub.from_user.email, :subject => "Taken Sub").deliver
    #mail(:to => admins, :subject => "Taken Sub").deliver
    #mail(:to => scheds, :subject => "Taken Sub").deliver
    mail(:to => "michael.treger+bostesting@gmail.com", :subject => "#{sub.entry.start_time.strftime('%m/%d: %I:%M%p')} - #{sub.entry.end_time.strftime('%I:%M%p')} at #{sub.entry.lab.initials} for #{sub.from_user.initials} taken by #{targetUser.initials}").deliver
  end

end
