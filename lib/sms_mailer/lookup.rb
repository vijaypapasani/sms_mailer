module SmsMailer
  module Lookup
    def self.included(base)
      base.class_eval do
        cattr_accessor :phone_attr
        cattr_accessor :carrier_attr
        before_save :lookup_carrier
      end
      base.extend ClassMethods
    end

    def lookup_carrier   
      carrier_attr = self.class.carrier_attr || :carrier
      phone_attr = self.class.phone_attr || :phone   
      
      if self.send(carrier_attr).nil?
        phone_num = self.send(phone_attr)
        if carrier = SmsMailer::Carrier.lookup(phone_num)
          self.send("#{carrier_attr}=", carrier)
        end
      end
    end

    module ClassMethods
      def lookup_carrier_by options = {}
        self.phone_attr = options[:phone] || :phone
        self.carrier_attr = options[:carrier] || :carrier
      end
    end
  end


end