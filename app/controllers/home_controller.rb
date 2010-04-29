class HomeController < ApplicationController
  
  def index      
    begin
      instantiate_query_params
      @search = search?
      @welcome_partial = params[:hlp] ? 'welcome_homeowner' : 'welcome_generic'
      @cleaners = suitable_cleaners if search?
      @skills = {:domestic_cleaning => true}
    rescue Exception => e
      flash.now[:error] = e.message 
    ensure
      @cleaners ||= default_selection 
    end
  end

private

  def instantiate_query_params
    @postcode, @booking_date, @skills = params[:postcode], params[:booking_date], Hash[*Skills.skill_set.map{|s| [s.to_s, !params[s].nil?]}.flatten]
  end

  def search?
    request.post? and params[:postcode] and !params[:postcode].empty?
  end

  def suitable_cleaners
    location, skills, date = [build_location, build_skills, build_date]
    @cleaners = Cleaner.find_suitable!(:origin => location, :skills => skills)
  end

  def build_location
    postcode = Postcode.find_or_create_by_normalized_value(params[:postcode])
    return postcode if postcode.valid?
    location = Geokit::Geocoders::MultiGeocoder.geocode(params[:postcode], :bias => :uk)
    return location if location.success
    raise("We couldn't locate your postcode. Please try a postcode near you instead")
  end
  
  def build_skills
    Skills.new do |skills|
      Skills.skill_set.each do |s|
        skills.send("#{s}=", !params[s].nil?)
      end
      skills.domestic_cleaning = true if skills.empty?
    end
  end
  
  def build_date
    Time.at(params[:booking_date].to_i).to_date
  rescue
    Rails.logger.warn "Couldn't parse the date: #{params[:booking_date]}" 
    Date.today
  end
    
  def default_selection        
    # begin
    #   location = Geokit::Geocoders::IpGeocoder.geocode($1) if request.env['REMOTE_ADDR'] =~ /((?:\d{1,3}\.){3}\d{1,3})/
    # rescue
    #   location = nil    
    # end
    params = {:select => 'cleaners.*, (photo_file_size > 0) AS has_photo', :joins => :user, :conditions => 'active = 1', :limit => 20, :order => 'has_photo desc, created_at desc'}
    # if location and location.success and location.country_code == 'GB'
    #   geo_params = params.merge({:origin => location, :within => 20}) 
    #   cleaners =  Cleaner.find(:all, geo_params)
    # end
    # !cleaners ? Cleaner.find(:all, params) : cleaners
    Cleaner.find :all, params
  end

  def search_params_present?
    params[:postcode] and !params[:postcode].blank? and params[:booking_date]
  end

  
end
