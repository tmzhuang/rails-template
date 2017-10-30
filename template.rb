def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def replace_files(filenames)
  filenames.each do |filename|
    remove_file filename
    copy_file filename
  end
end

filenames = ['Gemfile',
             '.gitignore',
             'Guardfile']

replace_files(filenames)

inside 'test' do
  remove_file 'test_helper.rb'
  copy_file 'test_helper.rb'
end

#Convert generated erb files to slim
run "erb2slim . -d"

rails_command "db:migrate"

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initialize repository' }
  run "heroku create #{app_name.dasherize}"
end
