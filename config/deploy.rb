
# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'brute-gender-web'
set :repo_url, 'git@github.com:guylifshitz/brute-gender-web.git'
set :user, "guy"


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/guy/brute-gender-web'

set :linked_files, %w{scripts/lexique-dicollecte-fr-v5.6.csv scripts/GLAWI_FR_workParsed_D2015-12-26_R2016-05-18.xml}
set :linked_dirs, %w{log tmp}

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5


# RVM
set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs

# before 'deploy:setup', 'rvm:install_rvm'  # install/update RVM
# before 'deploy:setup', 'rvm:install_ruby' # install Ruby and create gemset, OR:
set :bundle_dir, ''
set :bundle_flags, '--system --quiet'

# SIDEKIQ
# set :sidekiq_pid, File.join(current_path, 'tmp', 'sidekiq.pid')
# set :sidekiq_env, fetch(:rack_env, fetch(:rails_env, "production"))
set :pty,  false

# sidekiq_cmd_pre = 'cd #{current_path} && ( PATH=/home/guy/.rvm/bin:$PATH RAILS_ENV=production ~/.rvm/bin/rvm default do'
# set :sidekiq_cmd, -> { "#{sidekiq_cmd_pre} bundle exec sidekiq)" }


namespace :sidekiq do
  def sidekiq_pid
    current_path + '../shared/pids/sidekiq.pid'
  end

  def pid_file_exists?
    test(*("[ -f #{sidekiq_pid} ]").split(' '))
  end

  def pid_process_exists?
    pid_file_exists? and test(*("kill -0 $( cat #{sidekiq_pid} )").split(' '))
  end

  task :start do
    on roles(:app) do
      if !pid_process_exists?
        execute "cd #{current_path} && RAILS_ENV=#{fetch(:rails_env)} #{fetch(:rbenv_prefix)} bundle exec sidekiq -C config/sidekiq.yml -e #{fetch(:rails_env)} -L log/sidekiq.log -P #{sidekiq_pid} -d"
      end
    end
  end

  task :stop do
    on roles(:app) do
      if pid_process_exists?
        execute "kill `cat #{sidekiq_pid}`"
        execute "rm #{sidekiq_pid}"
      end
    end
  end

  task :restart do
    on roles(:app) do
      invoke "sidekiq:stop"
      invoke "sidekiq:start"
    end
  end
end

after 'deploy:restart', 'sidekiq:start'
