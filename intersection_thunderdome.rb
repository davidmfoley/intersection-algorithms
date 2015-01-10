#====================================================================
# Thunderdome!
#
# Runs each algorithm on a dataset that doubles in size each iteration
# Times the results of each and prints out a ranking.
#
# Eliminates algorithms that take longer than the specified limit
#
# Note that this is not extremely scientific
#
# (see below)
#====================================================================

require_relative './intersection'

count = 1024 # how many items to start with - this is doubled each round
limit = 2    # (in seconds) algorithms that take longer than this are eliminated

# start with all of them
contenders = Intersection.algorithms

class Result < Struct.new(:algorithm, :elapsed_seconds)
  def to_s
    self.algorithm.name + ': ' + (self.elapsed_seconds * 1000).to_i.to_s + ' ms'
  end
end

# for each count, run all of the algorithms and rank them by time
while contenders.length > 1
  # (count) odd and even numbers
  odds = (1..count*2).step(2).to_a.shuffle
  evens = (2..count*2).step(2).to_a.shuffle


  results = []

  # run for each implementation
  contenders.each do |contender|

    # you could try with other sets of numbers - all intersecting, for example
    # or partially intersecting
    # or random numbers...
    # or non-numeric values...
    # or symbols

    # We use dup here so that each one is its own copy that is not affected by shift/pop/sort! etc.
    a = odds.dup
    b = evens.dup

    # time the intersect operation in "real" time
    elapsed = Benchmark.measure { contender.intersect(a, b) }.real

    # Store in an array of arrays [[algorithm, timing]]
    results << Result.new(contender, elapsed)
    putc '.'
  end

  # best (shortest time) results first
  results.sort_by! {|x| x[1]}

  puts
  puts 'Thunderdome round with (' + evens.length.to_s + ') items'
  puts



  results.each do |result|
    # print the results
    puts result.to_s
  end

  results.each do |result|
    # eliminate if too slow
    if (result.elapsed_seconds > limit)
      contenders.delete result.algorithm
      puts result.algorithm.to_s + ' eliminated'
    end
  end

  # end condition
  if (contenders.length <= 1)
    puts
  else
    puts contenders.length.to_s + ' contenders remain'
  end

  count += count
end

