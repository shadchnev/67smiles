class HomeController < ApplicationController
  
  def index
    @cleaners = Cleaner.all
  end
  
end
