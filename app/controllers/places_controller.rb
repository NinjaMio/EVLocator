class PlacesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]


  def new
    @place = Place.new
  end

  def create
    @place = current_user.places.create(place_params)
    if @place.valid?
      redirect_to administration_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def place_params
    params.require(:place).permit(:placename, :address, :project_id)
  end
end
