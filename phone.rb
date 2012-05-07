require 'twilio-ruby'

module ThoughtWorks
  class Phone
    def initialize(account_sid, auth_token, dryrun)
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      @account = @client.account
      @dryrun = dryrun
    end

    def call(number, say)
      if(@dryrun)
        puts "Calling #{number} to play the sound available at #{say}"
      else
      	@account.calls.create(:from => APP_CONFIG['twilio_number'], :to => number, :url => say)
      end
    end
  end
end
