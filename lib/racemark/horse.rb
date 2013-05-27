module Racemark
  def Horse
    attr_accessor :name, :points

    def initialize(report)
      @report
      @name = report.name
    end

    def calculate
      return @points if @points
      @points=0
      @points+=1 if @report.time
      @points+=1 if @report.ips
      @points+=1 if @report.mem
      @points
    end

  end
end
