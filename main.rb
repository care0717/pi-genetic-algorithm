require_relative './genom'
# 遺伝子情報の長さ
GENOM_LENGTH = 70
# 遺伝子集団の大きさ
MAX_GENOM_LIST = 100
# エリート遺伝子選択数
SELECT_GENOM = 20
# 個体突然変異確率
INDIVIDUAL_MUTATION = 0.15
# 遺伝子突然変異確率
GENOM_MUTATION = 0.10
# 繰り返す世代数
MAX_GENERATION = 4000

# GENOM_LENGT分のランダムな遺伝子を持つGenomを生成する
def create_genom()
  random = Random.new
  return Genom.new((1..GENOM_LENGTH).to_a.map{random.rand(0..2)})
end

# SELECT_GENOMだけ成績上位のGenom達を取り出す
def select(gas)
  gas.sort_by {|ga| -ga.evaluation }[0..SELECT_GENOM-1]
end

# エリートとその子孫の数だけ成績下位のGenomを削除し，エリート及びその子孫のリストと結合する
def next_generation_gene_create(gas, ga_elite, ga_progeny)
  next_generation_geno = gas.sort_by {|ga| -ga.evaluation }[ga_elite.size+ga_progeny.size..-1]
  next_generation_geno += ga_elite
  next_generation_geno += ga_progeny
  next_generation_geno
end

# 設定した確率に従い，genom_listの一部を変異させる
def mutation(gas)
  random = Random.new
  ga_list = []
  gas.each {|ga|
    if INDIVIDUAL_MUTATION > random.rand(0..99)/100.0
      genom_list = ga.genom_list.map { |g|
        if GENOM_MUTATION > random.rand(0..99)/100.0
          random.rand(0..2)
        else
          g
        end
      }
      ga_list.push(Genom.new(genom_list))
    else
      ga_list.push(ga)
    end
  }
  ga_list
end

# 世代ごとに結果を表示する
def print_result(gas, i)
  fits = gas.map{|ga| ga.evaluation} 
  min_ = fits.min
  max_ = fits.max
  avg_ = fits.sum / fits.size
  puts "-----第#{i}世代の結果-----"
  puts "  Min:#{min_}"
  puts "  Max:#{'%e' % max_}"
  puts "  Avg:#{'%e' % avg_}"
end

# mainの始まり
gas = (1..MAX_GENOM_LIST).to_a.map{create_genom()}
MAX_GENERATION.times {|i|
  elite_genes = select(gas)
  progeny_gene = []
  (elite_genes.size-1).times{|i|
    progeny_gene += elite_genes[i+1].crossover(elite_genes[i])
  }
  next_generation_group = next_generation_gene_create(gas, elite_genes, progeny_gene)
  next_generation_group = mutation(next_generation_group)

  print_result(gas, i)
  gas = next_generation_group
}
# 最後に結果を表示
elite = select(gas)[0]
puts "最も優れた個体は"
puts "評価: #{'%e' % elite.evaluation}"
puts "pi: #{elite.pi}"
puts "個体: #{elite.genom_list.select{|g| g != 2}}"
puts 
elite.print_operation

