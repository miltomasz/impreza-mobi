class ClubsController < ApplicationController
  # GET /clubs
  # GET /clubs.xml
  def index
    @clubs = Club.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clubs }
    end
  end

  # GET /clubs/1
  # GET /clubs/1.xml
  def show
    @club = Club.find(params[:id])

    sort_events(@club)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @club }
    end
  end

  def sort_events(club)
    sorter = CitiesHelper::Sorter.new
    sorter.sort_events(club.events)
  end

  def calculate
    @club = Club.find(params[:clubId])
    sort_events(@club)
    @event = @club.events[0]

    score = params[:radio]

    current_voices_number = @event.voices_number + score.to_i
    @event.update_attribute("voices_number", current_voices_number)

    @club
  end

  # GET /clubs/new
  # GET /clubs/new.xml
  def new
    @club = Club.new(:city_id => params[:id])

    puts "Klub: " + @club.city_id.to_s();

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @club }
    end
  end

  # GET /clubs/1/edit
  def edit
    @club = Club.find(params[:id])
  end

  # POST /clubs
  # POST /clubs.xml
  def create
    @club = Club.new(params[:club])

    respond_to do |format|
      if @club.save
        @event = Event.new(:date => Time.now, :club_id => @club.id, :voices_number => 0, :voices_index => 0)

        if @event.save
          format.html { redirect_to("/cities/#{@club.city_id}", :notice => 'Club was successfully created.') }
          format.xml  { render :xml => @club, :status => :created, :location => @club }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clubs/1
  # PUT /clubs/1.xml
  def update
    @club = Club.find(params[:id])

    respond_to do |format|
      if @club.update_attributes(params[:club])
        format.html { redirect_to(@club, :notice => 'Club was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @club.errors, :status => :unprocessable_entity }
      end
    end
  end

  def voices_number
    @club = Club.find(params[:clubId])
    @event = @club.events[0];

    @event.update_attribute("voices_number", params[:score])

    redirect_to("/cities/#{@club.city_id}")
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.xml
  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    respond_to do |format|
      format.html { redirect_to(clubs_url) }
      format.xml  { head :ok }
    end
  end
end
