class ApplicationPetsController < ApplicationController
  def new
    # look for a way to pass in 
    ApplicationPet.create!(application_id: params[:application_id], pet_id: params[:id])
    redirect_to "/applications/#{params[:application_id]}"
  end
end