class CleanersController < ApplicationController
  
  def create
    @cleaner = Cleaner.new(params[:cleaner])
    @cleaner.save ? redirect_to(cleaner_path(@cleaner)) : render(:action => :new)
  end
  
end
