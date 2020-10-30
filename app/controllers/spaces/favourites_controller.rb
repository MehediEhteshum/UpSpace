class Spaces::FavouritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_space, except: [:index]

  def create
    @space.favourites.where(user_id: current_user.id).first_or_create
    respond_to do |format|
      format.html { redirect_to @space }
      format.js
    end
  end

  def destroy
    @space.favourites.where(user_id: current_user.id).destroy_all
    respond_to do |format|
      format.html { redirect_to @space }
      format.js
    end
  end

  def index
    @favourites = current_user.favourites.where(user_id: current_user.id)
    favourite_space_ids = []
    @favourites.each do |favourite|
      favourite_space_ids << favourite.space_id
    end
    @favourite_spaces = Space.find(favourite_space_ids)
  end

  private

  def set_space
    @space = Space.find(params[:space_id])
  end

end
