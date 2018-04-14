# frozen_string_literal: true

# module Findlike
module FindLike
  begin
  rescue LoadError
    puts 'Load Error'
    # Do nothing, then failing.
  end
  # This ruby class is responsible to find the file
  # int the unix system on the basis of filters/arguments
  # provided through command line interface.
  class FileFind
    # The starting path(s) for the search. The default is the current directory.
    # This can be a single path or an array of paths.
    #
    attr_accessor :path

    # Controls the behavior of how symlinks are followed. If set to false (the
    # default), then follows the file pointed to. If true, it considers the
    # symlink itself.
    #
    attr_accessor :follow

    # Limits searches to specific types of files. The possible values here are
    # those returned by the File.ftype method.
    #
    attr_accessor :ftype

    # The name pattern used to limit file searches. The patterns that are legal
    # for Dir.glob are legal here. The default is '*', i.e. everything.
    #
    attr_accessor :name

    # Skips files or directories that match the string provided as an argument.
    #
    attr_accessor :exclude_dir

    # Keeps the previous result from recursive search
    #
    attr_accessor :previous

    attr_accessor :regex

    # Action run after parsing the options.
    # @param [String] type one of the type file/link/directory.
    # @param [String] name of the file/link/directory.
    # @param [String] rname regex for file/link/directory.
    # @param [String] exclude_dir path to skip.
    # @param [Boolean] follow Controls the behavior of how symlinks are followed
    # If set to false (the
    # default), then follows the file pointed to. If true, it considers the
    # symlink itself.
    def initialize(type,
                   name,
                   rname,
                   exclude_dir,
                   follow, path)
      @ftype = type
      @follow = follow
      @exclude_dir = exclude_dir
      @regex = rname

      @path = path || Dir.pwd
      @name = name || '*'

      results = find

      if results.nil? || results.empty?
        puts "find_like : Sorry, your query didn't find"\
             "any matching now #{type}"
      end
    end

    # Recursively find file on the path based on the options provided.
    # if the match is found it yields the file
    # and prints(Like find unix command) handle
    # error gracefully including no match found.
    def find
      results = [] unless block_given?
      # paths = @path.is_a?(String) ? [@path] : @path

      begin
        exclude_dir_regex = @exclude_dir
      rescue => ex
        puts "--exclude_dir regex Skipping, #{ex.message}"
        exit
      end

      begin
        file_regex = (Regexp.new(@regex) if @regex)
      rescue => ex
        puts "--rname regex : Skipping, #{ex.message}"
        exit
      end

      recursively_find_file(exclude_dir_regex, path, results, file_regex)

      block_given? ? nil : results
    end

    def recursively_find_file(
        exclude_dir_regex,
        path,
        results,
        file_regex
    )
      Dir.foreach(path) do |file|
        next if file == '.'
        next if file == '..'

        if exclude_dir_regex
          next if exclude_dir_regex == file
        end

        file_path = File.join(path, file)

        stat_method = @follow ? :lstat : :stat
        # Skip files we cannot access, stale links, etc.
        begin
          stat_info = File.send(stat_method, file_path)
        rescue Errno::ENOENT, Errno::EACCES,
               Errno::EBADF, Errno::ELOOP, Errno::EPERM
          next
        rescue Errno::ELOOP
          stat_method = :lstat # Handle recursive symlinks
          retry if stat_method.to_s != 'lstat'
        end

        # We need to escape any brackets in the directory name.
        # glob = File.join(
        #     File.dirname(file).gsub(/([\[\]])/, '\\\\\1'),
        #     @name
        # )

        glob = File.join(File.dirname(file_path), @name)

        # Remove backslash
        if File::ALT_SEPARATOR
          file_path.tr!(File::ALT_SEPARATOR, File::SEPARATOR)
          glob.tr!(File::ALT_SEPARATOR, File::SEPARATOR)
        end

        # recursively call the recursively_find_file if, its a directory
        if stat_info.directory?
          recursively_find_file(
            exclude_dir_regex,
            file_path,
            results,
            file_regex
          )
        end

        # next unless Dir[glob].include?(file)

        if file_regex
          next unless file_regex.match?(file_path)
        end

        if @ftype
          next unless File.ftype(file_path) == @ftype
        end

        if name != '*'
          next unless Dir[glob].include?(file_path)
        end

        if block_given?
          yield file_path
        else
          puts file_path
          results << file_path
        end

        @previous = file_path unless @previous == file_path
      end

    # Error handling based on this article
    # https://www.systutorials.com/docs/linux/man/2-lstat/
    rescue Errno::EACCES, Errno::EPERM
      puts "#{path}: Permission denied"
    rescue Interrupt
      puts 'Search Interrupted by user.'
      exit
    rescue SystemExit
      puts 'Search exited by system.'
      exit
    rescue => ex
      puts "#{path}: Skipping, #{ex.message}"
    end

    def gracefully_handle_alt_separator(file, glob)
      if File::ALT_SEPARATOR
        file.tr!(File::ALT_SEPARATOR, File::SEPARATOR)
        glob.tr!(File::ALT_SEPARATOR, File::SEPARATOR)
      end
    end
  end
end
