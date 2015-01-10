#====================================================================
# Benchmarks for the various implementations in the degenerate case
# of two arrays that don't intersect at all.
#====================================================================

# the number of items to use for each pass 
# YMMV - On my computer 8,000 items takes ~3.5 seconds for the slowest algorithm

require_relative './intersection'

contenders = Intersection.algorithms

puts "THUNDERDOME! " + contenders.length.to_s + ' ALGORITHMS ENTER BUT ONLY ONE LEAVES VICTORIOUS!'

count = 1000
limit = 2 #(seconds) algorithms that take longer than this are eliminated

# for each count, run all of the algorithms and rank them by time
while contenders.length > 0
  # (count) odd and even numbers
  odds = (1..count*2).step(2).to_a.shuffle
  evens = (2..count*2).step(2).to_a.shuffle

  results = [] 

  # run for each implementation
  contenders.each do |contender|

    # you could try with other sets of numbers - all intersecting, for example (set a and b to the same thing)
    # or partially intersecting
    # or random numbers...
    # or non-numeric value...

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
    algorithm = result[0]
    elapsed_seconds = result[1]
    puts algorithm.to_s + ': ' + (elapsed_seconds * 1000).to_i.to_s + ' ms'

    if (elapsed_seconds > limit)
      contenders.delete algorithm
      puts algorithm.to_s + ' IS ELIMINATED!'
    end

  end

  if (contenders.length == 0)
    puts
    puts "THE WINNER IS " + results[0][0].to_s
  else
    puts contenders.length.to_s + ' contenders remain'
  end


  count += count
end

