class AddGeneralThemeToAllCommunities < ActiveRecord::Migration
  class Community < ActiveRecord::Base
    has_many :themes, :class_name => "AddGeneralThemeToAllCommunities::Theme"
    has_many :discussions, :class_name => "AddGeneralThemeToAllCommunities::Discussion"
  end

  class Theme < ActiveRecord::Base
    belongs_to :community, :class_name => "AddGeneralThemeToAllCommunities::Community"
  end

  class Discussion < ActiveRecord::Base
    belongs_to :theme, :class_name => "AddGeneralThemeToAllCommunities::Theme"
  end

  def self.up
  	Community.find(:all).each do |community|
    	theme = Theme.new
    	theme.community = community
    	theme.name = "General"
    	theme.description = "Ask questions, contribute your expertise, and engage with other members. Sort discussions by topic using the tabs to the right."
    	theme.save

    	community.discussions.each do |discussion|
  			if discussion.theme.nil?
  				discussion.theme_id = theme.id
  				discussion.save
  			end
    	end
  	end

  end

  def self.down
	#I could delete all the themes named "general", but I wouldn't be able to tell if those were the same ones I created.
  	raise ActiveRecord::IrreversibleMigration
  end
end
