def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

#gsub_file "Gemfile", /.*sqlite.*\n/,''
#gsub_file "Gemfile", /.*byebug.*\n/,''
remove_file 'Gemfile'
copy_file 'Gemfile'

gem_group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'sqlite3'
  gem 'minitest', '5.9.1'
  gem 'minitest-reporters'
end

gem_group :production do
  gem 'pg'
end

inside 'test' do
  remove_file 'test_helper.rb'
  copy_file 'test_helper.rb'
end

#Convert generated erb files to slim
run "find . -type f -iname \"*.html.erb\" -exec erb2slim {} -d \\;"

rails_command "db:migrate"

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initialize repository' }
  run "heroku create tz#{app_name}"
  git push: "heroku master"
  run "heroku run rails db:migrate"
end
