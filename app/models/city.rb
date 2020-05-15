class City
    attr_accessor :name
    @@all = []

    def initialize(name)
      @name = name.downcase if name
      @campers = []
      @@all << self
      self
    end

    def self.clear
      @@all = []
    end

    def self.all
      @@all
    end

    def campers
      @campers
    end

    def self.report
      rep = {}
      self.all.each do |c|
        rep[c.name] = c.campers.length
      end
      rep
    end

    def self.find_or_create_by_name(name)
      self.find_by_name(name) ? self.find_by_name(name) : self.new(name)
    end

    def self.find_by_name(name)
        all.detect{|c| c.name == name.downcase if name}
    end
  end