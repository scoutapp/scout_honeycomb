module ScoutSignalfx
  class Railtie < Rails::Railtie
    initializer "scout_signalfx.configure_rails_initialization" do |app|
      ScoutApm::Agent.instance.context.transaction_reporters << ScoutHoneycomb::LayerConverter
    end
  end
end