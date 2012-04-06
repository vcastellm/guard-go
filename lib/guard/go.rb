require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'guard/go/runner'

module Guard
  class Go < ::Guard::Guard 
    attr_reader :options
    
    def initialize(watchers = [], options = {})
      super

      defaults = {
        :server => 'app.go',
        :test => false
      }
      
      @options = defaults.merge(options)

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
        UI.info "Running #{options[:server]}..."
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
  end
end
