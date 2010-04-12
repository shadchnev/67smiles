set :application, "Innocent Cleaners"
set :repository,  "git@github.com:shadchnev/67smiles.git"
set :deploy_to, "/var/www/ic"

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 5
set :user, "ubuntu"

role :web, "79.125.56.133"                          # Your HTTP server, Apache/etc
role :app, "79.125.56.133"                          # This may be the same as your `Web` server
role :db,  "79.125.56.133", :primary => true # This is where Rails migrations will run

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace(:customs) do
  task :symlink, :roles => :app do
    run <<-CMD
      ln -nfs #{shared_path}/photos/cleaners #{release_path}/public/photos/cleaners
    CMD
  end
end

after "deploy:symlink","customs:symlink"
after "deploy:symlink","deploy:cleanup"