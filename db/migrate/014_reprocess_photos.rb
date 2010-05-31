class ReprocessPhotos < ActiveRecord::Migration
  def self.up
    Cleaner.find_each{|c| c.photo.reprocess!}
  end

  def self.down
    # I'm not raising ActiveRecord::IrreversibleMigration because the old code will work just fine even after the photos will have reprocessed.
    # So yes, you can rollback and it's going to be fine.
  end
end
