# frozen_string_literal: true

module FindLike
  # Util class for any utilities in FindLike
  class Util
    class << self
      # Maps `arguments` in parallel and performs a block on each.
      # @param arguments [Array<Argument>] A list of arguments
      # @yieldparam argument [Argument] Argument from `arguments` passed
      # @return [Array] A list of results made after performing a block on each
      #   argument.
      def parallelize(arguments)
        threads = arguments.map do |argument|
          thread = Thread.new do
            begin
              Thread.current[:result] = yield(argument)
            rescue => ex
              Log.fatal("#{ex}\n#{ex.backtrace.pretty_inspect}")
              Thread.main.raise(ex)
            end
          end
          thread.abort_on_exception = true
          thread
        end
        threads.each.map do |thread|
          thread.join
          thread[:result]
        end
      end
    end
  end
end
