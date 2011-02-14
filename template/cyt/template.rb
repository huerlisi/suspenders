# Suspenders
# ==========
# by CyT

require File.expand_path(File.dirname(__FILE__) + "/../helpers")

template_root = File.expand_path(File.join(File.dirname(__FILE__)))
source_paths << File.join(template_root, "files")

def origin
  "git://github.com/huerlisi/startyt.git"
end

def with_git(message, &block)
  yield
  
  run "git add ."
  quoted_message = message.gsub("'", "'\"'\"'")
  run "git commit --all --message '#{quoted_message}'"
end

say "Adapt for CyT"
say "============="

# Initialize git
say "Initialize git"
run "git init"
run "git add ."
run "git commit --message 'Import #{app_name}'"

# Cleanup
with_git "Getting rid of files we don't use" do
  remove_file "public/index.html"
  remove_file "public/images/rails.png"
end

# Textile readme
with_git "Use Textile README" do
  remove_file "README"
  template "README.textile.erb", "README.textile"
end

# Gemfile/Bundler
with_git "Create syncable Gemfile and run bundler" do
  trout 'Gemfile'
  run "bundle install --local"
end

# Gitignore
with_git "Create syncable .gitignore" do
  trout ".gitignore"
end

# Templating
with_git "Configure HAML for templates" do
  remove_file "app/views/layouts/application.html.erb"
end

# Generators
with_git "Configure generators" do
  generators_config = <<-RUBY
    config.generators do |generate|
      generate.stylesheets false
      generate.test_framework :rspec
      generate.template_engine :haml
      generate.fixture_replacement :factory_girl
    end
  RUBY
  inject_into_class "config/application.rb", "Application", generators_config
end

# Style
with_git "Create syncable layout" do
  trout "app/views/layouts/application.html.haml"
  generate "styleyt:theme"
  trout "config/compass.rb"
  trout "config/initializers/compass.rb"
end

# Authorization
with_git "Setup authentication" do
  generate "devise:install"
  generate "devise", "User"
  #copy_file "app/views/devise"
  rake "db:migrate"
end

# Navigation
with_git "Setup navigation" do
  trout "config/initializers/simple_navigation.rb"
  empty_directory "config/navigation"
  trout "config/navigation/main_navigation.rb"
  trout "config/navigation/user_navigation.rb"
  # copy overview renderer etc.
end

# Testing
with_git "Setup testing" do
  generate "rspec:install"
end

# Form framework
with_git "Setup form framework" do
  generate "formtastic:install"
  trout "config/initializers/formtastic.rb"
end

# Localization
with_git "Setup german default locale" do
  trout "config/initializers/german_dates.rb"
end

# Landing page
with_git "Setup landing page" do
  route "get 'welcome/index'"
  route "get 'welcome/home'"
  route "root :to => 'welcome#index'"
  empty_directory "app/views/welcome"
  trout "app/controllers/welcome_controller.rb"
  trout "app/views/welcome/home.html.haml"
end

# Application settings
#template "config/application.rb"

# Landing page
# Generate welcome and overview controllers, add default route.

# Initialize CanCan
# Migrations
# Models, Ability

# Initialize Tagging
#generate "acts_as_taggable_on:migration"
#rake "db:migrate"
