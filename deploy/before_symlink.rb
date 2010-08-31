links = { 'avatars' => 'public/avatars' }

links.each_pair do |shared_folder,app_folder|
  run "echo 'linking: #{shared_path}/#{shared_folder} to #{release_path}/#{app_folder}' >> #{shared_path}/logs.log"
  run "ln -nfs #{shared_path}/#{shared_folder} #{release_path}/#{app_folder}"
end