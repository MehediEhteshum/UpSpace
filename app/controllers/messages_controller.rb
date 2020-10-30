class MessagesController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!
  before_action :set_conversation

  def index
    if current_user == @conversation.sender || current_user == @conversation.recipient
      @other = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
      @messages = @conversation.messages.order("created_at DESC").first(15)
      @messages.each do |message|
        message.read_at = Time.now if message.read_at.nil? && current_user != message.user_id #this saves ot the DB in the server's timezone
        message.save
      end
      current_user.unread = 0
      current_user.save
    else
      redirect_to conversations_path, alert: "You don't have permission to view this."
    end
    @allSpaces = Space.where(active: true, user_id: @other).order("updated_at desc")
    @spaces = @allSpaces.first(3)
  end

  def create
    @message = @conversation.messages.new(message_params)
    @messages = @conversation.messages.order("created_at DESC")
    @recipient = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender
    @sender = current_user == @conversation.sender ? @conversation.sender : @conversation.recipient

    if @message.save
      @conversation.touch(:updated_at)
      ActionCable.server.broadcast "conversation_#{@conversation.id}", message: render_message(@message)
      MessageMailer.send_message_to_recipient(@recipient, @sender, @message).deliver_later if @recipient.setting.enable_email
      redirect_to conversation_messages_path(@conversation)
    end
  end

  private

    def render_message(message)
      self.render(partial: 'messages/message', locals: {message: message})
    end

    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end

    def message_params
      params.require(:message).permit(:context, :user_id)
    end

end
