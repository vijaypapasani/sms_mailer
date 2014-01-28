# SMS Mailer

SMS Mailer makes it easy and free to send text messages via email. Much of the code was "borrowed" from [Brendan Lim's sms-fu](https://github.com/brendanlim/sms-fu).

It provides some helpers so you can get started sending messages quickly, and supports asynchronous emails using Delayed Job.

## Install

Add this line to your application's Gemfile:
```ruby
gem 'sms_mailer', github: "rzane/sms_mailer"
```

And then execute:

    $ bundle

## Setup

Setup Action Mailer and add the following to an initializer:
```ruby
SmsMailer.setup do |config|
  config.from_address = "kel@example.com"
end
```

## Usage

Send a message by providing a phone number, a carrier, and a message:
```ruby
SmsMailer.deliver("1234567689", "verizon", "Who loves orange soda?")
```

Override the from_address from your initializer with the from option:
```ruby
SmsMailer.deliver("1234567689", "verizon", "Kel loves orange soda!", from: "keenan@example.com")
```

Limit the length of the message and send it in pieces:
```ruby
SmsMailer.deliver("1234567689", "verizon", "Is it true? Is it true? Oh yes, oh yes, oh yes. It's true.", limit: 20)
```

## View Helpers (Rails)

Get a list of carrier names and their lowercased and simplified values:

    <%= carrier_collection %>

Output a select box:

    <%= carrier_select :user, :carrier %>

Or use a form object:

    <%= form_for @user do |f| %>
      <%= f.carrier_select :carrier %>
    <% end %>

## Carrier Lookup Helper (ActiveRecord)

If you want to lookup the phone number attribute on your model, and set the carrier attribute in a before_save callback, here's how:
```ruby
class User < ActiveRecord::Base
  include SmsMailer::Lookup
  lookup_carrier_by phone: :phone_number, carrier: :carrier_name
end
```

You only need to call `lookup_carrier_by` if your phone and carrier attributes are named something other than `:phone` and `:carrier`. In the example above, the phone number attribute is `:phone_number` and the carrier attribute is `:carrier_name`.

__NOTE:__ _This isn't 100% accurate. If the number changed carriers, it might return the wrong carrier. Also, it might return nil if it doesn't find the carrier. It uses fonefinder.net to perform the lookups._

## Other Fun Stuff
Get the formatted email address:
```ruby
SmsMailer::Carrier.sms_address("6097583444", "att") 
=> "6097583444@txt.att.net"
```

Get the formatted name of the carrier for presentation:
```ruby
SmsMailer::Carrier.carrier_name("alltel")
=> "Alltel"
```

Get all of the carriers:
```ruby
SmsMailer::Carrier.all 
=> [#<OpenStruct name="Alltel", address="message.alltel.com", value="alltel">, #<OpenStruct name="Ameritech", address="paging.acswireless.com", value="ameritech">, #<OpenStruct name="AT&T", address="txt.att.net", value="at&t">, #<OpenStruct name="Bell Atlantic", address="message.bam.com"...
```

Lookup the carrier by phone number:
```ruby
SmsMailer::Carrier.lookup("6096175949")
=> "verizon"
```
## Asynchronous Mailers

In your setup block, just add the following:
```ruby
SmsMailer.setup do |config|
  config.async = true
  config.async_backend = :delayed_job
end
```

_SMS Mailer currently only supports delayed_job. Sidekiq and Resque are planned, though._

## Supported Carriers (US & International)

###### US Carriers

* Alltel
* Ameritech
* AT&T
* Bell Atlantic
* Bellsouth Mobility
* BlueSkyFrog
* Boost Mobile
* Cellular South
* Comcast PCS
* Cricket
* kajeet
* Metro PCS
* Nextel
* Powertel
* PSC Wireless
* Qwest
* Southern Link
* Sprint PCS
* Suncom
* T-Mobile
* Tracfone
* Telus Mobility
* Virgin Mobile
* Verizon Wireless

###### International Carriers

* Aliant (Canada)
* Beeline
* Bell Mobility (Canada)
* BPL Mobile
* Claro (Brazil)
* Claro (Nicaragua)
* Du (UAE)
* E-Plus (Germany)
* Etisalat (UAE)
* Fido
* Koodoo (Canada)
* Manitoba Telecom (Canada)
* Mobinil
* Mobistar (Belgium)
* Mobitel
* Movistar (Spain)
* NorthernTel (Canada)
* o2 (Germany)
* o2 (UK)
* Orange (Mumbai)
* Orange (Netherlands)
* Orange (UK)
* Rogers Wireless
* Rogers (Canada)
* SaskTel (canada)
* SFR (France)
* T-Mobile (Austria)
* T-Mobile (Netherlands)
* T-Mobile (UK)
* Telebec (Canada)
* Telefonica (Spain)
* Telus (Canada)
* Virgin (Canada)
* Vodafone (Germany)
* Vodafone (Egypt)
* Vodafone (UK)
* Vodafone (Italy)
* Vodafone (Japan - Chuugoku)
* Vodafone (Japan - Hokkaido)
* Vodafone (Japan - Hokuriko)
* Vodafone (Japan - Kansai)
* Vodafone (Japan - Osaka)
* Vodafone (Japan - Kanto)
* Vodafone (Japan - Koushin)
* Vodafone (Japan - Tokyo)
* Vodafone (Japan - Kyuushu)
* Vodafone (Japan - Okinawa)
* Vodafone (Japan - Shikoku)
* Vodafone (Japan - Touhoku)
* Vodafone (Japan - Niigata)
* Vodafone (Japan - Toukai)
* Vodafone (Japan - Spain)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
