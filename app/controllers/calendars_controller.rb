class CalendarsController < ApplicationController
  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @calendars }
    end
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
    @calendar = Calendar.find(params[:id])
    @events = Entry.find_all_by_calendar_id(params[:id], :select=>[:id, :start_time, :end_time, :description, :entry_type] )

    if @calendar.owner != @current_user.id
      if @current_user.isAdmin?
        @events.each do |e|
          e[:readOnly] = true
          @disable_submit = true
        end
      else
        flash[:error] = "You are not authorized to view this calendar"
      end
    end
    @page_title = "My Calendar"

    respond_to do |format|
      if flash[:error]
        format.html # show.html.erb
        format.json { render json: flash }
      else
        format.html # show.html.erb
        format.json { render json: @events }
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
      parsed_json = ActiveSupport::JSON.decode(params[:calendar_updates])
      @calendar.update_calendar(parsed_json)
    end

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to calendars_url }
      format.json { head :ok }
    end
  end
end
