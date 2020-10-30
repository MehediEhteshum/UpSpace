class PhotosController < ApplicationController

  def create
    @space = Space.find(params[:space_id])

    if params[:images]
      params[:images].each do |img|
        @space.photos.create(image: img)
      end

      @photos = @space.photos
      redirect_back(fallback_location: request.referer, notice: "Photos uploaded successfully.")
    end
  end

  def sort
    @space = Space.find(params[:space_id])
    Photo.transaction do
      sort_params.each_with_index do |id, index|
        @space.photos.find(id).update!(sort: index+1)
      end
    end
    head :ok
  end

  def destroy
    @photo = Photo.find(params[:id])
    @space = @photo.space

    @photo.destroy
    @photos = Photo.where(space_id: @space.id)

    flash[:success] = 'Photo deleted.'
    respond_to do |format|
      format.js {render inline: "location.reload();" }
    end
  end

  private

  def sort_params
    params[:photo]
  end

end
