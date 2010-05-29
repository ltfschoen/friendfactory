class MessagesController < ApplicationController

  before_filter :require_user

  def create
    @posting = Posting::Message.create(params[:posting_message])
    @posting.parent = Posting::Message.find_by_id(params[:message_id]).try(:latest_reply)
    @posting.user = current_user
    @posting.save
    respond_to do |format|
      format.js
    end
  end

#  def index
#    @message_threads = current_user.message_threads
#    @reply = current_user.sent_messages.build
#    respond_to do |format|
#      format.html
#    end
#  end
  
  # def sent
  #   @messages = current_user.sent_messages
  #   respond_to do |format|
  #     format.html
  #   end
  # end

  # def show
  #   @message = Message.find(params[:id])
  #   respond_to do |format|
  #     if [ @message.sender, @message.receiver ].include?(current_user)
  #       format.html
  #     else
  #       @messages = current_user.received_messages
  #       render :action => 'index'
  #     end
  #   end
  # end


  # GET /messages/1/edit
  # def edit
  #   @message = Message.find(params[:id])
  # end


#  def reply
#    message = current_user.received_messages.find_by_id(params[:message_id])
#    @reply  = message.reply(params[:message]) if message
#    respond_to do |format|
#      if @reply
#        format.xml { head :ok }
#      else
#        format.xml { render :xml => 'Invalid message', :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /messages/1
  # PUT /messages/1.xml
  # def update
  #   @message = Message.find(params[:id])
  #   respond_to do |format|
  #     if @message.update_attributes(params[:message])
  #       flash[:notice] = 'Message was successfully updated.'
  #       format.html { redirect_to(@message) }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  # def destroy
  #   @message = Message.find(params[:id])
  #   @message.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(messages_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
