include ActionView::Helpers::DateHelper



class SubstitutionsController < ApplicationController
  before_filter :check_admin_or_sched, :only => [:manage]

  # GET /substitutions
  # GET /substitutions.json

  def pass_filter?(s, filters, type)
    if filters[type + '_conflict'] && !@current_user.shift_calendar.canAdd(s.entry)
      return false
    end
    if filters[type + '_day'] && s.is_day?
      return false
    end
    if filters[type + '_evening'] && s.is_evening?
      return false
    end
    if filters[type + '_late_night'] && s.is_night?
      return false
    end
    return true
  end

  def index
    if !Rails.env.test?
      recycle
    end
    mysubs_sort = params[:mysubs_sort] || session[:mysubs_sort]
    subs_sort = params[:subs_sort] || session[:subs_sort]
    @filters = params[:filters] || {}
    if params[:filters] != session[:filters] && @filters != {}
      session[:filters] = @filters
      flash.keep
      redirect_to :filters => @filters, :mysubs_sort => mysubs_sort, :subs_sort => subs_sort and return
    end
    if params[:mysubs_sort] != session[:mysubs_sort]
      session[:filters] = @filters
      session[:mysubs_sort] = mysubs_sort
      flash.keep
      redirect_to :filters => @filters, :mysubs_sort => mysubs_sort, :subs_sort => subs_sort and return
    end
    if params[:subs_sort] != session[:subs_sort]
      session[:filters] = @filters
      session[:subs_sort] = subs_sort
      flash.keep
      redirect_to :filters => @filters, :mysubs_sort => mysubs_sort, :subs_sort => subs_sort and return
    end

    @substitutions = Substitution.all
    @my_subs = @substitutions.find_all{|s| s.from_user && s.from_user == @current_user}
    case mysubs_sort
    when 'time'
      @mysubs_time_header = 'hilite'
      @my_subs = @my_subs.sort_by{|s| s.entry.start_time}
    when 'location'
      @mysubs_location_header = 'hilite'
      @my_subs = @my_subs.sort_by{|s| (s.entry.lab ? s.entry.lab.initials : '')}
    when 'reserved_for'
      @mysubs_reserved_for_header = 'hilite'
      @my_subs = @my_subs.sort_by{|s| s.to_user ? s.to_user.initials : ''}
    end

    @reserved_subs = @substitutions.find_all{|s| pass_filter?(s, @filters, 'subs') && !(s.from_user == @current_user) && s.to_user && s.to_user==@current_user}
    @a_subs = @substitutions.find_all{|s| pass_filter?(s, @filters, 'subs') && !(s.from_user == @current_user) && (s.to_user == nil)}

    case subs_sort
    when 'time'
      @subs_time_header = 'hilite'
      @reserved_subs = @reserved_subs.sort_by{|s| s.entry.start_time}
      @a_subs = @a_subs.sort_by{|s| s.entry.start_time}
    when 'location'
      @subs_location_header = 'hilite'
      @reserved_subs = @reserved_subs.sort_by{|s| (s.entry.lab ? s.entry.lab.initials : '')}
      @a_subs = @a_subs.sort_by{|s| (s.entry.lab ? s.entry.lab.initials : '')}
    when 'posted_by'
      @subs_posted_by_header = 'hilite'
      @reserved_subs = @reserved_subs.sort_by{|s| (s.entry.lab ? s.entry.lab.initials : '')}
      @a_subs = @a_subs.sort_by{|s| s.from_user ? s.from_user.initials : ''}
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @substitutions }
    end
  end

  def recycle
    Substitution.all.each do |sub|
      if !sub.entry || (sub.entry.start_time < Time.current)
        sub.destroy
      end
    end
  end

  def manage
    @users = User.find(:all)
    if params[:entries]
      @entries = params[:entries].map { |e| Entry.find(e) }
      @substitution = Substitution.new
    else
      msubs_sort = params[:msubs_sort] || session[:msubs_sort]
      if params[:msubs_sort] != session[:msubs_sort]
        session[:msubs_sort] = msubs_sort
        flash.keep
        redirect_to :msubs_sort => msubs_sort and return
      end

      @substitutions = Substitution.all
      case msubs_sort
      when 'time'
        @msubs_time_header = 'hilite'
        @substitutions = @substitutions.sort_by{|s| s.entry.start_time}
      when 'location'
        @msubs_location_header = 'hilite'
        @substitutions = @substitutions.sort_by{|s| (s.entry.lab ? s.entry.lab.initials : '')}
      when 'posted_by'
        @msubs_posted_by_header = 'hilite'
        @substitutions = @substitutions.sort_by{|s| (s.from_user ? s.from_user.initials : '')}
      when 'reserved_for'
        @msubs_reserved_for_header = 'hilite'
        @substitutions = @substitutions.sort_by{|s| (s.to_user ? s.to_user.initials : '')}
      end

      @admin_allCalendars = Calendar.find_all_by_calendar_type(Calendar::SHIFTS)
      @admin_allCalendars.delete_if { |c| not c.user.activated }
      @admin_allCalendars = @admin_allCalendars.sort_by{|c| c.user.initials}
    end
    respond_to do |format|
      format.html
      format.json { render json: @substitutions }
    end
  end

  # GET /substitutions/new
  # GET /substitutions/new.json
  def new
    @entries = []
    shiftcalendars = @current_user.calendars.find_all{|c| c.calendar_type == Calendar::SHIFTS}
    shiftcalendars.each do |c|
      c.entries.each do |e|
        @entries << e
      end
    end
    @entries = @entries.find_all{|e| e.substitution.nil?}
    @users = User.find(:all, :conditions => ["id != ?", @current_user.id])
    @substitution = Substitution.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @substitution }
    end
  end

  def splitShift(sub_entry, params)
    orig_start = sub_entry.start_time
    orig_end = sub_entry.end_time
    partial_start = DateTime.parse(params[:partial_shift]["start(5i)"])
    partial_end = DateTime.parse(params[:partial_shift]["end(5i)"])
    partial_start = partial_start.change({:year => orig_start.year, :month => orig_start.month, :day => orig_start.day}).in_time_zone
    partial_end = partial_end.change({:year => orig_end.year, :month => orig_end.month}).in_time_zone
    partial_start = partial_start + 7.hours
    partial_end = partial_end + 7.hours
    if partial_end.hour > orig_end.hour
      partial_end = partial_end.change({:day => orig_start.day})
    else
      partial_end = partial_end.change({:day => orig_end.day})
    end
    if (orig_start > partial_start) || (partial_start >= partial_end) || (partial_end > orig_end)
      return nil
    end
    if partial_start > orig_start
      beforeEntry = sub_entry.dup
      beforeEntry.end_time = partial_start
      beforeEntry.save!
    end
    if partial_end < orig_end
      afterEntry = sub_entry.dup
      afterEntry.start_time = partial_end
      afterEntry.save!
    end
    sub_entry.start_time = partial_start
    sub_entry.end_time = partial_end
    sub_entry.save!
    return sub_entry
  end

  # POST /substitutions
  # POST /substitutions.json
  def create
    if params[:substitution][:entry].nil?
      flash[:error] = 'Please select a shift to substitute.'
      redirect_to new_substitution_path
      return
    end
    sub_entry = Entry.find(params[:substitution][:entry])
    # split shift into 3 pieces, sub the middle one
    if params[:partial_shift] && params[:partial_shift][:enabled] && params[:partial_shift][:enabled] == "1"
      s = splitShift(sub_entry, params)
      if s == nil
        flash[:error] = "Invalid partial shift times"
        redirect_to new_substitution_path
        return
      else
        sub_entry = s
      end
    end
    new_sub_params = {:entry => sub_entry,
                      :description => params[:substitution][:description]}
    @substitution = Substitution.new(new_sub_params)
    @substitution.entry_id = sub_entry.id
    from_user = User.find(sub_entry.calendar.user)
    @substitution.user_id = from_user.id
    if from_user
      @substitution.users << from_user
      if params[:user] && params[:user][:id] && params[:user][:id] != "" && User.find(params[:user][:id])
        to_user = User.find(params[:user][:id])
        @substitution.users << to_user
      end
    end
    respond_to do |format|
      if @substitution.is_expired?
        if from_user
          flash[:error] = "Expired Shift"
          format.html { redirect_to request.referer }
        else
          flash[:error] = "Expired Shift"
          format.html { redirect_to new_substitution_path }
        end
        format.json { render json: @substitution.errors, status: :unprocessable_entity }
      elsif @substitution.save
        SubstitutionMailer.posted_sub(@substitution)
        if request && request.referer && request.referer.include?('admin')
          format.html { redirect_to manage_substitutions_path, notice: 'Substitution was successfully created.' }
        else
          format.html { redirect_to substitutions_path, notice: 'Substitution was successfully created.' }
        end
        format.json { render json: @substitution, status: :created, location: @substitution }
      else
        if request && request.referer && request.referer.include?('admin')
          format.html { redirect_to request.referer, notice: 'Substitution could not be created.' }
        else
          format.html { redirect_to new_substitution_path, notice: 'Substitution could not be created.' }
        end
        format.json { render json: @substitution.errors, status: :unprocessable_entity }
       end
    end
  end

  # DELETE /substitutions/1
  # DELETE /substitutions/1.json
  def destroy
    @substitution = Substitution.find(params[:id])
    @substitution.destroy
    respond_to do |format|
      format.html { redirect_to substitutions_url }
      format.json { head :ok }
    end
  end

  def take_or_assign_subs
    if (params[:submit_type] && params[:submit_type][:delete])
      subs = params[:entries]
      subs.each_pair do |k,v|
        if v == "1"
          s = Substitution.find(k)
          s.destroy
        end
      end
      flash[:notice] = 'Substitutions were deleted successfully'
    elsif (params[:entries])
      selected_subs = params[:entries]
      targetUser = User.find(params[:target_user][:id])
      taken_subs = {}
      untaken_subs = {}
      error_message = ["The following subs could not be taken due to schedule conflicts or hour limits:"]
      selected_subs.each_pair do |k,v|
        if v == "1"
          currSub = Substitution.find(k)
          currEntry = currSub.entry
          targetCalendar = targetUser.shift_calendar
          if !(targetCalendar == nil) && (@current_user.isAdmin? || (targetCalendar.canAdd(currEntry)))
            taken_subs[k] = v
          else
            untaken_subs[k] = v
            e = Substitution.find(k).entry
            error_message << e.start_time.strftime('%a, %m/%d  ') + e.start_time.strftime('%I:%M%p') + ' -  ' + e.end_time.strftime('%I:%M%p')

          end
        end
      end

      taken_subs.each_pair do |k,v|
        if v == "1"
          currSub = Substitution.find(k)
          currEntry = currSub.entry
          targetCalendar = targetUser.shift_calendar
          currEntry.user = targetUser
          currEntry.substitution = nil
          currEntry.calendar = targetCalendar
          currEntry.save!
          SubstitutionMailer.taken_sub(currSub, targetUser)
          Substitution.delete(k)
        end
      end
      if untaken_subs.size == 0
        flash[:notice] = 'Substitutions were taken successfully'
      else
        flash[:error] = error_message.join("<br/>").html_safe
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :ok }
    end
  end
end
