module SmsMailer
  module ViewHelpers
    def carrier_collection
      SmsMailer::Carrier.carriers.sort.collect { |carrier| [carrier[1]["name"], carrier[0]] }
    end
    
    def carrier_select(object, method, options = {}, html_options = {}, &block)
      ActionView::Helpers::Tags::Select.new(object, method, self, carrier_collection, options, html_options, &block).render
    end
  end
end