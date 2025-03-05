# frozen_string_literal: true

class LoggerWithStdout < Logger
  def initialize(*)
    super

    def @logdev.write(msg)
      super

      $stdout.puts(msg)
    end
  end
end
