require File.expand_path(File.dirname(__FILE__) + '/../../betternestedset/init')
require 'RMagick'

begin
  require 'adlib/migrator'
  Adlib::Migrator.migrate(ENV['VERSION'], false) unless RAILS_ENV == 'test'

  require 'adlib/routing'
  require 'controllers/adlib_sessions_controller'
  require 'controllers/adlib_pages_controller'
  require 'controllers/adlib_snippets_controller'
  require 'controllers/adlib_images_controller'
  require 'models/adlib_user'
  require 'models/adlib_section'
  require 'models/adlib_page'
  require 'models/adlib_snippet'
  require 'models/adlib_image'
  require 'helpers/adlib_helper'
  include AdlibHelper

rescue; end
