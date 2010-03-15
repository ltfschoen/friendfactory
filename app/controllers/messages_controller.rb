class MessagesController < ApplicationController
  
  before_filter :require_user
  
  helper :users
  
  def index
    @messages = current_user.received_messages
    respond_to do |format|
      format.html
    end
  end
  
  def sent
    @messages = current_user.sent_messages
    respond_to do |format|
      format.html
    end
  end

  def show
    @message = Message.find(params[:id])
    respond_to do |format|
      if [ @message.sender, @message.receiver ].include?(current_user)
        format.html
      else
        @messages = current_user.received_messages
        render :action => 'index'
      end
    end
  end

  def new
    @message = Message.new
    respond_to do |format|
      format.html
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to(@message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
