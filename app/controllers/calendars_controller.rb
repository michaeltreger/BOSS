class CalendarsController < ApplicationController
  before_filter :check_login, :only => [:update]
  before_filter :check_admin, :only => [:admin, :destroy]

#  def check_admin
#    if !@current_user.isAdmin?
#      respond_to do |format|
#        format.html { redirect_to calendars_path, error: "You must be an admin to view this page" }
#        format.json { render json: "You must be an admin to view this page" }
#      end
#    end
#  end

#  def check_admin_or_s

  def check_login
    @calendar = Calendar.find(params[:id])
    if @calendar.owner != @current_user.id and !@current_user.isAdmin?
      respond_to do |format|
        format.html { redirect_to calendars_path, error: "You are not authorized to access this calendar" }
        format.json { render json: "You are not authorized to access this calendar" }
      end
    end
  end

  # GET /calendars
  # GET /calendars.json
  def index
    @user_calendars = @current_user.calendars
    @acalendars = @user_calendars.find_all{|c| c.calendar_type == Calendar::AVAILABILITY}
    @wcalendars = @user_calendars.find_all{|c| c.calendar_type == Calendar::SHIFTS}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @calendars }
    end
  end

  # GET /calendars/1
  # GET /calendars/1.json

  def manage
    @acalendars = Calendar.find_all_by_calendar_type(Calendar::AVAILABILITY)
    @wcalendars = Calendar.find_all_by_calendar_type(Calendar::SHIFTS)
    if !@acalendars
      @acalendars = []
    end
    if !@wcalendars
      @wcalendars = []
    end
    respond_to do |format|
      format.html
      format.json { render json: @acalendars }
    end
  end

  def show
    @calendar = Calendar.find(params[:id])
    if @calendar.availability? and @calendar.period
      @start_date = [Time.now.beginning_of_week + 14.days, @calendar.period.start_date.to_time.beginning_of_week].max
      @end_date = @start_date + 6.days
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json do
        results = {}

        if @calendar.lab?
          events = Entry.find_all_by_lab_id(@calendar.lab_id)
        else
          events = @calendar.entries.select([:id, :start_time, :end_time, :description, :entry_type])
        end

        if @calendar.availability?
          events.each do |e|
            if e.entry_type == "closed"
              e[:readOnly] = true
            end
            e.start_time = e.start_time + (@start_date-e.start_time.beginning_of_week)
            e.end_time = e.end_time + (@start_date-e.end_time.beginning_of_week)
          end
          results[:start_date] = @start_date
          results[:end_date] = @start_date + 6.days
        end
        
        if @current_user.id != @calendar.owner
          events.each do |e|
            e[:readOnly] = true
          end
        end

        results[:events] = events

        render json: results
      end
    end
  end

  # GET /calendars/new
  # GET /calendars/new.json
  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @calendar }
    end
  end

  # GET /calendars/1/edit
  def edit
    @calendar = Calendar.find(params[:id])
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(params[:calendar])
    if @current_user
      @calendar.user_id = @current_user.id
    end
    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render json: @calendar, status: :created, location: @calendar }
      else
        format.html { render action: "new" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /calendars/1
  # PUT /calendars/1.json
  def update
    @calendar = Calendar.find(params[:id])
    if @calendar.owner == @current_user.id and params[:calendar_updates]
      update_entries(params[:calendar_updates])
    end

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        format.html { redirect_to calendars_path, notice: 'Calendar was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_entries(json)
    parsed_json = ActiveSupport::JSON.decode(json)
    @calendar.update_calendar(parsed_json)
    @calendar.updated_at = DateTime.now
    
    if @calendar.save
      render json: "success"
    else
      render json: @calendar.errors
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to '/admin/calendars' }
      format.json { head :ok }
    end
  end

  def snapshot
    @cal = {}
    @start_time = Time.now.beginning_of_week + 7.days
    time = @start_time
    endTime = time + 7.days

    users = []
    User.where(:activated=>true).each do |u|
      users << u.initials
    end

    while time < endTime
      @cal[time] = Array.new(users)
      time += 30.minutes
    end
    
    start = Time.now.beginning_of_week + 7.days
    User.find_all_by_activated(true).each do |u|
      u.availability_calendar(@current_period).entries.each do |e|
        if e.unavailable?
          time = e.start_time + (start - e.start_time.beginning_of_week)
          endTime = e.end_time + (start - e.end_time.beginning_of_week)
          while time < endTime
            @cal[time.to_time].delete(User.find(e.calendar.user_id).initials)
            time += 30.minutes
          end
        end
      end
    end

    #c = Calendar.create(:name=>"Availability Snapshot taken #{Time.now.strftime('%m/%d/%Y %I:%M%p')}", :calendar_type=>Calendar::SNAPSHOT, :period_id=>@current_period.id)
    #cal.each_pair do |time ,users|
    #  c.entries << Entry.create(:start_time=>time, :end_time=>time+30.minutes, :entry_type=>"", :description=>users)
    #end
    #c.save!
    #redirect_to c
  end

  def mrclean

  end

end
