class HomeController < ApplicationController
  
  def index      
    begin
      postcode, skill, date = [build_postcode, build_skill, build_date]
      @cleaners = Cleaner.find_suitable(:origin => postcode, :skill => skill, :date => date)
      # local_cleaners.empty? ? flash.now[:notice] = "Sorry, we don't have any cleaners registered in your area" : @cleaners = local_cleaners      
    rescue Exception => e
      flash.now[:error] = e.message 
    ensure
      @cleaners = default_selection 
    end
  end

private  

  def build_postcode
    postcode = Postcode.find_or_create_by_normalized_value(params[:postcode])
    postcode.id ? postcode : raise("We couldn't locate your postcode. Please try a postcode near you instead")
  end
  
  def build_skill
    skill = Skill.new do |skill|
      [:domestic_cleaning, :ironing, :groceries, :pets].each do |s|
        skill.send("#{s}=", params[s])
      end
    end
    skill.select_all! if skill.empty?
  end
    
  def default_selection
    Cleaner.find(:all, :limit => 20, :order => 'created_at desc')
  end

  def search_params_present?
    params[:postcode] and !params[:postcode].blank? and params[:booking_date]
  end

  
end
