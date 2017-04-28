#!/usr/bin/env ruby                                                                       require 'aws-sdk'

OPTIONS = [
  {
    name: "Main Options", type: :seperator
  }, {
    name: :server,
    short: "s", long: "server SERVER",
    help: "DNS Server to register against"
  }, {
    name: "Logging Options", type: :seperator
  }, {
    name: :log_type, default: "syslog",
    short: "L", long: "logtype TYPE",
    help: "[Default: syslog] Set where to log. Your options are:  syslog, stdout, stderr and file"
  }, {
    name: :logfile,
    short: "O",  long: "logfile FILENAME",
    help: "Specify the file to log to"
  }, {
    name: :facility, default: "LOG_DAEMON",
    short: "F", long: "facility FACILITY",
    help: "[Default: LOG_DAEMON] Set the syslog facility"
  }, {

    name: "Global Options",
    type: :seperator
  },
]


def main
  @log.info("Starting up")
  puts "Here I am"
  p @options


  @log.info("Shutting down")
end

def logger(opts)
  logger = nil
  case opts[:log_type]
  when "syslog"
    require 'syslog/logger'
    logger= Syslog::Logger.new $0, Object.const_get("Syslog::#{opts[:facility]}")
  when "file", "stdout", "stderr"
    require 'logger'
    target = case opts[:log_type]
             when "file" then opts[:logfile]
             when "stdout" then STDOUT
             when "stderr" then STDERR
             end
    logger= Logger.new(target)
  end
  logger
end


def parse_arguments
  require 'optparse'
  parsed = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} --help"
    parsed[:program_name] = $0
    OPTIONS.each do |o|
      if o[:type] == :seperator
        opts.separator("")
        opts.separator(o[:name])
        next
      end
      parsed[o[:name]] = o[:default] if o[:default]
      opts.on("-#{o[:short]}","--#{o[:long]}",o[:help])  do |option|
        parsed[o[:name]] =  option
      end
    end
    opts.on_tail('-h','--help', 'show help') { puts opts; exit 0}
  end.parse!
  parsed
end

@options = parse_arguments
@log = logger(@options)
main
