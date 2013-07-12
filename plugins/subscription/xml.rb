# -*- coding: utf-8 -*-
# Name::      Automatic::Plugin::Subscription::Xml
# Author::    774 <http://id774.net>
# Created::   Jul 12, 2013
# Updated::   Jul 12, 2013
# Copyright:: Copyright (c) 2012-2013 Automatic Ruby Developers.
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

module Automatic::Plugin
  class SubscriptionXml
    require 'open-uri'
    require 'active_support'
    require 'active_support/core_ext'
    require 'rss'

    def initialize(config, pipeline=[])
      @config = config
      @pipeline = pipeline
    end

    def run
      @return_feeds = []
      @config['urls'].each {|url|
        retries = 0
        begin
          create_rss(URI.encode(url))
        rescue
          retries += 1
          Automatic::Log.puts("error", "ErrorCount: #{retries}, Fault in parsing: #{url}")
          sleep @config['interval'].to_i unless @config['interval'].nil?
          retry if retries <= @config['retry'].to_i unless @config['retry'].nil?
        end
      }
      @return_feeds
    end

    private
    def create_rss(url)
      Automatic::Log.puts("info", "Parsing: #{url}")
      hash = Hash.from_xml(open(url).read)
      json = hash.to_json
      data = ActiveSupport::JSON.decode(json)
      unless data.nil?
        rss = Automatic::FeedParser.content_provide(url, data)
        sleep @config['interval'].to_i unless @config['interval'].nil?
        @return_feeds << rss
      end
    end
  end
end
