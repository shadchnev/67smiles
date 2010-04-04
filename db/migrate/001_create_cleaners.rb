class CreateCleaners < ActiveRecord::Migration
  def self.up
    create_table :cleaners do |t|
      t.integer   :name_id
      t.text      :description
      t.integer   :minimum_hire
      t.decimal   :rate,            :precision => 4, :scale => 2
      t.decimal   :surcharge,       :precision => 4, :scale => 2
      t.integer   :availability_id
      t.integer   :skills_id
      t.string    :photo_file_name      # Original filename
      t.string    :photo_content_type   # Mime type
      t.integer   :photo_file_size      # File size in bytes      
      t.integer   :contact_details_id
      t.integer   :postcode_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cleaners
  end
end
