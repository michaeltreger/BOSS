class ApplicationController < ActionController::Base
  has_mobile_fu
  protect_from_forgery

  helper_method :page_title
  helper_method :current_user

  if Rails.env.test?
    before_filter :test_set_current_user
  else
    before_filter CASClient::Frameworks::Rails::Filter
    before_filter :check_init
    before_filter :set_current_user
    before_filter :set_period
    before_filter :check_login
  end
  before_filter :check_admin_or_sched

  def test_set_current_user
    @current_user = User.find_by_id(session[:test_user_id])
  end

  def set_period
    @current_period = Period.current
    @current_availability = @current_user.availability_calendar(@current_period)
    @current_workschedule = @current_user.shift_calendar
  end

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

  def check_login
    if @current_user.nil? and not session[:cas_user].nil? and request.fullpath != '/join'
      if not request.post? and request.fullpath != '/admin/users/'
          redirect_to '/join'
      end
    end
  end

  def check_admin
    if not @current_user.nil?
        if not @current_user.isAdmin? and request.fullpath[/^\/admin/]
            flash[:error] = "You must be an administrator to perform that action."
            redirect_to :back
        end
    end
  end

  def check_admin_or_sched
    if not @current_user.nil?
        if not @current_user.isAdminOrScheduler? and request.fullpath[/^\/admin/]
            flash[:error] = "You do not have the correct privileges to access that page."
            redirect_to :back
        end
    end
  end

  def check_init
    if request.fullpath == '/admin/init' and not User.where("user_type = '-1' OR user_type = '0'").empty?
        redirect_to '/'
    end
    if User.where("user_type = '-1' OR user_type = '0'").empty?
        ApplicationController.skip_filter _process_action_callbacks.map(&:filter)
        redirect_to '/admin/init' unless request.fullpath == '/admin/init'
    end
  end
end
