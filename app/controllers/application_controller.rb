class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :page_title
  helper_method :current_user

  before_filter :check_init
  if Rails.env.test?
    before_filter :test_set_current_user
  else
    before_filter CASClient::Frameworks::Rails::Filter, :unless => :skip_calnet?
    before_filter :set_current_user
    before_filter :check_login
  end
  before_filter :check_admin_or_sched
  before_filter :set_period

  def skip_calnet?
    return false
  end

  def test_set_current_user
    @current_user = User.find_by_id(session[:test_user_id])
    if @current_user.nil?
        def @current_user.isAdmin?
            false
        end
    end
  end

  def set_period
    @current_period = Period.current
    if @current_period.nil?
      if @current_user && !@current_user.isAdmin?
        flash[:error] = "No Period is Currently Active - Please Contact an Administrator"
        redirect_to '/'
      elsif @current_user
        flash[:error] = "No Period is Currently Active - Some Pages May Fail to Load"
      end
    end
    aerawer
    if @current_user
      if @current_period
        @current_availability = @current_user.availability_calendar(@current_period)
      end
      @current_workschedule = @current_user.shift_calendar
    end
  end

  def set_current_user
    if !session[:cas_user]
      @current_user = nil
    else
      @current_user = User.find_by_cas_user(session[:cas_user])
    end
    if @current_user.nil?
        def @current_user.isAdmin?
            false
        end
        def @current_user.isAdminOrScheduler?
            false
        end
        def @current_user.isScheduler?
            false
        end
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
    if @current_user.nil? and request.fullpath != '/' and areAdmins?
      redirect_to '/'
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
    if request.fullpath == '/admin/init' and areAdmins?
        redirect_to '/'
    end
    if not areAdmins?
        ApplicationController.skip_filter _process_action_callbacks.map(&:filter)
        redirect_to '/admin/init' unless request.fullpath == '/admin/init'
    end
  end

  def areAdmins?
    Group.find_or_create_by_name("Administrators").users.length != 0 or Group.find_by_name("Schedulers").users.length != 0
  end
end

