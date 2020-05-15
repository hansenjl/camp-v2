class Parser
    attr_reader :data, :path
    @@codes = %w[A B C D E F G H I J K L M N O P Q R S T U V W Y Z AA BB CC DD EE FF GG HH II JJ KK LL MM NN OO PP QQ RR SS TT UU VV WW YY ZZ AAA BBB CCC DDD EEE FFF GGG HHH III JJJ KKK LLL MMM NNN OOO PPP QQQ RRR SSS TTT UUU VVV WWW YYY ZZZ AAAA BBBB CCCC DDDD EEEE FFFF GGGG HHHH IIII JJJJ KKKK LLLL MMMM NNNN OOOO PPPP QQQQ RRRR SSSS TTTT UUUU VVVV WWWW YYYY ZZZZ AAAAA BBBBB CCCCC DDDDD EEEEE FFFFF GGGGG HHHHH IIIII JJJJJ KKKKK LLLLL MMMMM NNNNN OOOOO PPPPP QQQQQ RRRRR SSSSS TTTTT UUUUU VVVVV WWWWW YYYYY ZZZZZ AAAAAA BBBBBB CCCCCC DDDDDD EEEEEE FFFFFF GGGGGG HHHHHH IIIIII JJJJJJ KKKKKK LLLLLL MMMMMM NNNNNN OOOOOO PPPPPP]
    @@all = []

    def initialize(data:, path:)
        @data = data
        @path = path
        @@all << self
    end

    def self.last
        @@all[-1]
    end

    # @data.headers gives all headers
    # @data[0] gives first row of data after headers

    def import
      @data.each do |line|
        #sanitize camper request data
        if !line["Request 1"].nil? && !line["Request 1"].strip.empty?
          request1 =  line["Request 1"].split("(")
          req1_city = request1[-1].chomp(")") if request1[-1] != nil
          req1_city.downcase if req1_city
          if request1.length < 3
            req1 = request1[0].strip.upcase
          else
            r = request1[1].split(")")
            req1 = request1[0].strip.upcase + " " + r[-1].strip.upcase
          end
        else
          req1 = nil
          req1_city = nil
        end
        if !line["Request 2"].nil? && !line["Request 2"].strip.empty?
          request2 = line["Request 2"].split("(")
          req2_city = request2[-1].split(")")[0] if request2[-1] != nil
          req2_city.downcase if req2_city
          if request2.length < 3
            req2 = request2[0].strip.upcase
          else
            r = request2[1].split(")")
            req2 = request2[0].strip.upcase + " " + r[-1].strip.upcase
          end
        else
          req2 = nil
          req2_city = nil
        end

        #instantiate new camper
        #need to fix this to make it more abstract and use the passed in row headers
        Camper.new({name_used: line["name used"], first: line["first"], last: line["last"], age: line["age"], grade: line["grade"], session: line["session"], city: line["city"], prev_grade: line["prev_grade"], school: line["school"], birthdate: line["birthdate"], tribe: line["tribe"], sibling_tribe: line["sibling_tribe"], tenure: line["years at ozark"], rid: line["rid2"], prev_cab: line["prev_cab"], past_camper_rating: line["past_camper_rating"], balance: line["balance"], parent_notes: line["parent_notes"], discount: line["discount"], campmom_med_discount: line["campmom_med_discount"], admin_notes: line["admin_notes"], req1: req1, req1_city: req1_city, req2: req2, req2_city: req2_city, ofa_group: line["ofa_group"]})
      end
    end

    def create
      new_data = CSV.generate do |csv|
        csv << @data.headers
        Camper.sorted.each do |c|
          group2 = c.group_id_2 ? @@codes[c.group_id_2] : "X"
          csv << [c.session, c.name_used, "", c.age, c.grade, c.prev_grade, c.first, c.last, c.city.name, c.school, c.birthdate, c.tribe, c.sibling_tribe, c.tenure, c.group_id_1, group2, c.rid, c.prev_cab, c.past_camper_rating, c.balance, c.discount, c.campmom_med_discount, c.parent_notes, c.admin_notes, "", "", "#{c.req1} (#{c.req1_city})", "", "", "#{c.req2} (#{c.req2_city})", "", "", c.ofa_group]
        end
      end
      File.write("app/views/csv/#{@path}.erb", new_data)
      new_data
    end

  end



  #  Cabin_Requests_1.csv