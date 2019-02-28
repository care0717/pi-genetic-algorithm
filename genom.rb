class Genom 
  attr_accessor :genom_list, :evaluation, :pi
  def initialize(genom_list)   
    @genom_list = genom_list
    @evaluation, @pi = evaluate()
    @len = @genom_list.size
  end

  def operation()
    operation_list = @genom_list.select{|g| g != 2}
    puts "計#{operation_list.size}回"
    before = operation_list[0]
    count = 1
    operation_list[1..-1].each { |g|
      if before == g 
        count +=1    
      else
        if before == 1
          puts "+2を#{count}回"
        else
          puts "sqrtを#{count}回"
        end
        count = 1
        before = g
      end
    }
    if before == 1
      puts "+2を#{count}回"
    else
      puts "sqrtを#{count}回"
    end
  end

  def evaluate()
    res = 0
    @genom_list.each { |g|
      if g==1 
        res += 2
      elsif g==0
        res = Math.sqrt(res)
      end
    }
    return 1/(res-Math::PI).abs, res
  end

  def crossover(ga) 
    random = Random.new
    cross_one = random.rand(0..@len-1)
    cross_second = random.rand(cross_one..@len-1)
    if cross_second == @len-1
      progeny_one = @genom_list[0..cross_one]+ga.genom_list[cross_one+1..cross_second] 
      progeny_sec = ga.genom_list[0..cross_one]+@genom_list[cross_one+1..cross_second] 
    else
      progeny_one = @genom_list[0..cross_one]+ga.genom_list[cross_one+1..cross_second] + @genom_list[cross_second+1..-1]
      progeny_sec = ga.genom_list[0..cross_one]+@genom_list[cross_one+1..cross_second] + ga.genom_list[cross_second+1..-1]
    end
    return [Genom.new(progeny_one), Genom.new(progeny_sec)]
  end
end
