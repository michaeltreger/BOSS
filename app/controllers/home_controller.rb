class HomeController < ApplicationController
  if !Rails.env.test?
    before_filter CASClient::Frameworks::Rails::GatewayFilter
    skip_before_filter :check_login
  end

  def skip_calnet?
    return true
  end

  def error
  end

  def maintenance
  end

  def index
    @login_url = CASClient::Frameworks::Rails::Filter.login_url(self)
    set_current_user()
  end

end
