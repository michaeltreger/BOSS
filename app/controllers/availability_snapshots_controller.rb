class AvailabilitySnapshotsController < ApplicationController
  # GET /availability_snapshots
  # GET /availability_snapshots.json
  def index
    @availability_snapshots = AvailabilitySnapshot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @availability_snapshots }
    end
  end

  # GET /availability_snapshots/1
  # GET /availability_snapshots/1.json
  def show
    @availability_snapshot = AvailabilitySnapshot.find(params[:id])
    @time = @availability_snapshot.start_date.to_time
    @avail = @availability_snapshot.availabilities[:avail]
    @rather_not = @availability_snapshot.availabilities[:rather_not]
    @prefer = @availability_snapshot.availabilities[:prefer]

    @avail.each_pair do |k,v|
      @avail[k] = display(v)
    end
    @rather_not.each_pair do |k,v|
      @rather_not[k] = display(v)
    end
    @prefer.each_pair do |k,v|
      @prefer[k] = display(v)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @availability_snapshot }
    end
  end
  
  def display(list)
    s = ""
    list.each do |i|
      s += i + " "
    end
    return s
  end

  # GET /availability_snapshots/new
  # GET /availability_snapshots/new.json
  def new
    @availability_snapshot = AvailabilitySnapshot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @availability_snapshot }
    end
  end

  # GET /availability_snapshots/1/edit
  def edit
    @availability_snapshot = AvailabilitySnapshot.find(params[:id])
  end

  # POST /availability_snapshots
  # POST /availability_snapshots.json
  def create
    @availability_snapshot = AvailabilitySnapshot.new(params[:availability_snapshot])
    @avail = {}
    @rather_not = {}
    @prefer = {}
    @start_time = Time.now.beginning_of_week + 7.days
    time = @start_time
    endTime = time + 7.days

    users = []
    User.where(:activated=>true).each do |u|
      users << u.initials
    end

    while time < endTime
      @avail[time] = Array.new(users)
      time += 30.minutes
    end
    
    start = Time.now.beginning_of_week + 7.days
    User.find_all_by_activated(true).each do |u|
      u.availability_calendar(@current_period).entries.each do |e|
        if e.unavailable?
          time = e.start_time + (start - e.start_time.beginning_of_week)
          endTime = e.end_time + (start - e.end_time.beginning_of_week)
          while time < endTime
            @avail[time.to_time].delete(User.find(e.calendar.user_id).initials)
            time += 30.minutes
          end
        elsif e.entry_type == "rather_not"
          time = e.start_time + (start - e.start_time.beginning_of_week)
          endTime = e.end_time + (start - e.end_time.beginning_of_week)
          while time < endTime
            if @rather_not[time.to_time].nil?
              @rather_not[time.to_time] = [User.find(e.calendar.user_id).initials]
            else
              @rather_not[time.to_time] << User.find(e.calendar.user_id).initials
            end
            @avail[time.to_time].delete(User.find(e.calendar.user_id).initials)
            time += 30.minutes
          end
        elsif e.entry_type == "prefer"
          time = e.start_time + (start - e.start_time.beginning_of_week)
          endTime = e.end_time + (start - e.end_time.beginning_of_week)
          while time < endTime
            if @prefer[time.to_time].nil?
              @prefer[time.to_time] = [User.find(e.calendar.user_id).initials]
            else
              @prefer[time.to_time] << User.find(e.calendar.user_id).initials
            end
            @avail[time.to_time].delete(User.find(e.calendar.user_id).initials)
            time += 30.minutes
          end
        end
      end
    end
    @cal = {}
    @cal[:avail] = @avail
    @cal[:rather_not] = @rather_not
    @cal[:prefer] = @prefer
    @availability_snapshot.start_date = @start_time
    @availability_snapshot.end_date = endTime
    @availability_snapshot.availabilities = @cal
        
    
    respond_to do |format|
      if @availability_snapshot.save
        format.html { redirect_to @availability_snapshot, notice: 'Availability snapshot was successfully created.' }
        format.json { render json: @availability_snapshot, status: :created, location: @availability_snapshot }
      else
        format.html { render action: "new" }
        format.json { render json: @availability_snapshot.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /availability_snapshots/1
  # PUT /availability_snapshots/1.json
  def update
    @availability_snapshot = AvailabilitySnapshot.find(params[:id])

    respond_to do |format|
      if @availability_snapshot.update_attributes(params[:availability_snapshot])
        format.html { redirect_to @availability_snapshot, notice: 'Availability snapshot was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @availability_snapshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /availability_snapshots/1
  # DELETE /availability_snapshots/1.json
  def destroy
    @availability_snapshot = AvailabilitySnapshot.find(params[:id])
    @availability_snapshot.destroy

    respond_to do |format|
      format.html { redirect_to availability_snapshots_url }
      format.json { head :ok }
    end
  end
end
