class AdminsController < ApplicationController 

  def index 
    @shelters = Shelter.alphabetical_reverse
    @pending_shelters = Shelter.pending_applications
  end
end