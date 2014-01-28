module SmsMailer
  class Notifier
    attr_reader :messages, :carrier, :number, :options

    def initialize number, carrier, message, options = {}
      @number = number
      @carrier = carrier
      @options = options
      @messages = split_message(message)
    end

    def send_message
      messages.each { |msg| deliver(msg) }
    end

    def split_message message
      if options.has_key?(:limit) && message.length > options[:limit]
        message.scan(/.{#{options[:limit]}}/m)
      else
        [message]
      end
    end

    def message_options msg
      from = options[:from] || SmsMailer.from_address  
      {
        from: from,
        reply_to: from,
        to: Carrier.sms_address(number, carrier),
        subject: "",
        body: msg
      }
    end

    def deliver msg
      opts = message_options(msg)

      if SmsMailer.async?
        case SmsMailer.async_backend
        when :delayed_job
          ActionMailer::Base.delay.mail(opts)
        when :rescue
          raise "Resque not yet supported!"
        when :sidekiq
          raise "Sidekiq not yet supported!"
        else
          raise "You must set config.async_backend for SmsMailer."
        end
      else
        ActionMailer::Base.mail(opts).deliver
      end
    end
  end
end