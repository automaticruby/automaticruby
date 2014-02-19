# -*- coding: utf-8 -*-
# Name::      Automatic::Plugin::Subscription::Text
# Author::    soramugi <http://soramugi.net>
#             774 <http://id774.net>
# Created::   May  6, 2013
# Updated::   Feb 19, 2014
# Copyright:: Copyright (c) 2012-2014 Automatic Ruby Developers.
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

module Automatic::Plugin
  class TextFeed
    attr_accessor :title, :link, :description, :author, :comments

    def initialize
      @link        = 'http://dummy'
      @title       = 'dummy'
      @description = ''
      @author      = ''
      @comments    = ''
    end
  end

  class SubscriptionText

    def initialize(config, pipeline=[])
      @config   = config
      @pipeline = pipeline
    end

    def run
      create_feed

      if @dummyfeeds != []
        @pipeline << Automatic::FeedParser.create(@dummyfeeds)
      end
      @pipeline
    end

    private

    def generate_textfeed(feed)
      textFeed = TextFeed.new
      textFeed.title = feed['title'] unless feed['title'].nil?
      textFeed.link = feed['url'] unless feed['url'].nil?
      textFeed.description = feed['description'] unless feed['description'].nil?
      textFeed.author = feed['author'] unless feed['author'].nil?
      textFeed.comments = feed['comments'] unless feed['comments'].nil?
      @dummyfeeds << textFeed
    end

    def create_feed
      unless @config.nil?
        @dummyfeeds = []
        unless @config['titles'].nil?
          @config['titles'].each {|title|
            feed = {}
            feed['title'] = title
            generate_textfeed(feed)
          }
        end

        unless @config['urls'].nil?
          @config['urls'].each {|url|
            feed = {}
            feed['url'] = url
            generate_textfeed(feed)
          }
        end

        unless @config['feeds'].nil?
          @config['feeds'].each {|feed|
            generate_textfeed(feed)
          }
        end

        unless @config['file'].nil?
          open(@config['file']) do |file|
            file.each_line do |line|
              feed = {}
              feed['title'], feed['link'], feed['description'], feed['author'],
              feed['comments'] = line.force_encoding("utf-8").strip.split("\t")
              generate_textfeed(feed)
            end
          end
        end
      end
    end

  end
end
