# frozen_string_literal: true

require 'find_like/version'
require 'claide'
require 'claide/ansi'

module FindLike
  # FindLike console command class.
  # Use
  #   find_like help
  # for more info.
  class Command < CLAide::Command
    # The directory tree specified by path will be excluded from the list of directory trees searched by this tool.
    attr_reader :exclude_dir

    # Cause the file information and file type returned for each symbolic link to be those of the link itself.
    # This should be the default behaviour.
    attr_reader :p

    # Cause the file information and file type returned for each symbolic link to be those of the file referenced
    # by the link, not the link itself.
    # If the reference file does not exist, the file information and type will be for the link itself.
    attr_reader :l

    attr_reader :path

    attr_reader :type

    # True if the last component of the pathname being examined matches  pattern .
    attr_reader :name

    # Like  -name , but the  pattern  is evaluated as a regular expression.
    attr_reader :rname

    self.command = 'find_like [--P | --L] [--exclude-dir=path] --path=path [expression]'
    self.version = FindLike::VERSION
    self.summary = 'find like helps you to search files, links or directories in your system based on the below rules'

    # parse options provide through command line for file_like command
    def self.options
      [
        ['--P', 'Cause the file information and file type returned for each symbolic link to be those of the link itself. This should be the default behaviour.'],

        ['--L', 'Cause the file information and file type returned for each symbolic link to be those of the file referenced by the link, not the link itself. If the reference file does not exist, the file information and type will be for the link itself.'],

        ['--exclude-dir=path', 'The directory tree specified by path will be excluded from the list of directory trees searched by this tool.'],

        ['--path', 'Mandatory - Path to start search in your directories.'.ansi.green],

        ['--type', 'True if the file is of the specified type. Possible file types are as follows:
                      d :directory
                      f :regularfile
                      l :symboliclink'],
        ['--name',
         'True if the last component of the pathname being examined matches  pattern .'],

        ['--rname',
         'Like  -name , but the  pattern  is evaluated as a regular expression.']

      ]
    end

    # Initialize the option passed through command line
    def initialize(argv)
      @p = argv && argv.flag?('P') | false
      @l = argv && argv.flag?('L') | false
      @exclude_dir = argv.option('exclude-dir')
      @path = argv.option('path')
      @type = argv.option('type')
      @name = argv.option('name')
      @rname = argv.option('rname')
      # validate_options
      super
    end

    # Validate if the options parsed are valid.
    # Kills the script with appropriate reasons, if not.
    def validate_options
      # validate_name
    end

    def run
      FindLike::FileFind.new(type, name, rname, exclude_dir, l, path)
    end

    def validate!
      super
      vaildate_path
      validate_type
    end

    private

    def vaildate_path
      if path.nil?
        help! 'A path is required. For eg --path=. for current directory'
      end
    end

    def validate_type
      case type
      when nil
        @type = nil
      when 'f'
        @type = 'file'
      when 'd'
        @type = 'directory'
      when 'l'
        @type = 'link'
      else
        help! 'Invalid type! Available types are : f(file), l(link) or d(directory)'
        exit
      end
    end
  end
end
