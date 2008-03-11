namespace :deploy do
  namespace :pending do
    desc <<-DESC
      For Deployment Reports
    DESC
    task :default, :except => { :no_release => true } do
      from = current_revision
      puts "\n\n"
      
      puts "Deployment"
      puts "I deployed the latest. It includes:"
      system(%Q{git log --no-merges --pretty=format:"* %H %s (%cn) %b" #{from}.. | replace '<unknown>' ''})
      
      puts "\n\n\n"
    end
  
  end
end