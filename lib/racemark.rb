require "racemark/version"
require 'racemark/report'
require 'stringio'
require 'benchmark'
require 'benchmark/ips'
require 'benchmark_suite'
require 'objspace'

module Racemark
  class << self
    attr_accessor :global_stdout

    def measure(name_algorithm="your_algorithm")
      stdout(false)
      GC.disable

      report = Report.new(name_algorithm)
      report.bm = Benchmark.measure(name_algorithm) do |bm|
        yield
      end

      Benchmark::Suite.create
      ips = Benchmark.ips do |bm|
        bm.report(name_algorithm) do
          yield
        end
      end
      report.ips = ips.first
      GC.start
      report.mem = ObjectSpace.memsize_of_all(RubyVM::InstructionSequence)

      stdout(true)
      report.print
    end

    def stdout(state)
      if state
         $stdout = self.global_stdout
      else
         self.global_stdout = $stdout
         $stdout = StringIO.new
      end
    end
  end

end
