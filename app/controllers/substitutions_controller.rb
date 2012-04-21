class SubstitutionsController < ApplicationController
  # GET /substitutions
  # GET /substitutions.json
  def index
    @substitutions = Substitution.all
    @my_subs = @substitutions.find_all{|s| s.users.size >= 1 && s.users[0] == @current_user}
    if @current_user.isAdmin?
      @reserved_subs = @substitutions.find_all{|s| !(s.users[0] == @current_user) && s.users.size==2}
    else
      @reserved_subs = @substitutions.find_all{|s| !(s.users[0] == @current_user) && s.users.size==2 && s.users[1]==@current_user}
    end
    @available_subs = @substitutions.find_all{|s| !(s.users[0] == @current_user) && (!(s.users.size==2) || !(s.users[1]==@current_user))}

    @mycalendars = @current_user.calendars
    @mycalendars = @mycalendars.find_all{|c| c.calendar_type == Calendar::SHIFTS}

    if @current_user.isAdmin?
      @admin_allCalendars = Calendar.find_all_by_calendar_type(Calendar::SHIFTS)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @substitutions }
    end
  end

  # GET /substitutions/1
  # GET /substitutions/1.json
# this is pretty useless
#  def show
#    @substitution = Substitution.find(params[:id])
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @substitution }
#    end
#  end

  # GET /substitutions/new
  # GET /substitutions/new.json
  def new
    @entries = []
    @current_user.calendars.each do |c|
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

  # GET /substitutions/1/edit
  def edit
    @substitution = Substitution.find(params[:id])
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
        flash[:error] = "Invalid partial shift times"
        redirect_to new_substitution_path
        return
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
    end
    new_sub_params = {:entry => sub_entry,
                      :description => params[:substitution][:description]}
    @substitution = Substitution.new(new_sub_params)
    @substitution.entry_id = sub_entry.id
    from_user = User.find(params[:substitution][:from_user])
    @substitution.user_id = from_user.id
    if from_user
      @substitution.users << from_user
      if params[:user] && params[:user][:id] && params[:user][:id] != "" && User.find(params[:user][:id])
        to_user = User.find(params[:user][:id])
        @substitution.users << to_user
      end
    end
    respond_to do |format|
      if @substitution.save
        format.html { redirect_to new_substitution_path, notice: 'Substitution was successfully created.' }
        format.json { render json: @substitution, status: :created, location: @substitution }
      else
        format.html { redirect_to new_substitution_path, notice: 'Substitution could not be created.' }
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
    if (params[:calendar][:id]) && (params[:entries])
      targetCalendar = Calendar.find(params[:calendar][:id])
      taken_subs = params[:entries]
      taken_subs.each_pair do |k,v|
        if v == "1"
          currSub = Substitution.find(k)
          currEntry = currSub.entry
          currEntry.user = targetCalendar.user
          currEntry.substitution = nil
          currEntry.calendar = targetCalendar
          currEntry.save!
          Substitution.delete(k)
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to substitutions_url }
      format.json { head :ok }
    end
  end
end
