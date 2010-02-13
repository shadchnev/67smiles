class BookingsController < ApplicationController
  
  def new
    @cleaner = Cleaner.find(params[:cleaner_id])
  end

end
