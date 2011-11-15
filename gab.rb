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
          map[node.xpath("td")[0].text.strip] = node.xpath("td")[3].text.strip
          map
        end
      else
        name_tokens = name.split(" ")

        if name_tokens.size > 2
          search [name_tokens[0], name_tokens[-1]].join(" ")
        else
          [nil, nil]
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
