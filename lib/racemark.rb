require "racemark/version"
require 'racemark/report'
require 'stringio'
require 'benchmark'
require 'benchmark/ips'
require 'benchmark_suite'
require 'objspace'

module Racemark
  class << self
    attr_accessor :global_stdout, :reports

    def race
      @reports=[]
      yield
      compare
    end

    def measure(name_algorithm="your_algorithm")
      stdout(false)
      GC.disable

      report = Report.new(name_algorithm)
      report.bm = Benchmark.measure(name_algorithm) do |bm|
        yield
      end
      GC.start
      report.mem = ObjectSpace.memsize_of_all(RubyVM::InstructionSequence)

      Benchmark::Suite.create
      ips = Benchmark.ips do |bm|
        bm.report(name_algorithm) do
          yield
        end
      end
      report.ips = ips.first

      stdout(true)
      @reports << report if @reports
      report
    end

    def compare
      if @reports.empty?
        raise Exception.new("NoHorseException: a race without horses is not a race")
      end

      if @reports.count == 1
        raise Exception.new("OnlyOneHorseException: a race requires at least two horses")
      end

      @horses = []
      @reports.each do |report|
        @horses = Horse.new report
        report.print
      end

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
