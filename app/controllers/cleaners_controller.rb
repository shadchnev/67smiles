class CleanersController < ApplicationController
  
  def create
    @cleaner = Cleaner.new(params[:cleaner])
    @cleaner.save ? redirect_to(cleaner_path(@cleaner)) : render(:action => :new)
  end
  
  def show
    @cleaner = Cleaner.find(params[:id])
  end
  
  def new
    @cleaner = Cleaner.new
    @cleaner.name = Name.new
    @cleaner.postcode = Postcode.new
  end
  
end
