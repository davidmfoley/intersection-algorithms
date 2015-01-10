#====================================================================
# Thunderdome!
#
# Runs each algorithm on a dataset that doubles in size each iteration
# Times the results of each and prints out a ranking.
#
# Eliminates algorithms that take longer than the specified limit 
# (see below)
#====================================================================

require_relative './intersection'

count = 1024 # how many items to start with - this is doubled each round
limit = 2    # (in seconds) algorithms that take longer than this are eliminated

# start with all of them
contenders = Intersection.algorithms

puts "THUNDERDOME! " + contenders.length.to_s + ' ALGORITHMS ENTER BUT ONLY ONE LEAVES VICTORIOUS!'

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
    elapsed = Benchmark.measure { contender.intersect(a, b) }.utime

    # Store in an array of arrays [[algorithm, timing]]
    results << [contender, elapsed]
    putc '.'
  end

  # best (shortest time) results first
  results.sort_by! {|x| x[1]}

  puts
  puts 'Thunderdome round with (' + evens.length.to_s + ') items'
  puts

  results.each do |result|
    # TBH this is a pretty lazy way to store these results...
    algorithm = result[0]
    elapsed_seconds = result[1]

    # print the results
    puts algorithm.to_s + ': ' + (elapsed_seconds * 1000).to_i.to_s + ' ms'

    # eliminate if too slow
    if (elapsed_seconds > limit)
      contenders.delete algorithm
      puts algorithm.to_s + ' IS ELIMINATED!'
    end
  end

  # end condition
  if (contenders.length <= 1)
    puts
    puts "THE WINNER IS " + results[0][0].to_s
  else
    puts contenders.length.to_s + ' contenders remain'
  end

  count += count
end

