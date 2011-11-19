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

          map[name] = [normalize(mobile, region), email]
          map
        end
      else
        tokens = name.split(" ")
        first, *middles, last = tokens

        return search ([first] + middles[0..-2] + [last]).join(" "), region if middles.size > 0
        {}
      end
    end

    private 

    def find_au_number(numbers)
      # Some people list more than one number in their GAB profile. Given a list
      # of numbers, pick the one that looks like it's an australian mobile.
      # This means it starts with either 04 or 61.
      #
      # If none of the numbers look australian, than just pick the first one.
      numbers.select { |n| n.start_with?("04") || n.start_with?("61") }.first || numbers.first
    end

    def normalize_au(number)
      number = number.gsub(/\s+/, "")
      number = number.gsub(/\./, "")
      number = number.gsub(/\(0\)/, "")
      number = number.gsub(/\(\+?61\)/, "+61")
      number = number.gsub(/\-/, "")
      number = find_au_number(number.split(/[^\d]/))
      
      number = "+#{number}" if number.start_with?("61")
      number = "+61#{number[1..-1]}" if number.start_with?("04")
      number = "+61#{number}" if number.start_with?("4")
      number = number.gsub(/\+6104/, "+614") if number.start_with?("+6104")
      number
    end

    def normalize(number, region)
      return number if number.size == 0

      method = "normalize_#{region.to_s}".to_sym
      if self.class.private_method_defined? method
        self.send(method, number)
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
