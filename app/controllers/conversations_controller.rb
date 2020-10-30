class ConversationsController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!

  def index
    @conversations = Conversation.involving(current_user)
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end

    redirect_to conversation_messages_path(@conversation)
  end

  def unread(conversation)
    @unread = Message.where(:conversation_id => conversation.id, :read_at => nil).where.not(:user_id => current_user).count
  end
  helper_method :unread

  private

    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end



end
