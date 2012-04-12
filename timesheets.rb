require 'csv'
require 'mechanize'
require 'logger'

module ThoughtWorks
  class Timesheets
    def initialize(user, pass)
      @agent = Mechanize.new
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_file 'cacert.pem'
      @agent.agent.cert_store = cert_store
      login(user, pass)
    end

    def lates(due_date, region)
      # Here be dragons... 
      #
      # For some reason, peoplesoft doesn't seem to like it when I make a
      # request to get the raw csv before you've made an initial query to 
      # fetch rows as html *sigh*. There must be some state stored in the 
      # session cookie or just on the server side session -- the truth is I'm
      # too lazy to figure it out.
      #
      # It's easier just to ask for the first page of the report as html, then
      # ask for the whole thing as csv.
      form = @agent.get("http://psfs89.thoughtworks.com/psc/fsprd89_6/EMPLOYEE/ERP/q/?ICAction=ICQryNameURL=PUBLIC.TW_TIME_MISSING_LATE_ONTIME").forms.first
      form.ICAction = "#ICOK"
      form.InputKeys_TW_WEEK_END_DT = due_date

      # Now that we've set our state in whatever magical way that we had to, we
      # can then download the report as csv.
      form = @agent.submit(form).forms.first
      form.ICAction = "#ICQryDownloadRaw"
      form.InputKeys_TW_WEEK_END_DT = due_date
      csv = @agent.submit(form)
      
      # There's a weird encoding problem that crashes the csv parser when 
      # reading from a string. If we write to a temp file first, the encoding
      # seems to get figured out properly when opening and reading it. This is
      # pretty hacky, but it works for now.
      temp = Tempfile.new("jcvd-is-gonna-kick-your-face")
      temp.write(csv.content)
      temp.close

      # Now that we've got the data: read the file into an array of arrays,
      # filter out the regions that aren't interesting and swap the first/last
      # names so they're in the right order returning only the list of names
      # that we found.
      all = CSV.read(temp.path)[1..-1]
      badguys = all.select { |e| e[0].downcase.start_with?(region) && e[4] == "Y" }
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
