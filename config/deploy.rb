
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
set :sidekiq_pid, File.join(current_path, 'tmp', 'sidekiq.pid')
set :sidekiq_env, fetch(:rack_env, fetch(:rails_env, "production"))
set :pty,  false

sidekiq_cmd_pre = '(PATH=/home/guy/.rvm/bin:$PATH RAILS_ENV=production ~/.rvm/bin/rvm default do'
set :sidekiq_cmd, -> { "#{sidekiq_cmd_pre} bundle exec sidekiq)" }
