# Below are some tests for the algorithms
# They use the minispec framework
#
# There is a little bit of ruby magic to run them
# for each different class from above
#
# Note that this is pretty simple set of tests.
# Try adding your own...
#====================================================================
require "minitest"
require "minitest/autorun"
require_relative './intersection'

# run tests for each implementation
Intersection.algorithms.each do |algorithm|
  describe algorithm do
    describe "intersection" do
      it "handles non-intersecting sets" do
        algorithm.intersect([1,2,3], [4,5,6]).sort.must_equal([])
      end

      it "handles equivalent sets" do
        algorithm.intersect([1,2,3], [1,2,3]).sort.must_equal([1,2,3])
      end

      it "handles intersecting sets" do
        algorithm.intersect([1,2,3], [1,2,3]).sort.must_equal([1,2,3])
      end

      # this fails for the algorithms that don't handle duplicates
      # as noted in the comments above
      it "handles duplicates (expected failure for some algorithms)" do
        algorithm.intersect([1,2,2,3,3,5], [1,2,2,3,4]).sort.must_equal([1,2,2,3])
      end

      it "cares not for initial sort order" do
        algorithm.intersect([10,7,2,3,8,5], [3,2,9,4,1, 7]).sort.must_equal([2,3,7])
      end
    end
  end
end
