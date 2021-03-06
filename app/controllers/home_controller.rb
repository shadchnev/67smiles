class HomeController < ApplicationController
  
  PAGE_SIZE = 5
  
  def index      
    @search = false
    @skills = {:domestic_cleaning => true}      
    @lead_photo = 'lead-photo-frontpage.png'      
    @events = recent_events
    @cleaners = default_selection 
    prepare_pagination
  end
  
  def search
    @search = true
    @lead_photo = nil
    instantiate_query_params    
    @cleaners = postcode_present? ? suitable_cleaners : default_selection
  rescue Exception => e
    @search = false
    flash.now[:error] = e.message
  ensure
    @events = recent_events
    @cleaners ||= default_selection 
    prepare_pagination
  end
  
  def students
    @lead_photo = 'lead-photo-students.png'
  end

  def homeowners
    @lead_photo = 'lead-photo-homeowners.png'
  end

  def faq
    @lead_photo = 'lead-photo-faq.png'
  end

  def about
    @lead_photo = 'lead-photo-evgeny.png'
  end

private

  def recent_events
    Event.find(:all, :limit => 30, :order => 'created_at DESC').select{|e| e.visible? }
  end

  def instantiate_query_params
    @postcode, @booking_date, @skills, @limit, @offset = params[:postcode], params[:booking_date], Hash[*Skills.skill_set.map{|s| [s.to_s, !params[s].nil?]}.flatten], params[:limit], params[:offset]
  end

  def postcode_present?
    params[:postcode] and !params[:postcode].empty? and params[:postcode].strip != 'Postcode'
  end
  
  def prepare_pagination
    @cleaners_total = @cleaners.size
    @offset = @offset.to_i rescue 0
    @limit = (@limit || PAGE_SIZE).to_i rescue PAGE_SIZE
    @cleaners_page = @offset / PAGE_SIZE + 1
    @cleaners_pages_total = (@cleaners_total / PAGE_SIZE.to_f).ceil
    @cleaners = @cleaners.slice!(@offset, @limit)
  end

  def suitable_cleaners
    location, skills, date = [build_location, build_skills, build_date]
    cleaners = Cleaner.find_suitable!(:origin => location, :skills => skills)
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
              :order => 'num_reviews DESC, has_photo DESC, created_at DESC', 
              :group => 'cleaners.id'}
    Cleaner.find :all, params
  end

  def search_params_present?
    params[:postcode] and !params[:postcode].blank? and params[:booking_date]
  end

  
end
