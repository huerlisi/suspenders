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
#run "bundle install"

# Gitignore
say "Create syncable .gitignore"
trout ".gitignore"

# Style
say "Create syncable layout"
trout "app/views/layouts/application.html.haml"

# Authorization
generate "devise:install"
generate "devise", "User"
#copy_file "app/views/devise"
rake "db:migrate"

# Navigation
trout "config/initializers/simple_navigation.rb"
trout "config/navigation"
# copy overview renderer etc.


if false

# Styling
generate "styleyt:theme"

# Testing
generate "rspec:install"

# Formtastic
generate "formtastic:install"
copy_file "config/initializers/formtastic.rb"

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
end
