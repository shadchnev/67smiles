class HomeController < ApplicationController
  
  def index      
    begin
      instantiate_query_params
      @search = search?
      @welcome_partial = params[:hlp] ? 'welcome_homeowner' : 'welcome_generic'
      @cleaners = suitable_cleaners if search?
      @skills = {:domestic_cleaning => true}
      @enable_horizontal_layout = true
      @lead_photo = 'lead-photo-frontpage.png'
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
    params = {:select => 'cleaners.*, (photo_file_size > 0) AS has_photo, count(r.id) as num_reviews', 
              :joins => "LEFT JOIN reviews r ON r.cleaner_id = cleaners.id INNER JOIN users u ON u.owner_id = cleaners.id", 
              :conditions => 'active = 1', 
              :limit => 20, 
              :order => 'num_reviews DESC, has_photo DESC, created_at DESC', 
              :group => 'cleaners.id'}
    Cleaner.find :all, params
  end

  def search_params_present?
    params[:postcode] and !params[:postcode].blank? and params[:booking_date]
  end

  
end
