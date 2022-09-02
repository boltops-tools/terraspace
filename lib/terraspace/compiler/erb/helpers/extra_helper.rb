module Terraspace::Compiler::Erb::Helpers
  module ExtraHelper
    def append_extra(value)
      [value, extra].compact.join('-')
    end
    alias_method :with_extra, :append_extra

    def extra
      extra = ENV['TS_EXTRA']
      extra&.strip&.empty? ? nil : extra # if blank string then also return nil
    end
  end
end
