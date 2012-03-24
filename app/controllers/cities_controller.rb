class CitiesController < ApplicationController
  # GET /cities
  # GET /cities.xml
  def index
    @cities = City.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cities }
    end
  end

  # GET /cities/1
  # GET /cities/1.xml
  def show
    @city = City.find(params[:id])

    calculate_today_start_tomorrow_end
    
    for club in @city.clubs do
      sorted_events = sort_events(club)
      save_club_event(club, sorted_events[0])
    end

    @city = City.find(params[:id])

    for club in @city.clubs do
      events = sort_events(club)
      last_event = events[0]
      
      #events = Event.find_all_by_club_id(club.id, :order => 'date DESC', :limit => 1)
      #last_event = events[0]

      if last_event.voices_index != nil
        if last_event.voices_index > 0
          average_note = last_event.voices_number.to_f / last_event.voices_index.to_f
          last_event.average_note = average_note.round
        end
      end

      if last_event.yes == nil then
        last_event.yes = 0
      end

      if last_event.no == nil then
        last_event.no = 0
      end
    end

    @date_s = @now.strftime("%Y-%m-%d")
    @time_s = @now.strftime("%H:%M:%S")

    sort_clubs(@city.clubs)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @city }
    end
  end

  def sort_clubs(clubs)
    sorter = CitiesHelper::Sorter.new
    clubs.sort! do |c1, c2|
      club_one_events = sorter.sort_events(c1.events)
      club_two_events = sorter.sort_events(c2.events)
      club_two_events[0].voices_index <=> club_one_events[0].voices_index
    end
  end

  def calculate_today_start_tomorrow_end
    @now = Time.now

    if @now.hour < 12
      @yesterday = @now - (60 * 60 * 24)
      @today_start = Time.local(@yesterday.year, @yesterday.month, @yesterday.day, 12,0)
    else
      @today_start = Time.local(@now.year, @now.month, @now.day, 12,0)
    end

    @tomorrow_end = @today_start + (60 * 60 * 24);
  end

  def sort_events(club)
    sorter = CitiesHelper::Sorter.new
    sorter.sort_events(club.events)
  end

  def save_club_event(club, event)
    later_than_start = event.date < @today_start
    earlier_than_end = event.date < @tomorrow_end

    if later_than_start and earlier_than_end then
      event = Event.new(:date => @now, :club_id => club.id, :name => "New one",
        :voices_number => 0, :voices_index => 0)
      event.save
    end

    return event
  end

  def calculate_average_note(event)
    if event.voices_index != nil
      if event.voices_index > 0
        average_note = event.voices_number.to_f / event.voices_index.to_f
        event.average_note = average_note.round
      end
    end
  end

  # GET /cities/new
  # GET /cities/new.xml
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /cities
  # POST /cities.xml
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to(@city, :notice => 'City was successfully created.') }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.xml
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(@city, :notice => 'City was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.xml
  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(cities_url) }
      format.xml  { head :ok }
    end
  end

 def voices_number
    @club = Club.find(params[:clubId])
    sorter = CitiesHelper::Sorter.new
    events = sorter.sort_events(@club.events)

    @event = events[0]

    current_voices_number = events[0].voices_number
    current_voices_index = events[0].voices_index + 1

    puts "Club: " + @club.id.to_s + " Event: " + events[0].id.to_s + " Voices number; " + events[0].voices_number.to_s

    score = 1 #params[:score].to_i

    puts "Score: " + score.to_s

    if score == 1 then
      current_voices_number = current_voices_number - 4
    elsif score == 2
      current_voices_number = current_voices_number - 2
    elsif score == 3
      current_voices_number = current_voices_number + 0
    elsif score == 4
      current_voices_number = current_voices_number + 2
    else score == 5
      current_voices_number = current_voices_number + 4
    end

    @event.update_attribute("voices_index", current_voices_index)
    @event.update_attribute("voices_number", current_voices_number)
    @event.update_attribute("yes", current_voices_index);
    
    if current_voices_index != nil
      if current_voices_index > 0
        average_note = current_voices_number.to_f / current_voices_index.to_f
        @event.average_note = average_note.round
      end
    end
    
    puts "Event an after rating: " << @event.average_note.to_s

    render :partial => "voices_number", :locals => {:club => @club}
  end

 def yes
   @city = City.find(params[:cityId])

   @club = Club.find(params[:clubId])
    sorter = CitiesHelper::Sorter.new
    events = sorter.sort_events(@club.events)

    @event = events[0]

   if @event.yes == nil
     @event.yes = 0
   end

   yes = @event.yes + 1
   @event.update_attribute("yes", yes)

   @club.events[0] = @event

   respond_to do |format|
      format.html { redirect_to(@city, :notice => 'City was successfully updated.') }
      format.xml  { render :xml => @city }
    end
 end

 def no
   @city = City.find(params[:cityId])

   @club = Club.find(params[:clubId])
    sorter = CitiesHelper::Sorter.new
    events = sorter.sort_events(@club.events)

    @event = events[0]

   if @event.no == nil
     @event.no = 0
   end

   no = @event.no + 1
   @event.update_attribute("no", no)

   @club.events[0] = @event

   respond_to do |format|
      format.html { redirect_to(@city) }
      format.xml  { render :xml => @city }
    end
 end

end