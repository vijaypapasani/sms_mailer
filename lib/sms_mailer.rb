require "sms_mailer/version"
require "sms_mailer/carrier"
require "sms_mailer/notifier"
require "sms_mailer/lookup"
require "sms_mailer/railtie" if defined?(Rails)

module SmsMailer
  mattr_accessor :from_address, :async, :async_backend, :lookup_by

  class << self
    def setup
      yield self
    end

    def from_address
      @@from_address || "noreply@example.com"
    end

    def async?; @@async || false; end

    def deliver number, carrier, message, options = {}
      n = Notifier.new(number, carrier, message, options)
      n.send_message
    end
  end
end
