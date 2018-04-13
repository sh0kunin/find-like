module FindLike
  class FileFindRecurs
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

    attr_accessor :exclude_dir_regex

    attr_accessor :file_regex
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
      @follow = !follow
      @exclude_dir = exclude_dir
      @regex = rname

      @path = path || Dir.pwd
      @name = name || '*'

      @exclude_dir_regex = (Regexp.new(@exclude_dir) if @exclude_dir)
      @file_regex = (Regexp.new(@regex) if @regex)

      results = find



      if results.nil? || results.empty?
        puts "find_like : Sorry, your query didn't find "\
             "any matching now #{type}"
      end
    end


    def find
      results = [] unless block_given?
      paths = @path.is_a?(String) ? [@path] : @path # Ruby 1.9.x compatibility


      paths.each {|path|
        begin
          Dir.foreach(path) {|file|
            next if file == '.'
            next if file == '..'

            if file_regex
              next unless file_regex.match?(file)
            end

            if exclude_dir_regex
              next if exclude_dir_regex.match?(file)
            end

            file = File.join(path, file)

            stat_method = @follow ? :stat : :lstat
            # Skip files we cannot access, stale links, etc.
            begin
              stat_info = File.send(stat_method, file)
            rescue Errno::ENOENT, Errno::EACCES,
                Errno::EBADF, Errno::ELOOP, Errno::EPERM
              next
            rescue Errno::ELOOP
              stat_method = :lstat # Handle recursive symlinks
              retry if stat_method.to_s != 'lstat'
            end

            # We need to escape any brackets in the directory name.
            glob = File.join(File.dirname(file).gsub(/([\[\]])/, '\\\\\1'), @name)

            # Dir[] doesn't like backslashes
            if File::ALT_SEPARATOR
              file.tr!(File::ALT_SEPARATOR, File::SEPARATOR)
              glob.tr!(File::ALT_SEPARATOR, File::SEPARATOR)
            end


            # Add directories back onto the list of paths to search unless
            # they've already been added
            #
            if stat_info.directory?
              paths << file unless paths.include?(file)
            end

            next unless Dir[glob].include?(file)


            if @ftype
              next unless File.ftype(file) == @ftype
            end

            if block_given?
              yield file
            else
              puts file
              results << file
            end

            @previous = file unless @previous == file
          }
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
          # next # Skip other errors
        end
      }

      block_given? ? nil : results
    end
  end
end