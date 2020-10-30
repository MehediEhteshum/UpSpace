class AvatarsController < ApplicationController
    before_action :authenticate_user!
   
    #Create action ensures that submitted photo gets created if it meets the requirements
    def create
        @user = User.find(params[:user_id]);
        if params[:avatar]
            if @user.avatar
                @user.avatar.destroy
            end

            if @user.create_avatar(image: params[:avatar])
                redirect_back(fallback_location: request.referer, notice: "Photo uploaded successfully.")
            else
                redirect_back(fallback_location: request.referer, notice: "Error adding new photo!")
            end

        else
            redirect_back(fallback_location: request.referer, notice: "Error adding new photo!")
        end

    end
   
    #Destroy action for deleting an already uploaded image
    def destroy
        @avatar = Avatar.find(params[:id])
        if @avatar.destroy
            flash[:notice] = "Successfully deleted photo!"
            redirect_to root_path
        else
            flash[:alert] = "Error deleting photo!"
        end
    end

   end