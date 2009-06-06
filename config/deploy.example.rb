default_run_options[:pty] = true

set :user, "{SSH USERNAME}"
set :domain, "{DOMAIN OF APPLICATION}"
set :host, "{DREAMHOST DOMAIN}"
set :application, "icon-love"

set :repository,  "#{user}@#{host}:{PATH TO REPOSITORY}/#{application}.git"
set :deploy_to, "/home/#{user}/#{domain}" 
set :deploy_via, :remote_cache
set :scm, "git"
set :scm_username, "{GIT USERNAME}"
set :scm_password, "{GIT PASSWORD}"
set :branch, "master"
set :git_shallow_clone, 1
set :use_sudo, false
set :keep_releases, 3 

server domain, :app, :web, :db


namespace :deploy do
  desc "restart the application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end


after 'deploy:setup', 'gems:install'
after 'deploy:update_code', 'gems:symlink', 'gems:file_cleanup'

namespace :gems do
  desc "install rack and sinatra gems"
  task :install do
    run 'gem install rack -v 0.9.1'
    run 'gem install sinatra -v 0.9.1.1'
    run "cd #{shared_path}/system && gem unpack rack -v 0.9.1 && mv rack-* rack"
    run "cd #{shared_path}/system && gem unpack sinatra -v 0.9.1.1 && mv sinatra-* sinatra"
  end

  desc "set up vendor folder and set symlinks to rack and sinatra"
  task :symlink do
    run "mkdir -p #{release_path}/vendor/"
    run "ln -nfs #{shared_path}/system/rack #{release_path}/vendor/rack"
    run "ln -nfs #{shared_path}/system/sinatra #{release_path}/vendor/sinatra"
  end

  desc "delete some files which are not neccesary in production environment"
  task :file_cleanup do
    run "rm #{release_path}/README.markdown"
    run "rm #{release_path}/Capfile"
    run "rm -R #{release_path}/test/"
  end
end

namespace :db do
  desc "export a database dump into shared/backup folder"
  task :export do
    run "mkdir -p #{shared_path}/backup/"
    run "sqlite3 #{current_path}/icons.sqlite3 .dump .quit >> #{shared_path}/backup/icons.sql"
    run "cp #{shared_path}/backup/icons.sql #{shared_path}/backup/icons.#{Time.now.strftime('%Y-%m-%d.%H-%M')}.sql"
  end

  desc "import the most current database dump back into database"
  task :import do
    run "sqlite3 icons.sql < #{shared_path}/backup/icons.sql"
  end
end