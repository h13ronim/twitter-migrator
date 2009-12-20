#!/usr/bin/env ruby

require 'rubygems'
gem 'twitter4r', '0.3.2'
require 'twitter'

class TwitterMigration

  def initialize
    config_file = File.join(File.dirname(__FILE__), 'twitter.yml')
    @old_twitter = Twitter::Client.from_config(config_file, 'old')
    @new_twitter = Twitter::Client.from_config(config_file, 'new')
    puts ":)"
  end

  def old_my_friends
    friends = []
    @old_twitter.my(:friends).each { |friend| friends << [friend.id, friend.screen_name, friend.name] }
    friends
  end

  def new_my_friends
    friends = []
    @new_twitter.my(:friends).each { |friend| friends << [friend.id, friend.screen_name, friend.name] }
    friends
  end

  def create_new_friends
    @old_twitter.my(:friends).each do |friend|
      puts [friend.id, friend.screen_name, friend.name].join(" ")
      # begin
        @new_twitter.friend(:add, friend.id)
      # rescue Twitter::RESTError
      #   next
      # end
    end
  end
end

twitter_migration = TwitterMigration.new
twitter_migration.create_new_friends
