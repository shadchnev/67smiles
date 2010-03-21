class HomeController < ApplicationController
  
  def index
    @cleaners = default_selection
    return unless search_params_present?
    postcode = Postcode.find_or_create_by_normalized_value(params[:postcode])
    flash.now[:error] = "We couldn't locate your postcode. Please try a postcode near you instead" and return unless postcode.id
    local_cleaners = Cleaner.find_near(postcode)
    local_cleaners.empty? ? flash.now[:notice] = "Sorry, we don't have any cleaners registered in your area" : @cleaners = local_cleaners
  end

private

  def default_selection
    Cleaner.find(:all, :limit => 20, :order => 'created_at desc')
  end

  def search_params_present?
    params[:postcode] and !params[:postcode].blank? and params[:booking_date]
  end

  
end
