require 'guard'
require 'guard/plugin'
require 'guard/watcher'
require 'guard/go/runner'

module Guard
  class Go < Plugin
    attr_reader :options

    def initialize(options = {})
      super

      defaults = {
        server: 'app.go',
        test: false,
        args: [],
        cmd: 'go'
      }

      @options = defaults.merge(options)
      @options[:args] = wrap_args(@options[:args])
      @options[:args_to_s] = @options[:args].join(" ")

      @runner = ::Guard::GoRunner.new(@options)
    end

    def start
      start_info
      run_info @runner.start
    end

    def run_on_change(paths)
      start_info
      run_info @runner.restart
    end

    def stop
      @runner.stop
      UI.info "Stopping Go..."
      Notifier.notify("Until next time...", :title => "Go shutting down.", :image => :pending)
    end

    private
    def start_info
      if @options[:test]
        UI.info "Running go test..."
      else
        UI.info "Running #{options[:server] } #{options[:args_to_s]} ..."
      end
    end

    def run_info(pid)
      return if @options[:test]
      if pid
        UI.info "Started Go app, pid #{pid}"
      else
        UI.info "Go command failed, check your log files."
      end
    end

    def wrap_args(obj)
      if obj.nil?
        []
      elif obj.respond_to?(:to_ary)
        obj.to_ary || [obj]
      else
        [obj]
      end
    end
  end
end
