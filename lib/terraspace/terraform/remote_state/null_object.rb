module Terraspace::Terraform::RemoteState
  class NullObject
    def to_a
      []
    end

    def to_ary
      []
    end

    def to_s
      "(unresolved)" # always returned as part of first unresolved processing pass
    end
    alias_method :to_str, :to_s # ERB requires to_str

    def to_f
      0.0
    end

    def to_i
      0
    end

    def nil?
      true
    end

    def inspect
      format("#<%s:0x%x>", self.class, object_id)
    end

    def method_missing(*_args, &_block)
      self
    end

    def respond_to?(_message, _include_private = false)
      true
    end
  end
end
