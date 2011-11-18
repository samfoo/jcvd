require 'mechanize'

module ThoughtWorks
  class Gab
    def initialize(user, pass)
      @agent = Mechanize.new
      @gab = login(user, pass)
    end

    def search(name, region)
      form = @gab.form("searchForm")
      form.q = name
      results = @agent.submit(form, form.buttons.first)
      rows = results.parser.xpath('//table[@class="search-results"]/tr')

      if rows.size > 1
        rows[1..-1].inject({}) do |map, node| 
          name = node.xpath("td")[0].text.strip
          mobile = node.xpath("td")[3].text.strip
          email = node.xpath("td")[1].text.strip

          map[name] = [normalize(mobile), email]
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

    def pick_oz_number(numbers)
      numbers.inject(numbers.first) do |n, cur|
        if cur.start_with?("04") || cur.start_with?("61")
          cur
        else
          n
        end
      end
    end

    def normalize_au(number)
      number = number.gsub(/\s+/, "")
      number = number.gsub(/\./, "")
      number = number.gsub(/\(0\)/, "")
      number = number.gsub(/\(\+?61\)/, "+61")
      number = number.gsub(/\-/, "")
      number = pick_oz_number(number.split(/[^\d]/))
      
      number = "+#{number}" if number.start_with?("61")
      number = "+61#{number[1..-1]}" if number.start_with?("04")
      number = "+61#{number}" if number.start_with?("4")
      number = number.gsub(/\+6104/, "+614") if number.start_with?("+6104")
      number
    end

    def normalize(number, region)
      return number if number.size == 0

      method = "normalize_#{region.to_s}"
      if respond_to?(method)
        send(method, number)
      else
        number
      end
    end

    def login(user, pass)
      form = @agent.get("http://gab.thoughtworks.com/").forms.first

      form.password = pass 
      form.username = user 

      @gab = @agent.submit(form, form.buttons.first)
    end

  end
end
