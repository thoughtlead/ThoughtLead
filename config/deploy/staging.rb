

set :domain,          "jacob-stetser.com"
set :rails_env,       "staging"
set :deploy_to,       "/var/www/apps/#{application}"
set :deploy_via, :remote_cache
set :branch, "staging"

set :user, 'jstetser'
set :runner, 'jstetser'

role :web, domain
role :app, domain
role :db,  domain, :primary => true

# =============================================================================
# TASKS
# Don't change unless you know what you are doing!

namespace(:deploy) do
  
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  desc "Long deploy will throw up the maintenance.html page and run migrations
        then it restarts and enables the site again."
  task :long do
    transaction do
      update_code
      web.disable
      symlink
      migrate
    end
  
    restart
    web.enable
  end
end

# =============================================================================
# APACHE OPTIONS
# =============================================================================
set :apache_server_name, domain
set :apache_conf, "/usr/local/apache2/conf/apps/#{application}.conf"
set :apache_ctl, "/etc/init.d/httpd"
set :apache_proxy_port, 9000
set :apache_proxy_servers, 4
set :apache_proxy_address, "127.0.0.1"

# =============================================================================
# SSH OPTIONS
# =============================================================================
ssh_options[:keys] = %w(/Users/jstetser/.ssh/id_rsa)
ssh_options[:port] = 3996
ssh_options[:forward_agent] = true