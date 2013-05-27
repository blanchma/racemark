require 'minitest/autorun'
require 'racemark'
require 'debugger'

class RacemarkTest < MiniTest::Unit::TestCase

  def test_measure
    measure = Racemark.measure do
      fast_fib(21)
    end
    refute_nil measure.mem
    refute_nil measure.bm
    refute_nil measure.ips
  end

  def fast_fib(n)
    return n if (0..1).include? n
    fast_fib(n-1) + fast_fib(n-2) if n > 1
  end

  def slow_fib(n)
    curr = 0
    succ = 1

    n.times do |i|
      curr, succ = succ, curr + succ
    end

    return curr
  end
end
