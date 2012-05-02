class LabsController < ApplicationController
  before_filter :check_admin, :only => ['new', 'destroy', 'edit', 'create']
  # GET /labs
  # GET /labs.json
  def index
    @labs = Lab.all#.sort!{|t1,t2|t1.groups[0].name <=> t2.groups[0].name}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @labs }
    end
  end

  # GET /labs/1
  # GET /labs/1.json
  def show
    @lab = Lab.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab }
    end
  end

  # GET /labs/new
  # GET /labs/new.json
  def new
    @lab = Lab.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab }
    end
  end

  # GET /labs/1/edit
  def edit
    @lab = Lab.find(params[:id])



  end

  # POST /labs
  # POST /labs.json
  def create
    @lab = Lab.new(params[:lab])

    respond_to do |format|
      if @lab.save
        format.html { redirect_to labs_path, notice: 'Lab was successfully created.' }
        format.json { render json: @lab, status: :created, location: @lab }
      else
        format.html { render action: "new" }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /labs/1
  # PUT /labs/1.json
  def update
    @lab = Lab.find(params[:id])

    respond_to do |format|
      if @lab.update_attributes(params[:lab])
        format.html { redirect_to labs_path, notice: 'Lab was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /labs/1
  # DELETE /labs/1.json
  def destroy
    @lab = Lab.find(params[:id])
    @lab.destroy

    respond_to do |format|
      format.html { redirect_to labs_url }
      format.json { head :ok }
    end
  end

  def upload_shifts
    @lab = Lab.find(params[:id])

    #respond_to do |format|
     # if @lab.save
      #  format.html { redirect_to :back, notice: 'File was successfully uploaded.' }
       # format.json { head :ok }
      #else
        #format.html { render action: "upload" }
        #format.json { render json: @lab.errors, status: :unprocessable_entity }
      #end
    #end
  end

  def commit_shifts
    if @lab= Lab.find(params[:id])
      filePath = @lab.text_file.path
      timeTable = @lab.read_schedule(filePath)

      #utcOffset = Time.now.utc_offset/3600
      #if utcOffset <= 0
       # if utcOffset < 10
          #timeZone = "-0#{utcOffset.abs}:00"
       # else
          #timeZone = "-#{utcOffset.abs}:00"
       # end
      #else
       # if utcOffset < 10
          #timeZone = "+0#{utcOffset}:00"
       # else
          #timeZone = "+#{utcOffset}:00"
       # end
      #end
      startWeek = Time.new(Time.now.year, timeTable[0][2]["start_time_month"], timeTable[0][3]["start_time_day"], 8, 0, 0, "+01:00")
      endWeek =  Time.new(Time.now.year, timeTable[0][4]["end_time_month"], timeTable[0][5]["end_time_day"].to_i + 1, 8, 0, 0, "+01:00")

      if timeTable[0][0]["initials"] != @lab.initials
        flash[:error] = 'This flat file is not for this lab!'
      elsif Time.now > startWeek
        flash[:error] = 'Commiting shifts for past time!'
      elsif !@lab.is_week_empty?(startWeek, endWeek)
        flash[:error] = 'Selected week calendar not empty!'#Assuming never commit calendar for the same week, use sub or time_edit to do changes.

      else
        noInit = false
        if timeTable[0][6] != {}
          xx = true
        end
        for i in 1..24
          for j in 0..6
            if timeTable[i][j] != {}
              timeTable[i][j].each do |k, v|
                if k !='xx' and k != 'XX' and !(employee = User.find_by_initials(k))
                  noInit = true
                  flash[:error] = "Employee with initials: #{k} does not exist!"
                end
              end
            end
          end
        end
        if !noInit
          for i in 1..24
            for j in 0..6
              if timeTable[i][j] != {}
                timeOffset = (j * 24 + i + 7).hour
                startTime = startWeek + timeOffset
                endTime = startTime + 1.hour

                timeTable[i][j].each do |k, v|
                  if k =='XX' or k == 'xx'
                    #sub must have entry attributes. entry must have start&end time. Associate all xx shifts with Chris
                    xxEntry = Entry.create!(:entry_type => 'xx', :user_id => 7, :start_time => startTime, :end_time => endTime, :lab_id => @lab.id)
                    Substitution.create!(:entry => xxEntry, :entry_id => xxEntry.id, :description => 'This is an xx shifts.')
                  else
                    if v == 0
                      employee = User.find_by_initials(k)
                      #debugger
                      newEntry = Entry.create!(:entry_type => 'shift', :user_id => employee.id, :start_time => startTime, :end_time => endTime, :description => "#{employee.name}@#{@lab.name}", :lab_id => @lab.id, :calendar_id => @lab.calendar.id)
                    elsif v == 1
                      endTime = startTime + 30.minute
                      Entry.create!(:entry_type => 'shift', :user_id => employee.id, :start_time => startTime, :end_time => endTime, :description => "#{employee.name}@#{@lab.name}", :lab_id => @lab.id, :calendar_id => @lab.calendar.id)
                      elsif v == 2
                      startTime = startTime + 30.minute
                      Entry.create!(:entry_type => 'shift', :user_id => employee.id, :start_time => startTime, :end_time => endTime, :description => "#{employee.name}@#{@lab.name}", :lab_id => @lab.id, :calendar_id => @lab.calendar.id)
                    end
                  end
                end
              end
            end
          end
        end
      end

      @lab.calendar.check_continuity

      respond_to do |format|
        format.html { redirect_to labs_path, notice: 'Shifts were successfully assigned.' }
        format.json { head :ok }
      end
    end
  end


end
