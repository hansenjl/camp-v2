class Request
    attr_accessor :first, :last, :city, :met, :camper, :val

    def initialize(req, city, camper, value)
      @met = false
      if req && req != " " && req != ""
        @first = req.split[0].strip
        @last = req.split[1]
      end
      @city = city
      @value = value
      @camper = camper
    end

  end