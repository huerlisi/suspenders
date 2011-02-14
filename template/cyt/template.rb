# Suspenders
# ==========
# by CyT

require File.expand_path(File.dirname(__FILE__) + "/../helpers")

template_root = File.expand_path(File.join(File.dirname(__FILE__)))
source_paths << File.join(template_root, "files")

def origin
#  "git://github.com/huerlisi/cyt-suspenders.git"
  "~/src/github/huerlisi/startyt"
end

say "Adapt for CyT"
say "============="

# Cleanup
say "Getting rid of files we don't use"
remove_file "public/index.html"
remove_file "public/images/rails.png"

# Textile readme
say "Use Textile README"
remove_file "README"
template "README.textile.erb", "README.textile"

# Gemfile/Bundler
say "Create syncable Gemfile and run bundler"
trout 'Gemfile'
run "bundle install --local"

# Gitignore
say "Create syncable .gitignore"
trout ".gitignore"

# Style
say "Create syncable layout"
trout "app/views/layouts/application.html.haml"

# Authorization
say "Setup authentication"
generate "devise:install"
generate "devise", "User"
#copy_file "app/views/devise"
rake "db:migrate"

# Navigation
say "Setup navigation"
trout "config/initializers/simple_navigation.rb"
empty_directory "config/navigation"
trout "config/navigation/main_navigation.rb"
trout "config/navigation/user_navigation.rb"
# copy overview renderer etc.

# Testing
say "Setup testing"
generate "rspec:install"

# Formtastic
say "Setup form handling"
generate "formtastic:install"
trout "config/initializers/formtastic.rb"

# Localization
say "Setup german default locale"
trout "config/initializers/german_dates.rb"

# Landing page
say "Setup landing page"
route "get 'welcome/index'"
route "get 'welcome/home'"
route "root :to => 'welcome#index'"
empty_directory "app/views/welcome"
trout "app/controllers/welcome_controller.rb"
trout "app/views/welcome/home.html.haml"

      
# Styling
#generate "styleyt:theme"

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
