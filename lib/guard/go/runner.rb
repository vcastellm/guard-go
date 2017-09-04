require 'sys/proctable'
require 'childprocess'

module Guard
  class GoRunner
    MAX_WAIT_COUNT = 10

    attr_reader :options, :pid

    def initialize(options)
      @options = options

      unless @options[:test] || @options[:build_only] || File.exists?(@options[:server])
        raise "Server file not found. Check your :server option in your Guardfile."
      end
    end

    def start
      run_go_command!
    end

    def stop
      ps_go_pid.each do |pid|
        system %{kill -KILL #{pid}}
      end
      while ps_go_pid.count > 0
        sleep sleep_time
      end
      @proc.stop
    end

    def ps_go_pid
      Sys::ProcTable.ps.select{ |pe| pe.ppid == @pid }.map { |pe| pe.pid }
    end

    def restart
      stop
      start
    end

    def sleep_time
      options[:timeout].to_f / MAX_WAIT_COUNT.to_f
    end

    private

    def run_go_command!
      child_process_args = [@options[:cmd]]
      child_process_args << "build" << @options[:server]
      child_process_args[1..-1] = "test" if @options[:test]

      @proc = ChildProcess.build *child_process_args
      start_child_process!

      return if @options[:build_only] || @options[:test]

      @proc.wait
      server_cmd = "./" + @options[:server].sub('.go', '')
      args = [server_cmd, options[:args]].flatten
      @proc = ChildProcess.build  *args
      start_child_process!
    end

    def start_child_process!
      @proc.io.inherit!
      @proc.cwd = Dir.pwd
      @proc.start
      @pid = @proc.pid
    end
  end
end
