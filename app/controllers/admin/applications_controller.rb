class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    # @application_pets = ApplicationPets.where(application_id: params[:id], pet_id: _______ )
  end
end