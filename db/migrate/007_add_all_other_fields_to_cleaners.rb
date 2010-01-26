class AddAllOtherFieldsToCleaners < ActiveRecord::Migration
  def self.up
    add_column :cleaners, :description,     :text
    add_column :cleaners, :skills,          :binary
    add_column :cleaners, :minimum_hire,    :integer
    add_column :cleaners, :rate,            :decimal, :precision => 4, :scale => 2
    add_column :cleaners, :availability,    :binary
  end

  def self.down
    remove_column :cleaners, :availability
    remove_column :cleaners, :rate
    remove_column :cleaners, :minimum_hire
    remove_column :cleaners, :skills  
    remove_column :cleaners, :description
  end
end
