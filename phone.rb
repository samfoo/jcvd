require 'twilio-ruby'

module ThoughtWorks
  class Phone
    def initialize(account_sid, auth_token)
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      @account = @client.account
    end

    def call(number, say)
      @account.calls.create(:from => "+61467970000", :to => number, :url => say)
    end
  end
end
