class Parser
    attr_reader :data, :path
    @@codes = %w[A B C D E F G H I J K L M N O P Q R S T U V W Y Z AA BB CC DD EE FF GG HH II JJ KK LL MM NN OO PP QQ RR SS TT UU VV WW YY ZZ AAA BBB CCC DDD EEE FFF GGG HHH III JJJ KKK LLL MMM NNN OOO PPP QQQ RRR SSS TTT UUU VVV WWW YYY ZZZ AAAA BBBB CCCC DDDD EEEE FFFF GGGG HHHH IIII JJJJ KKKK LLLL MMMM NNNN OOOO PPPP QQQQ RRRR SSSS TTTT UUUU VVVV WWWW YYYY ZZZZ AAAAA BBBBB CCCCC DDDDD EEEEE FFFFF GGGGG HHHHH IIIII JJJJJ KKKKK LLLLL MMMMM NNNNN OOOOO PPPPP QQQQQ RRRRR SSSSS TTTTT UUUUU VVVVV WWWWW YYYYY ZZZZZ AAAAAA BBBBBB CCCCCC DDDDDD EEEEEE FFFFFF GGGGGG HHHHHH IIIIII JJJJJJ KKKKKK LLLLLL MMMMMM NNNNNN OOOOOO PPPPPP]


    def initialize(data:, path:)
        @data = data
        @path = path
    end

    def import
        ### TO DO ###
        # siblings needs to be an attribute
        # set the camper attr_accessors using the headers but first sanatize headers to make snake case
        # make it so it doesn't skip alpha codes (assign codes at the end not during ?)
        # spot check to make sure it's working
        # host to heroku

      #make a new variable of snake case headers
      @new_headers = @data.headers.map do |h|
        h.downcase.split(" ").join("_").gsub(",","").gsub("#","")
      end
      Camper.make_attribute_readers_and_writers(@new_headers)


      @data.each do |line|
        #instantiate new camper
        Camper.make_from_row(line, @new_headers)
       end
    end

    def create
      sorted = Camper.sorted
      Group.assign_codes
      new_data = CSV.generate do |csv|
        csv << @data.headers
        sorted.each do |c|
          group2 = c.group_id2 == "" ? "X" : c.group_id2
          c.group_id = c.age if c.group_id == nil
        ### make the line below more dynamic and/or move the array part to the Camper class
          csv << [c.session, c.name_used, "", c.age, c.grade, c.prev_grade, c.first, c.last, c.city.name, c.school, c.birthdate, c.tribe, c.sibling_tribe, c.years_at_ozark, c.group_id, group2, c.rid2, c.prev_cab, c.past_camper_rating, c.balance, c.discount, c.campmom_med_discount, c.parent_notes, c.admin_notes, "", "", c.request_1, "", "", c.request_2, "", "", c.ofa_group, c.sibs]
        end
      end
      new_data
    end
  end
