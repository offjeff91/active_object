module ActiveObject
  class Handler
    HANDLERS = [
      Handlers::HasHandler,
      Handlers::FirstLastHandler,
      Handlers::AverageHandler,
      Handlers::MinMaxHandler,
      Handlers::AtHandler,
      Handlers::ArrayHandler
    ].freeze

    def self.handle!(method, *args, caller, &default)
      handler = HANDLERS.find { |handler| handler.handles?(method) }
      if handler.nil?
        default.call
      else
        handler.handle!(method, *args, caller, &default)
      end
    end
  end
end 