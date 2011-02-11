# Suspenders
# =============
# by thoughtbot

require File.expand_path(File.dirname(__FILE__) + "/helpers")

template_root = File.expand_path(File.join(File.dirname(__FILE__)))
source_paths << File.join(template_root, "files")

def origin
  "git://github.com/thoughtbot/suspenders.git"
end

say "Getting rid of files we don't use"

remove_file "README"
remove_file "public/index.html"
remove_file "public/images/rails.png"

say "Setting up the staging environment"

run "cp config/environments/production.rb config/environments/staging.rb"

say "Creating suspenders views"

empty_directory "app/views/shared"
copy_file "_flashes.html.erb", "app/views/shared/_flashes.html.erb"
copy_file "_javascript.html.erb", "app/views/shared/_javascript.html.erb"
template "suspenders_layout.html.erb.erb",
         "app/views/layouts/application.html.erb",
         :force => true

say "Let's use jQuery"

%w(jquery jquery-ui).each do |file|
  trout "public/javascripts/#{file}.js"
end

download_file "https://github.com/rails/jquery-ujs/raw/master/src/rails.js",
          "public/javascripts/rails.js"

say "Pulling in some common javascripts"

trout "public/javascripts/prefilled_input.js"

say "Documentation"

copy_file "README_FOR_SUSPENDERS", "doc/README_FOR_SUSPENDERS"

say "Get ready for bundler... (this will take a while)"

trout 'Gemfile'
run "bundle install"

say "Let's use MySQL"

template "mysql_database.yml.erb", "config/database.yml", :force => true
rake "db:create"

say "Setting up plugins"

generators_config = <<-RUBY
    config.generators do |generate|
      generate.test_framework :rspec
    end
RUBY
inject_into_class "config/application.rb", "Application", generators_config

action_mailer_host "development", "#{app_name}.local"
action_mailer_host "test",        "example.com"
action_mailer_host "staging",     "staging.#{app_name}.com"
action_mailer_host "production",  "#{app_name}.com"

generate "rspec:install"
generate "cucumber:install", "--rspec --capybara"
generate "clearance"
generate "clearance_features"

create_file "public/stylesheets/sass/screen.scss"
create_file "public/stylesheets/screen.css"

copy_file "factory_girl_steps.rb", "features/step_definitions/factory_girl_steps.rb"

replace_in_file "spec/spec_helper.rb", "mock_with :rspec", "mock_with :mocha"

inject_into_file "features/support/env.rb",
                 %{Capybara.save_and_open_page_path = 'tmp'\n} +
                 %{Capybara.javascript_driver = :akephalos\n},
                 :before => %{Capybara.default_selector = :css}
replace_in_file "features/support/env.rb",
                %r{require .*capybara_javascript_emulation.*},
                ''

rake "flutie:install"

say "Ignore the right files"

concat_file "suspenders_gitignore", ".gitignore"
empty_directory_with_gitkeep "app/models"
empty_directory_with_gitkeep "app/views/pages"
empty_directory_with_gitkeep "db/migrate"
empty_directory_with_gitkeep "log"
empty_directory_with_gitkeep "public/images"
empty_directory_with_gitkeep "spec/support"

say "Copying miscellaneous support files"

copy_file "errors.rb", "config/initializers/errors.rb"
copy_file "time_formats.rb", "config/initializers/time_formats.rb"
copy_file "body_class_helper.rb", "app/helpers/body_class_helper.rb"

say "Setting up a root route"

route "root :to => 'Clearance::Sessions#new'"

say "Congratulations! You just pulled our suspenders."
say "Remember to run 'rails generate hoptoad' with your API key."

