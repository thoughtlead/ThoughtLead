namespace :deploy do
  namespace :pending do
    desc <<-DESC
      For Deployment Reports
    DESC
    task :default, :except => { :no_release => true } do
      deployed_already = current_revision
      puts "\n\n"
      
      to_be_deployed = `git rev-parse --short "HEAD"`

      puts "Deployment revision #{`git rev-parse --short "HEAD"`}"
      puts "I deployed the latest. It includes:"
      system(%Q{git log --no-merges --pretty=format:"* %s %b (%cn)" #{deployed_already}.. | replace '<unknown>' ''})
      
      puts "\n\n\n"
    end
  
  end
end