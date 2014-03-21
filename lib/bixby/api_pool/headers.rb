
module Bixby
  class APIPool
    class Headers < Hash

      attr_reader :status, :status_line

      def initialize(raw)
        lines = raw.split(/[\r\n]+/)
        @status_line = lines.shift
        @status_line =~ %r{^HTTP/[\d]+\.[\d]+ (\d+) (.*)$}
        @status = $1.to_i
        lines.each do |line|
          key, value = line.split(':', 2).map(&:strip)

          if self.include? key then
            # array of values
            self[key] = [self[key]] unless self[key].is_a? Array
            self[key].push(value)
          else
            self[key] = value
          end
        end
      end

    end
  end
end
