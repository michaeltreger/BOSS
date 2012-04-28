class SubstitutionMailer < ActionMailer::Base
  default from: "bos-notifications@cafe.berkeley.edu"
  
  def posted_sub(sub)
    @sub = sub
    #mail(:to => sub.users[0].email, :subject => "Posted Sub")
    mail(:to => "michael.treger+bostesting@gmail.com", :subject => "Posted Sub")
  end
  
  def taken_sub(sub, targetUser)
    @sub = sub
    @targetUser = targetUser
    #mail(:to => targetUser.email, :subject => "Taken Sub")
    mail(:to => "michael.treger+bostesting@gmail.com", :subject => "Taken Sub")
  end

end
