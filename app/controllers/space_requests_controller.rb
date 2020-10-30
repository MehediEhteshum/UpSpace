class SpaceRequestsController < ApplicationController
  before_action :set_space_request, only: [:show, :edit, :update, :destroy]
  before_action :verify_admin
  before_action :store_user_location!, if: :storable_location?

  def index
    @space_requests = SpaceRequest.all
    @users = User.all
    @users_requesting = []
    # Unique values for the filter
    @space_requests_location = @space_requests.map { |space| space.city }.uniq

    @space_requests.each do |space_request|
      @users_requesting << @users.where(id: space_request.user_id).first
    end
  end

  def show
  end

  def new
    redirect_unauthorized_access
    @space_request = SpaceRequest.new
  end

  def edit
  end

  def create
    redirect_unauthorized_access
    @space_request = SpaceRequest.new(space_request_params)

    respond_to do |format|
      if @space_request.save
        format.html { redirect_to @space_request, notice: 'Space request was successfully created.' }
        format.json { render :show, status: :created, location: @space_request }
      else
        format.html { render :new }
        format.json { render json: @space_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    redirect_unauthorized_access
    respond_to do |format|
      if @space_request.update(space_request_params)
        format.html { redirect_to @space_request, notice: 'Space request was successfully updated.' }
        format.json { render :show, status: :ok, location: @space_request }
      else
        format.html { render :edit }
        format.json { render json: @space_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    redirect_unauthorized_access
    @space_request.destroy
    respond_to do |format|
      format.html { redirect_to space_requests_url, notice: 'Space request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_space_request
      @space_request = SpaceRequest.find(params[:id])
    end

    def space_request_params
      params.require(:space_request).permit(:user_id, :date_request, :time_request, :description, :city)
    end

    def verify_admin
      if current_user.try(:admin?)
        @admin_user = true
      end
    end

  private
    def redirect_unauthorized_access
      if !@admin_user
        redirect_to root_path
      end
    end

end
