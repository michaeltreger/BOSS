class ApplicationController < ActionController::Base
  helper_method :page_title
  protect_from_forgery
end
