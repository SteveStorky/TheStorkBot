require "facebook/messenger"
include Facebook::Messenger
Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])
# message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
# message.sender      # => { 'id' => '1008372609250235' }
# message.sent_at     # => 2016-04-22 21:30:36 +0200
# message.text        # => 'Hello, bot!'
Bot.on :message do |message|

  # Connect to API.ai when got facebook message
  client = ApiAiRuby::Client.new( :client_access_token => ENV["API_AI_ACCESS_TOKEN"] )
  # Will be replace by initialize services class soon

  # Send facebook message's message to API.ai
  response = client.text_request message.text
  action = response[:result][:action]
  speech = response[:result][:fulfillment][:speech] || "Wait..."
  # Will ber replaced by messaging system class soon

  # Processor
  # Will be replaced with more neat class & API connections

  # Shipment Status (Dummy)
  if action == "tracking.shipment" and response[:result][:parameters][:tracking_number] != ''
      additionalinfo = response[:result][:parameters][:tracking_number]
      #additionalinfo = "Oops"
      Bot.deliver({
  	recipient: message.sender,
  	message: {
  	    text: additionalinfo+" is being prepared for delivery in the delivery depot."
  	}
      }, access_token: ENV["ACCESS_TOKEN"])
  end

  # Reply to sender
  Bot.deliver({
    recipient: message.sender,
    message: {
      text: speech
    }
  }, access_token: ENV["ACCESS_TOKEN"])

end
