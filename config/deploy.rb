set :application, "www.russ.ru"
set :repository, "git@github.com:mvcaaa/ssur.git"
set :scm, :git
set :deploy_via, :remote_cache

set :user, "russ"
set :use_sudo, false


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "#{application}"                          # Your HTTP server, Apache/etc
role :app, "#{application}"                          # This may be the same as your `Web` server
role :db,  "#{application}", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/russ/deploy"
set :document_root, "/home/russ/deploy/DocumentRoot"


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
	namespace :deploy do
 
		task :update do
			transaction do
				update_code
				symlink
			end
		end
 
		task :finalize_update do
			transaction do
				run "chmod -R g+w #{releases_path}/#{release_name}"
			end
		end
 
		task :symlink do
			transaction do
				run "ln -nfs #{current_release} #{deploy_to}/#{current_dir}"
				run "ln -nfs #{deploy_to}/#{current_dir} #{document_root}"
			end
		end
 
		task :migrate do
			# nothing
		end
 
		task :restart do
			# nothing
		end
 
	end
