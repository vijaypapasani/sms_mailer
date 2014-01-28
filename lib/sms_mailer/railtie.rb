require 'rails'
require 'sms_mailer/view_helpers'

module SmsMailer
  class Railtie < Rails::Railtie
    initializer "sms_mailer.view_helpers" do
      ActionView::Base.send :include, ViewHelpers

      ActionView::Helpers::FormBuilder.send(:define_method, :carrier_select) do |method, options = {}, html_options = {}|
        @template.carrier_select(@object_name, method, objectify_options(options), @default_options.merge(html_options))
      end
    end
  end
end