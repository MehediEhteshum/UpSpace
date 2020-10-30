class DashboardsController < ApplicationController
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!

  def index
    @spaces = current_user.spaces
    @trips = current_user.reservations.last(3).reverse
    @favourites = current_user.favourites.first(2)
    favourite_space_ids = []
    @favourites.each do |favourite|
      favourite_space_ids << favourite.space_id
    end
    @favourite_spaces = Space.find(favourite_space_ids)
  end

  def email_confirmed(user)
    if user.confirmed_at.nil?
      '<i class="fas fa-times icon-red"></i>'
    else
      '<i class="fas fa-check icon-green"></i>'
    end
  end

  def update_user_type
    @user_type = params[:user_type].to_i
    current_user.user_type = @user_type
    current_user.save!

    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end
  end
end
