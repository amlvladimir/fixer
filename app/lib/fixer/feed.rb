# frozen_string_literal: true

require 'net/http'
require 'rexml/document'
require 'oj'
require 'logger'

module Fixer
  # Wraps ECB's data feed
  class Feed
    include Enumerable

    SCOPES = {
      current: 'daily',
      ninety_days: 'hist-90d',
      historical: 'hist'
    }.freeze

    LOG = Logger.new(STDOUT)

    def initialize(scope = :current)
      LOG.debug("111111142142")
      @scope = SCOPES.fetch(scope) { raise ArgumentError }
    end

    def each
      REXML::XPath.each(document, '/gesmes:Envelope/Cube/Cube[@time]') do |day|
        date = Date.parse(day.attribute('time').value)
        REXML::XPath.each(day, './Cube') do |currency|
          yield(
            date: date,
            iso_code: currency.attribute('currency').value,
            rate: Float(currency.attribute('rate').value)
          )
        end
      end
    end

    private

    def document
      REXML::Document.new(xml)
    end

    def xml
      Net::HTTP.get(url)
    end

    def url
      LOG.debug("https://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@scope}.xml")
      URI("https://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@scope}.xml")
    end
  end
end
