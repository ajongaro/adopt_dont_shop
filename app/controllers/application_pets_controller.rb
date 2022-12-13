class ApplicationPetsController < ApplicationController
  def new
    ApplicationPet.create!(application_id: params[:application_id], pet_id: params[:id])
    redirect_to "/applications/#{params[:application_id]}"
  end

  def update
    application_pet = ApplicationPet.find_by(application_id: params[:id], pet_id: params[:pet_id])
    application_pet.update(status: params[:status].capitalize)
    redirect_to "/admin/applications/#{params[:id]}"
  end
end