class HomeController < ApplicationController
  
  def index      
    begin
      @cleaners = suitable_cleaners if search?
    rescue Exception => e
      flash.now[:error] = e.message 
    ensure
      @cleaners ||= default_selection 
    end
  end

private

  def search?
    request.post? and params[:postcode] and !params[:postcode].empty?
  end

  def suitable_cleaners
    postcode, skills, date = [build_postcode, build_skills, build_date]
    @cleaners = Cleaner.find_suitable!(:origin => postcode, :skills => skills, :date => date)    
  end

  def build_postcode
    postcode = Postcode.find_or_create_by_normalized_value(params[:postcode])
    postcode.id ? postcode : raise("We couldn't locate your postcode. Please try a postcode near you instead")
  end
  
  def build_skills
    skills = Skills.new do |skills|
      [:domestic_cleaning, :ironing, :groceries, :pets].each do |s|
        skills.send("#{s}=", params[s])
      end
      skills.domestic_cleaning = true if skills.empty?
    end
  end
  
  def build_date
    Date.parse params[:booking_date]
  rescue
    Rails.logger.warn "Couldn't parse the date: #{params[:booking_date]}" 
    Date.today
  end
    
  def default_selection
    Cleaner.find(:all, :limit => 20, :order => 'created_at desc')
  end

  def search_params_present?
    params[:postcode] and !params[:postcode].blank? and params[:booking_date]
  end

  
end
