require File.dirname(__FILE__) + '/../helper'

with_steps_for :webrat, :database, :adlib do
  run_story File.expand_path(__FILE__)
end