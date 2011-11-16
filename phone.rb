require 'twilio-ruby'

module ThoughtWorks
  class Phone
    def initialize(account_sid, auth_token)
      @client = Twilio::REST::Client.new(account_sid, auth_token)
      @account = @client.account
    end

    def call(number)
      @account.calls.create(:from => "+61467970000", :to => number, :url => "https://raw.github.com/samfoo/jcvd/master/say.xml")
    end
  end
end
