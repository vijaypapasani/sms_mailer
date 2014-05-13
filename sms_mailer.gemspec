# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sms_mailer/version'

Gem::Specification.new do |spec|
  spec.name          = "sms_mailer"
  spec.version       = SmsMailer::VERSION
  spec.authors       = ["Ray Zane"]
  spec.email         = ["rzane@bodnargroup.com"]
  spec.summary       = %q{Send SMS with Ruby for FREE via Email.}
  spec.description   = %q{SMS Mailer allows you to send text messages for free using email to text services. It provides lots of helpers for integrating with your Ruby on Rails application.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "actionmailer", '>= 3.2.11'
  spec.add_dependency "railties"
  spec.add_dependency "nokogiri"
  
  spec.add_development_dependency "bundler", "~> 1.4"
  spec.add_development_dependency "rake"
end
