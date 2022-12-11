class ApplicationPetsController < ApplicationController
  def new
    # look for a better way to pass in app_id param
    ApplicationPet.create!(application_id: params[:application_id], pet_id: params[:id])
    redirect_to "/applications/#{params[:application_id]}"
  end
end