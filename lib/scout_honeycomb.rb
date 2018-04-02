module ScoutHoneycomb
  # All access to the agent is thru this class method to ensure multiple Agent instances are not initialized per-Ruby process.
  def self.init(honeycomb_client)
    @@honeycomb_client ||= honeycomb_client
  end

  def self.honeycomb_client
    @@honeycomb_client
  end

  def self.rails?
    defined? Rails::Railtie
  end
end

require "scout_honeycomb/version"
require "scout_honeycomb/layer_converter"
require "scout_honeycomb/railtie" if ScoutHoneycomb.rails?
