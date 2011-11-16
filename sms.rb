require 'mechanize'

module ThoughtWorks
  class SMS
    def initialize(user, pass)
      @agent = Mechanize.new
      @user, @pass = user, pass
    end

    def send(number, message)
      content = "m4u\r\nUSER=#{@user}#\r\nPASSWORD=#{@pass}\r\nVER=PHP1.0\r\nMESSAGES2.0\r\n0 #{number} 0 169 1 #{message}\r\n.\r\n"
      puts content
      results = @agent.request_with_entity(:post, "http://smsmaster.m4u.com.au", content)
    end
  end
end
