module Racemark
  class Report
    attr_accessor :bm, :time, :ips, :mem

    def initialize(name)
      @name = name
    end

    def print
      p "Racemark: #{@name}"
      p "----------#{@name.gsub(/./,'-')}"
      p "Time: #{bm.real}"
      p "Iteration per second: #{ips.body}"
      p "Memory allocated: #{mem}"
    end

  end
end


