class Camper
    attr_accessor :name_used, :first, :last, :age, :grade, :cabin, :prev_grade, :session, :city, :school, :birthdate, :tribe, :sibling_tribe, :tenure, :group_id_1, :group_id_2, :rid, :prev_cab, :past_camper_rating, :balance, :parent_notes, :admin_notes, :req1, :req2, :met1, :met2, :req1_city, :req2_city, :matched, :requests, :discount, :campmom_med_discount, :ofa_group

    @@all = []
    @@assigned = []
    @@unassigned = []

    def initialize(camper_hash)
      camper_hash.each do |key, value|
        self.send(("#{key}="), value)
      end
      self.matched = false
      c = City.find_or_create_by_name(@city)
      c.campers << self
      @city = c
      if @req1 && @req1 != ""  && @req1 != " "
        r1 = Request.new(@req1, City.find_or_create_by_name(@req1_city), self, 1)
        self.requests = [r1] if r1
        #only look at req 2 if req1 exists
        if @req2 && @req2 != ""  && @req2 != " "
          r2 = Request.new(@req2, City.find_or_create_by_name(@req2_city), self, 2)
          self.requests << r2  if r2
        end
      end
      @@all << self
      self
    end

    def self.all
      @@all
    end

    def self.sorted

      @@all.sort_by { |camper|  [-camper.group_id_1.to_i, camper.group_id_2 || 200, camper.birthdate] }
    end

    # def self.assigned
    #   @@assigned
    # end

    # def self.unassigned
    #   @@unassigned
    # end

    #assign group ids for all campers
    def self.assign
      #start with first camper
      #@@unassigned = self.all  #the @@unassigned are all campers without a groupid
      ## will loop through all but all won't be removed
      #until @@unassigned.length == @@assigned.length
      @@all.each_with_index do |camper,i|
        if camper.requests
          camper.assign(camper.requests)
        elsif camper.group_id_2 == nil
          camper.group_id_1 = camper.age
          #this person made no requests and hasn't been requested by anyone else yet
        end
      end
    end

    def assign(req)
      @requests.each do |req|
        #look for camper in his city group
        matches = req.city.campers.select{|c|c.last == req.last.upcase}
        if !matches.empty?
          person = matches.detect{|c|c.first == req.first.upcase}
          if !person
            person = matches.detect{|c|c.name_used == req.first.upcase}
          end
        else #if we didn't find a match, look at all campers

          matches = Camper.all.select{|c|c.last == req.last.upcase if req.last}
          if matches
            person = matches.detect{|c|c.first == req.first.upcase}
            if !person
              person = matches.detect{|c|c.name_used == req.first.upcase}
            end
          end
        end
        self.matched = true
        if person
          req.met = true
          ##both peeps have groups
          #1 has a group vice versa
          #none have groups
          if !!person.group_id_2  && !!self.group_id_2 && self.group_id_2 != person.group_id_2
            g1 = Group.find_by_letter(self.group_id_2)
            g2 = Group.find_by_letter(person.group_id_2)
            g1.campers.each do |c|
              c.assign_to_group(g2)
            end
            #BOTH have groups
          elsif !!self.group_id_2
            g = Group.find_by_letter(self.group_id_2)
            person.assign_to_group(g)
          elsif !!person.group_id_2
            g = Group.find_by_letter(person.group_id_2)
            self.assign_to_group(g)
          else
            #create a new group
            g = Group.new(self.age)
            person.assign_to_group(g)
            self.assign_to_group(g)
          end
        else
          self.group_id_1 = self.age
        end
      end
    end

    def assign_to_group(group)
      self.group_id_1 = group.age
      self.group_id_2 = group.letter
      group.campers << self
    end


    def self.find_by_last(last)
        all.detect{|c| c.last == last.upcase}
    end

    def self.find_by_name_used(name)
        all.detect{|c| c.name_used == name.upcase}
    end

     def self.find_by_first(first)
        all.detect{|c| c.first == first.upcase}
    end

  end

