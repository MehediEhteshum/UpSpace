class NotificationsController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!

  def index
    @unread = current_user.unread
    current_user.unread = 0
    current_user.save
    @notifications = current_user.notifications.order(created_at: :desc)
  end

end
