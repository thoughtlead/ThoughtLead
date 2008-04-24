namespace :deploy do
  namespace :pending do
    desc <<-DESC
      For Deployment Reports
    DESC
    task :default, :except => { :no_release => true } do
      deployed_already = current_revision
      puts "\n\n"
      
      to_be_deployed = `git rev-parse --short "HEAD"`

      puts "Deployment to #{rails_env.upcase} #{`git rev-parse --short "HEAD"`}"
      puts "I deployed the latest. It includes:"
      puts
      system(%Q{git log --no-merges --pretty=format:"* %s %b (%cn)" #{deployed_already}.. | replace '<unknown>' ''})
      
      puts "\n\n"
      
      if rails_env == 'production'
        puts "http://demo.thoughtlead.com"
      else
        puts "http://demo.thoughtlead.verticality.dock.terralien.biz"
      end
      
      puts "\n\n"
    end
  
  end
end