require 'fileutils'

module Guard
  class GoRunner
    MAX_WAIT_COUNT = 10

    attr_reader :options, :pid

    def initialize(file, options)
      @file = file
      @options = options
    end

    def start
      run_go_command!
    end

    def stop
      ps_go_pid.each do |pid|
        system %{kill -KILL #{pid}}
      end
      while ps_go_pid.count > 0
        wait sleep_time
      end
    end

    def restart
      stop
      start
    end

    def build_go_command
      %{cd #{Dir.pwd} && go run #{@file}}
    end

    def ps_go_pid
      `ps aux | awk '/a.out/&&!/awk/{print $2;}'`.split("\n").map { |pid| pid.to_i }
    end

    def sleep_time
      options[:timeout].to_f / MAX_WAIT_COUNT.to_f
    end

    private
    def run_go_command!
      @pid = fork do
        exec build_go_command
      end
      @pid
    end
  end
end
