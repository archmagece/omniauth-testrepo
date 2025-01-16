# frozen_string_literal: true

require 'logger'

module OAuth2
  class SbLogger
    require 'singleton'

    include Singleton

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::DEBUG
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} #{severity} #{progname}: #{msg}\n"
      end
    end

    def log(severity, message, progname = nil)
      caller_location = caller_locations(2,1)[0]
      class_name = caller_location.label.split('.').first
      method_name = caller_location.label
      progname ||= "#{caller_location.path}:#{caller_location.lineno}"
      @logger.add(severity, message, "#{class_name}##{method_name}")
    end

    # 편의 메서드
    [:debug, :info, :warn, :error, :fatal].each do |level|
      define_method(level) do |message|
        log(Logger.const_get(level.to_s.upcase), message)
      end
    end
  end
end
