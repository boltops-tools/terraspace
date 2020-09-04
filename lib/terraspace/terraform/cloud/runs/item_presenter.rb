class Terraspace::Terraform::Cloud::Runs
  class ItemPresenter
    attr_reader :id
    def initialize(raw)
      @raw = raw # raw item
      @id = raw['id']
      @attrs = raw['attributes']
    end

    def method_missing(name, *args, &block)
      attrs = @attrs.transform_keys { |k| k.gsub('-','_').to_sym }
      if attrs.key?(name)
        attrs[name]
      else
        super
      end
    end

    def message
      max = 25
      message = @attrs['message']
      if message.size >= max
        message[0..max] + "..."
      else
        message
      end
    end

    def created_at
      pretty_time(@attrs['created-at'])
    end

    def pretty_time(text)
      text.sub(/\..*/,'')
    end
  end
end