class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :page_title
  helper_method :current_user


  if Rails.env.test?
    before_filter :test_set_current_user
  else
    before_filter CASClient::Frameworks::Rails::Filter
    before_filter :set_current_user
    before_filter :set_period_and_calendars
    before_filter :check_login
    before_filter :check_admin
  end
  #NOTE: If you're looking for the helper methods.
  #      I moved them all to ../helper/application_helper.rb
  #      I believe this is proper DRY rails convention.

end
