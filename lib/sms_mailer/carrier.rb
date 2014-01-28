require 'ostruct'
require 'nokogiri'
require 'open-uri'
require 'yaml'

module SmsMailer
  class Carrier
    class << self
      def all
        carriers.map { |x| OpenStruct.new(x[1].merge("value" => x[0])) }
      end

      def lookup phone
        return nil unless valid_number?(phone)
        base_url = "http://www.fonefinder.net/findome.php"
        phone_params = {npa: phone[0..2], nxx: phone[3..5], thoublock: phone[6..9]}
        
        params = phone_params.map { |k,v| "#{k}=#{v}" }.join('&')
        url = "#{base_url}?#{params}&usaquerytype=Search+by+Number&cityname="

        doc = Nokogiri::HTML(open(url))
        el = doc.xpath("//table/tr/td/a")
        if el && el.size > 4
          link = el[4].attribute('href').to_s
          carrier = link.gsub(/http:\/\/fonefinder.net\/|\.php/, '')
          search_regexp = Regexp.new(carrier)
          return carrier if carriers.any?{ |a| a[0] =~ search_regexp }
        end
      end

      def carrier_name(key)
        carriers[key]['name']
      end

      def carrier_email(key)
        carriers[key]['address']
      end

      def carriers
        @@carriers ||= load_carriers
      end

      def load_carriers
        file = File.join(File.expand_path('../../../config', __FILE__), 'carriers.yml')
        YAML::load_file(file)
      end

      def sms_address number, carrier
        [format_number(number), "@", carrier_email(carrier)].join('')
      end

      protected

      def format_number number
        stripped = number.gsub("-","").strip
        formatted = (stripped.length == 11 && stripped[0,1] == "1") ? stripped[1..stripped.length] : stripped
        raise "Number (#{number}) is not formatted correctly" unless valid_number?(formatted)
        formatted
      end

      def valid_number? number
        number.length >= 10 && number[/^.\d+$/]
      end 
    end
  end
end