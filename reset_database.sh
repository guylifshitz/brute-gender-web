rake db:drop
rm db/schema.rb
rake db:migrate
rake db:setup
rake db:migrate
rake db:setup


