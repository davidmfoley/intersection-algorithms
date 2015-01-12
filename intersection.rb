#====================================================================
# A variety of algorithms for the list intersection proble, with a few
# simple tests and some benchmarks
#
# The problem:
#
# Given two arrays, return a new array containing only the items that are present in both arrays
# ([1,2,3], [2,3,4]) -> ([2,3])
#
# Some of these handle duplicate items in the arrays and some do not
# for example:
# ([1,1,2,2,3], [1,2,2,3,3]) -> (1,2,2,3)
# (Note that there are two 2s in _each_ array so there are two 2s in the output)
#
# (see comments on each algorithm)
#
#
# Note 1: some of the implementations use sort!
#
# These would be slower if we did the sort in ruby instead of using the
# built-in sort in ruby (that is written in C), so it's not really a
# "fair" comparison of these algorithms in the classical sense.
#
# ruby is "slower" than most other programming languages, so generally
# it's built-in functions should perform better than the equivalent
# logic implemented in ruby
#====================================================================
require "benchmark"
require "set"

module Intersection
  # the built-in way
  #
  # The ruby & operator returns the intersection of two arrays
  # Doesn't handle duplicates
  #
  # Internally, uses a method similar (but not identical) to the simple hash method below
  #
  class Ampersand
    def self.intersect(a, b)
      a & b
    end
  end

  # The loop-inside-a-loop way
  #
  # Slowest of all of the implementations
  #
  class BruteForce
    def self.intersect(a, b)
      result = []
      # Loop through 1st array
      a.each do |c|
        # for each element, loop through 2nd array until we find a match or hit the end
        b.each do |d|
          if (c == d)
            result << c
            break
          end
        end
      end
      result
    end
  end

  # This is basically the same as the brute force method above,
  # but in a more "rubyish" fashion
  #
  # #select returns all of the elements for which the block returns true
  # include? looks for the item in the second array
  #
  # Doesn't handle duplicates
  #
  class Rubyish
    def self.intersect(a, b)
      a.select {|x| b.include? x}
    end
  end

  # the above algorithms
  # Sort then walk both arrays, comparing each value as we go
  class SortedWalk
    def self.intersect(a, b)
      # Sort both arrays
      a.sort!
      b.sort!

      # array indexes into a and b, respectively
      a_index = 0
      b_index = 0

      result = []

      # Look at the first element in each list
      # If the same, put on our results stack and move forward in both lists
      # Otherwise, move forward only in the list with the smaller value
      # Repeat until we reach the end of either list
      while (a_index < a.length && b_index < b.length) do
        # Note: could also use the "spaceship" operator (<=>) here
        if a[a_index] == b[b_index]
          result << a[a_index]
          a_index += 1
          b_index += 1
        elsif  a[a_index] < b[b_index]
          a_index += 1
        else
          b_index += 1
        end
      end

      result
    end
  end

  # Similar to the sorted walk, but instead of incrementing indexes,
  # remove items from the input arrays using #shift as we "walk"
  class Shifting
    def self.intersect(a, b)
      # Sort both arrays
      a.sort!
      b.sort!

      # Shift the first item from each array
      # the current values we are comparing at any time
      current_a = a.shift
      current_b = b.shift

      result = []

      # Compare the items
      # If the same, put on our results stack and shift new items from both lists
      # Otherwise, shift the next item from the list with the smaller value
      # Repeat until we reach the end of either list (nil in either shifted item)
      while (current_a && current_b) do
        if current_a == current_b
          result << current_a
          current_a = a.shift
          current_b = b.shift
        elsif current_a < current_b
          current_a = a.shift
        else
          current_b = b.shift
        end
      end

      result
    end
  end

  # Similar to the shifting approach, but using pop (end of list) instead
  class Popping
    def self.intersect(a, b)
      #
      # Sort both arrays
      a.sort!
      b.sort!


      # Pop the first item from each
      current_a = a.pop
      current_b = b.pop

      result = []

      # Compare the items just popped from the list
      # If the same, put on our results stack and pop new items from both lists
      # Otherwise, pop only the list with the smaller value
      # Repeat until we reach the end of either list (nil in either popped item)
      while (current_a && current_b) do
        if current_a == current_b
          result << current_a
          current_a = a.pop
          current_b = b.pop
        elsif  current_a > current_b
          current_a = a.pop
        else
          current_b = b.pop
        end
      end

      result
    end
  end

  # Does not handle duplicates
  # Think of a Set as a Hash where the only values are true or false
  class Sets
    def self.intersect(a, b)
      set_a = Set.new

      # Loop through the first list
      #   for each item, increment the hash value with that key by one
      a.each do |x|
        set_a << x
      end

      result = []

      # Loop through the second list
      #   check the Set and put on our results stack
      b.each do |y|
        if set_a.include? y
          result << y
        end
      end

      result
    end
  end

  class CountingHash
    def self.intersect(a, b)
      # Create a hash with default value of 0
      counts = Hash.new(0)

      # Loop through the first list
      #   for each item, increment the hash value with that key by one
      a.each do |x|
        counts[x] = counts[x] + 1
      end

      result = []

      # Loop through the second list
      #   check the hash and if > 0, decrement and put on our results stack
      b.each do |y|
        if counts[y] > 0
          counts[y] = counts[y] - 1
          result << y
        end
      end

      result
    end
  end

  # put items in the first array into the keys of a hash with true as a value then
  # loop through all items in the second array and ask the hash if it has them
  class SimpleHash
    def self.intersect(a, b)
      # Create a hash
      items = {}

      # Loop through the first list and set the hash value to true
      a.each do |x|
        items[x] = true
      end

      result = []

      # Loop through the second list
      #   check the hash
      b.each do |y|
        if items.delete(y)
          result << y
        end
      end

      result
    end
  end

  # this list of all of the algorithms is used by the thunderdome
  # and the tests to iterate through all of them
  def self.algorithms
    [
      Ampersand,
      Rubyish,
      SortedWalk,
      CountingHash,
      SimpleHash,
      Sets,
      Shifting,
      Popping,
      BruteForce
    ]
  end

end
