class Group
    attr_accessor :age, :letter
    attr_reader :campers
    @@counter = 0
    @@all = []
    def initialize(age)
      @campers = []
      @age = age
      @letter = @@counter
      @@counter += 1
      @@all << self
    end

    def self.all
      @@all
    end

    def size
      @campers.try(:length)
    end

    def self.find_by_letter(let)
      all.detect{|g| g.letter == let}
    end

  end