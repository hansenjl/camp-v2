class Request
    attr_accessor :first, :last, :city, :met, :camper, :value

    def initialize(req, city, camper, value)
      @met = false
      if req && req != " " && req != ""
        @first = req.split[0].strip
        @last = req.split[1] || ""
      end
      @city = city
      @value = value
      @camper = camper
    end

    def self.new_from_string(string, camper, value)
      if !string.nil? && !string.strip.empty?
        request1 =  string.split("(")
        req1_city = request1[-1].chomp(")") if request1[-1] != nil
        city_obj = City.find_or_create_by_name(req1_city.downcase) if req1_city
        if request1.length < 3
          req1 = request1[0].strip.upcase
        else
          r = request1[1].split(")") || ""
          req1 = request1[0].strip.upcase + " " + r[-1].strip.upcase
        end
      else
        req1 = nil
        city_obj = nil
      end
      Request.new(req1, city_obj, camper, value)
    end

  end