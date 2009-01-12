class MigrateAccessClassDataAndRemoveOldColumns < ActiveRecord::Migration
  class Content < ActiveRecord::Base
  end

  class Theme < ActiveRecord::Base
  end

  class ContentAccessClass < ActiveRecord::Base
  end

  class ThemeAccessClass < ActiveRecord::Base
  end

  def self.up
    Content.all.each do |content|
      unless content.access_class_id.nil?
        ContentAccessClass.create(:content_id => content.id, :access_class_id => content.access_class_id)
      end
    end

    Theme.all.each do |theme|
      unless theme.access_class_id.nil?
        ThemeAccessClass.create(:theme_id => theme.id, :access_class_id => theme.access_class_id)
      end
    end

    remove_column :contents, :access_class_id
    remove_column :themes, :access_class_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
