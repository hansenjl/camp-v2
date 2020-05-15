require_relative './parser'
class Camper
  attr_accessor :matched, :requests#, :name_used, :first, :last, :age, :grade, :cabin, :prev_grade, :session, :city, :school, :birthdate, :tribe, :sibling_tribe, :years_at_ozark, :group_id, :group_id2, :rid2, :prev_cab, :past_camper_rating, :balance, :parent_notes, :admin_notes, :request_1, :request_2, :met1, :met2,  :discount, :campmom_med_discount, :ofa_group, :sibs, :if_no_why1, :if_no_why2, :if_no_why3, :met3


  def self.make_attribute_readers_and_writers(headers)
    headers.each do |h|
      attr_accessor(h)
    end
  end

    @@all = []


#      ["session",
#  "name used",
#  "CABIN",
#  "age",
#  "grade",
#  "prev_grade",
#  "first",
#  "last",
#  "city",
#  "school",
#  "birthdate",
#  "tribe",
#  "sibling_tribe",
#  "years at ozark",
#  "group id",
#  "group id2",
#  "rid2",
#  "prev_cab",
#  "past_camper_rating",
#  "balance",
#  "discount",
#  "campmom_med_discount",
#  "parent_notes",
#  "admin_notes",
#  "met#1",
#  "if no, why#1",
#  "Request 1",
#  "met#2",
#  "if no, why#2",
#  "Request 2",
#  "met#3",
#  "if no, why#3",
#  "ofa_group",
#  "sibs"]

    def initialize(camper_hash)
      camper_hash.each do |key, value|
        self.send(("#{key}="), value)
      end
      self.matched = false
      self.city= City.find_or_create_by_name(@city)
      self.city.campers << self
      if @request_1 && @request_1 != ""  && @request_1 != " "
        r1 = Request.new_from_string(@request_1, self, 1)
        #r1 = Request.new(@req1, City.find_or_create_by_name(@req1_city), self, 1)
        self.requests = [r1] if r1
        #only look at req 2 if req1 exists
        if @request_2 && @request_2 != ""  && @request_2 != " "
          r2 = Request.new_from_string(@request_2, self, 2)
          #r2 = Request.new(@req2, City.find_or_create_by_name(@req2_city), self, 2)
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

      @@all.sort_by { |camper|  [-camper.group_id.to_i, camper.group_id2 || 200, camper.birthdate] }
    end

    def self.make_from_row(line, headers)
      attr_hash = {}
      headers.each_with_index do |h, i|
        attr_hash[h] = line[i]
      end
      self.new(attr_hash)
    end


    #assign group ids for all campers
    def self.assign
      #start with first camper
      ## will loop through all but all won't be removed

      @@all.each_with_index do |camper,i|
        if camper.requests
          camper.assign
        elsif camper.group_id2 == nil
          camper.group_id = camper.age
          #this person made no requests and hasn't been requested by anyone else yet
        end
      end
    end

    def assign
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
          if !!person.group_id2  && !!self.group_id2 && self.group_id2 != person.group_id2
            g1 = Group.find_by_letter(self.group_id2)
            g2 = Group.find_by_letter(person.group_id2)
            g1.campers.each do |c|
              c.assign_to_group(g2)
            end
            #BOTH have groups
          elsif !!self.group_id2
            g = Group.find_by_letter(self.group_id2)
            person.assign_to_group(g)
          elsif !!person.group_id2
            g = Group.find_by_letter(person.group_id2)
            self.assign_to_group(g)
          else
            #create a new group
            g = Group.new(self.age)
            person.assign_to_group(g)
            self.assign_to_group(g)
          end
        # else
        #   self.group_id = self.age
        end
      end
    end

    def assign_to_group(group)

      self.group_id = group.age
      self.group_id2 = group.letter
      #group.campers << self
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

