class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  skip_before_filter :verify_authenticity_token
  def index
    @event = Event.find(params[:eventId])

    puts "Event111: " << @event.comments.to_s

    @comments = @event.comments
    @comment = Comment.new

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html { redirect_to(@comment) }
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    puts "Creating new comment..."
    @comment = Comment.new(params[:comment])

    @comment.event_id = params[:comment_event_id]

    logger.info("Event id: " <<  params[:comment_event_id].to_s)
    respond_to do |format|
      if @comment.save
        puts "saved ok"
        format.html { redirect_to :controller => :comments, :action => :index, :eventId => @comment.event_id,
                                  :notice => "City was successfully created."}
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
        else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
end
