class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :page_title
  helper_method :current_user

  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :set_current_user

  def set_current_user
    if !session[:cas_user]
      @current_user = nil
    else
      @current_user = User.find_by_cas_user(session[:cas_user])
    end
  end

  def ldapparams
    ldap = Net::LDAP.new
    ldap.host = "ldap-test.berkeley.edu"
    filter = Net::LDAP::Filter.eq( "uid", session[:cas_user])
    attrs = []

    @ldapparams = Hash.new

    ldap.search( :base => "ou=people,dc=berkeley,dc=edu", :filter => filter, :return_result => true ) do |entry|

      entry.attribute_names.each do |n|
        @ldapparams[n] = entry[n]
      end
    end
  end


end
