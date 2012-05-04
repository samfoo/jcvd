require 'twilio-ruby'

module ThoughtWorks
  class SMS
    def initialize(account_sid, auth_token, dryrun = false)
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      @account = @client.account
      @dryrun = dryrun
    end

    def send(number, message)
      # The "from" number is our twilio number, this should probably be
      # changed once international SMS is enabled.
      if(@dryrun)
        puts "Sending an SMS to #{number} with body:"
        puts message
      else
        @account.sms.messages.create(:from => APP_CONFIG['twilio_number'], :to => number, :body => message)
      end
    end
  end
end
