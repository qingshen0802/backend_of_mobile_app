require "rvm/capistrano"
require "bundler/capistrano"
require "whenever/capistrano"

set :application, "playcelet"

set :port, 22022
set :user, "playcelet"
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:Gera-IT/playcelets_rails.git"
set :branch, "master"
set :deploy_to, "/home/#{user}/applications/playcelet"
set :deploy_via, :remote_cache

set :rails_env, "production"

role :web, "198.74.50.251"                   # Your HTTP server, Apache/etc
role :app, "198.74.50.251"                   # This may be the same as your `Web` server
role :db,  "198.74.50.251", :primary => true # This is where Rails migrations will run

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :whenever_command, "bundle exec whenever"
set :whenever_roles, -> { :app }

# To clean up old releases on each deploy:
set :keep_releases, 5
after "deploy", "deploy:cleanup" # keep only the last 5 releases

after "deploy:start", "delayed_jobs:start"

namespace :whenever do
  task :start, :roles => :app do
    run "cd #{release_path} && #{whenever_command} --update-crontab"
  end
end

namespace :delayed_jobs do
  task :start, :roles => :app do
    run "cd #{release_path} && RAILS_ENV=production bin/delayed_job -n 2 stop"
    run "cd #{release_path} && RAILS_ENV=production bin/delayed_job -n 2 start"
  end
end

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server and workers"
    task command, roles: :app, except: {no_release: true} do
      run "chmod a+x /etc/init.d/unicorn_#{application}.gera-it-dev-eu.com.conf"
      run "/etc/init.d/unicorn_#{application}.gera-it-dev-eu.com.conf restart"
    end
  end

  task :setup_config, roles: :app do
    #sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}.gera-it-dev-eu.com.conf"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}.gera-it-dev-eu.com.conf"
    sudo "chmod a+x /etc/init.d/unicorn_#{application}.gera-it-dev-eu.com.conf"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    put File.read("config/secrets.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "cp #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
