class AddGeneralThemeToAllCommunities < ActiveRecord::Migration
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


