require 'twilio-ruby'

module ThoughtWorks
  class SMS
    def initialize(account_sid, auth_token)
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      @account = @client.account
    end

    def send(number, message)
      # The "from" number is our twilio number, this should probably be 
      # changed once international SMS is enabled.
      @account.sms.messages.create(:from => ENV["TWILIO_AUTHORIZED_SMS_FROM"], :to => number, :body => message)
    end
  end
end
