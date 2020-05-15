class Group
    attr_accessor :age, :letter, :code

    @@counter = 0
    @@all = []
    def initialize(age)
      @campers = []
      @age = age
      @letter = @@counter
      @@counter += 1
      @@all << self
    end

    def campers
      Camper.all.select{|c|c.group_id2 == self.letter }
    end

    def self.all
      @@all
    end

    def size
      if campers
        campers.length
      end
    end

    def self.find_by_letter(let)
      all.detect{|g| g.letter == let}
    end

    def self.new_code(code)
      #"A" = 65 "Z" = 90
      if code[-1].ord < 90
        new_code = code.split("").map{|c| (c.ord + 1).chr}.join
      else
        new_length = code.length + 1
        new_code = "A" * new_length
      end
      new_code
    end
    #turn this into a generator later

    def code=(code)
      age = self.campers.map(&:age).max

      self.campers.each do |c|
        c.group_id = age
        c.group_id2 = code
      end

      @code = code
    end

    def self.assign_codes
      @@all.delete_if{|g| g.size == 0}
      code = "A"
      @@all.each do |g|
        g.code = code
        code = new_code(code)
      end
    end

  end