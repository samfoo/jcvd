require 'mechanize'
require 'csv'

module ThoughtWorks
  class Gab
    def initialize(user, pass)
      @agent = Mechanize.new
      @gab = login(user, pass)
    end

    def search(name)
      form = @gab.form("searchForm")
      form.q = name
      results = @agent.submit(form, form.buttons.first)
      rows = results.parser.xpath('//table[@class="search-results"]/tr')

      if rows.size > 1
        rows[1..-1].inject({}) do |map, node| 
          name = node.xpath("td")[0].text.strip
          mobile = node.xpath("td")[3].text.strip
          email = "#{node.xpath("td")[4].text.strip.split(",")[0]}@thoughtworks.com"

          map[name] = [mobile, email]
          map
        end
      else
        # TODO: Handle names better.
        name_tokens = name.split(" ")

        if name_tokens.size > 2
          search [name_tokens[0], name_tokens[-1]].join(" ")
        else
          {}
        end
      end
    end

    private 

    def login(user, pass)
      form = @agent.get("http://gab.thoughtworks.com/").forms.first

      form.password = pass 
      form.username = user 

      @gab = @agent.submit(form, form.buttons.first)
    end

  end
end
