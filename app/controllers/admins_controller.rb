class AdminsController < ApplicationController 

  def index 
    @shelters = Shelter.alphabetical_reverse
  end
end