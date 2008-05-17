namespace :deploy do
  task :link_shared_stuff do
    run "ln -nfs #{shared_path}/avatars #{release_path}/public/avatars"
    run "mkdir -p #{release_path}/tmp"
  end

end

namespace :deploy do
  namespace :git do
    task :after_pending do
      puts "http://demo.#{domain}\n\n\n\n"
      puts "http://nourishingdestiny.#{domain}\n\n\n\n"
    end
  end  
end


