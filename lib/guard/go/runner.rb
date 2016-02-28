require 'sys/proctable'
require 'childprocess'

module Guard
  class GoRunner
    MAX_WAIT_COUNT = 10

    attr_reader :options, :pid

    def initialize(options)
      @options = options
    end

    def start
      run_go_command!
    end

    def stop
      ps_go_pid.each do |pid|
        system %(kill -KILL #{pid})
      end
      sleep sleep_time while ps_go_pid.count > 0
      @proc.stop
    end

    def ps_go_pid
      Sys::ProcTable.ps.select { |pe| pe.ppid == @pid }.map(&:pid)
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
      if @options[:test]
        run_once('test')
      else
        run_once('install')
      end

      return if @options[:build_only] || @options[:test]

      @proc = ChildProcess.build "./#{@options[:go_folder]}"
      start_child_process!
    end

    def run_once(command)
      @proc = ChildProcess.build @options[:cmd], command
      @proc.environment['GOGC'] = 'off'
      @proc.io.inherit!
      @proc.cwd = Dir.pwd + "/#{@options[:go_folder]}"
      @proc.start
      @pid = @proc.pid
      @proc.wait
      if @proc.exit_code == 0
        Notifier.notify("#{command} success", title: 'Go App', image: :success)
      else
        Notifier.notify("#{command} failed", title: 'Go App', image: :failed)
      end
    end

    def start_child_process!
      @proc.io.inherit!
      @proc.cwd = Dir.pwd + "/#{@options[:go_folder]}"
      @proc.start
      @pid = @proc.pid
    end
  end
end
