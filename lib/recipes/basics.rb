namespace :deploy do
  task :link_shared_stuff do
    run "ln -nfs #{shared_path}/avatars #{release_path}/public/avatars"
    run "mkdir -p #{release_path}/tmp"
  end
  
  desc "Disable, migrate, restart, enable."
  task :default do
    transaction do
      update_code
      find_and_execute_task("deploy:web:disable")
      symlink
      migrate
    end
    restart
    find_and_execute_task("deploy:web:enable")
  end
  
end



