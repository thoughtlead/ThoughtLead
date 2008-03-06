require 'fileutils'

class CadillacEdgeDeploy
  include FileUtils
  
  def deploy(rails_revision, release_path) 
    shared_path  = File.join(release_path, '../../shared')
    rails_path ||= File.join(shared_path, 'rails')

    @rails_revision = rails_revision
    @checkout_path = File.join(rails_path, 'trunk')
    @export_path = "#{rails_path}/rev_#{@rails_revision}"

    checkout_trunk
    export_revision
    link_export
  end
  
  
  private
    def checkout_trunk
      unless File.exists?(@checkout_path)
        puts 'setting up rails trunk'    
        get_framework_for @checkout_path do |framework|
          system "svn co http://dev.rubyonrails.org/svn/rails/trunk/#{framework}/lib #{@checkout_path}/#{framework}/lib --quiet"
        end
      end
    end
    
    def export_revision
      unless File.exists?(@export_path)
        puts "setting up rails rev #{@rails_revision}"
        get_framework_for @export_path do |framework|
          system "svn up #{@checkout_path}/#{framework}/lib -r #{@rails_revision} --quiet"
          system "svn export #{@checkout_path}/#{framework}/lib #{@export_path}/#{framework}/lib"
        end
      end
    end

    def link_export
      symlink_path  = 'vendor/rails'
      puts 'linking rails'
      rm_rf   symlink_path
      mkdir_p symlink_path

      get_framework_for symlink_path do |framework|
        ln_s File.expand_path("#{@export_path}/#{framework}/lib"), "#{symlink_path}/#{framework}/lib"
      end

      touch "vendor/rails_#{@rails_revision}"
    end

    def get_framework_for(*paths)
      %w( actionmailer actionpack activemodel activerecord activeresource activesupport railties ).each do |framework|
        paths.each { |path| mkdir_p "#{path}/#{framework}" }
        yield framework
      end
    end
    
end

if ($0 == __FILE__)
  CadillacEdgeDeploy.new.deploy(*ARGV)
end