#!/usr/bin/env ruby 

# == Synopsis 
#   This is a sample description of the application.
#   Blah blah blah.
#
# == Examples
#   This command does blah blah blah.
#     ruby_cl_skeleton foo.txt
#
#   Other examples:
#     ruby_cl_skeleton -q bar.doc
#     ruby_cl_skeleton --verbose foo.html
#
# == Usage 
#   ruby_cl_skeleton [options] source_file
#
#   For help use: ruby_cl_skeleton -h
#
# == Options
#   -h, --help          Displays help message
#   -v, --verbose       Verbose output
#   -d, --debug	Debugging output (avoid making any changes at all)
#   -f FILE, --file FILE	Use FILE for all messages
#
# == Author
#   YourName
#
# == Copyright
#   Copyright (c) 2011 Brian Gallew. Licensed under the MIT License:
#   http://www.opensource.org/licenses/mit-license.php


# TO DO - replace all ruby_cl_skeleton with your app name
# TO DO - update Synopsis, Examples, etc
# TO DO - change license if necessary



require 'optparse' 
require 'rdoc/usage'
require 'ostruct'
require 'date'
require 'logger'
require 'fileutils'

APPNAME = $0.split('/')[-1]

class App
  VERSION = '0.0.1'
  
  attr_reader :options

  def initialize(arguments, stdin)
    @arguments = arguments
    @stdin = stdin
    
    # Set defaults
    @options = OpenStruct.new
    @options.verbose = false
    @options.debug = false
    @options.logfile = false
    # TO DO - add additional defaults
  end

  # Parse options, check arguments, then process the command
  def run
    if parsed_options? 
      if arguments_valid? 
        @log.debug('Starting')
        output_options
        process_arguments            
        process_command
        @log.debug 'Finished'
      else
        @log.fatal("Invalid arguments")
      end
    else
      @log.fatal("invalid arguments: #{@arguments}")
      output_usage
    end
  end
  
  # If called, this should ensure only a single instance of the program is running
  def mutex
    tempfile = "/tmp/#{APPNAME}.pid"
    begin
      filehandle = File.open(tempfile,File::CREAT|File::EXCL|File::TRUNC|File::WRONLY) {|io| io.puts $$}
      run
      File.unlink()
    rescue Errno::EEXIST
      pid = open(tempfile).read().to_i
      # Check to see if the process is actually running
      retval = Process.kill(0, pid) rescue false
      if not retval
        FileUtils.rm(tempfile)
        retry
      else
        exit(0)
      end
    rescue Exception => e
      puts "Unhandled error: #{e}"
      exit(-1)
    end
  end

  protected
  
  # Performs post-parse processing on options
  def process_options
    if @options.filename
      @log = Logger.new(@options.filename)
    else
      @log = Logger.new(STDOUT)
    end
    @log.level = Logger::WARN
    @log.level = Logger::INFO if @options.verbose
    @log.level = Logger::DEBUG if @options.debug
    @log.datetime_format="%Y:%m:%d:%H:%M:%S"
    # TO DO - addition post processing on options
  end
  

  # True if required arguments were provided
  def arguments_valid?
    # TO DO - implement your real logic here
    true if @arguments.length == 1 
  end
  
  # Setup the arguments
  def process_arguments
    # TO DO - place in local vars, etc
  end
  
  def output_help
    RDoc::usage() #exits app
  end
  
  def output_usage
    RDoc::usage('usage') # gets usage from comments above
  end
  
  def output_options
    @log.debug("Options:")
    @options.marshal_dump.each do |name, val|        
      @log.debug("\t#{name} = #{val}")
    end
  end
  
  def process_command
    # TO DO - do whatever this app does
    
    #process_standard_input # [Optional]
  end

  def process_standard_input
    input = @stdin.read      
    # TO DO - process input
    
    # [Optional]
    # @stdin.each do |line| 
    #  # TO DO - process each line
    #end
  end
end


# TO DO - Add your Modules, Classes, etc


# This allows the script to be imported for testing, while still
# working as a script.
if __FILE__ == $0
  # Create and run the application
  app = App.new(ARGV, STDIN)
  app.run
  # app.mutex   # Run, but only allow a single instance of the script
end
