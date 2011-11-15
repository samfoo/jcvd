require 'csv'
require 'mechanize'
require 'logger'

module ThoughtWorks
  class Timesheets
    def initialize(user, pass)
      @agent = Mechanize.new
      login(user, pass)
    end

    def lates(due_date)
      form = @agent.get("http://psfs89.thoughtworks.com/psc/fsprd89_6/EMPLOYEE/ERP/q/?ICAction=ICQryNameURL=PUBLIC.TW_TIME_MISSING_LATE_ONTIME").forms.first
      form.ICAction = "#ICOK"
      form.InputKeys_TW_WEEK_END_DT = due_date

      form = @agent.submit(form).forms.first
      form.ICAction = "#ICQryDownloadRaw"
      form.InputKeys_TW_WEEK_END_DT = due_date
      csv = @agent.submit(form)
      temp = Tempfile.new("jcvd-is-gonna-kick-your-face")
      temp.write(csv.content)
      temp.close

      all = CSV.read(temp.path)[1..-1]
      badguys = all.select { |e| e[0].downcase.start_with?("au") && e[4] == "Y" }
      badguys.collect do |e| 
        last, first = e[2].split(",")
        [first, last].join(" ")
      end
    end

    private

    def login(user, pass)
      form = @agent.get("http://psfs89.thoughtworks.com/psp/fsprd89/?cmd=login").forms.first

      form.userid = user
      form.pwd = pass

      @agent.submit(form, form.buttons.first)
    end
  end
end
