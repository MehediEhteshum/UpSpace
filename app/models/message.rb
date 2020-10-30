class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates_presence_of :context, :conversation_id, :user_id
  after_create_commit :create_notification

  def message_date
    self.created_at.in_time_zone(User.find(self.user_id).time_zone).strftime("%h %d, %G")
  end

  def message_time
    self.created_at.in_time_zone(User.find(self.user_id).time_zone).strftime("%l:%H %p")
  end

  private

    def create_notification
      if self.conversation.sender_id == self.user_id
        sender = User.find(self.conversation.sender_id)
        Notification.create(content: "Message from #{sender.fullname}", user_id: self.conversation.recipient_id, path_id: self.conversation.id)
      else
        sender = User.find(self.conversation.recipient_id)
        Notification.create(content: "Message from #{sender.fullname}", user_id: self.conversation.sender_id, path_id: self.conversation.id)
      end
    end

end
