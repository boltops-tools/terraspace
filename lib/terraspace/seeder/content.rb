class Terraspace::Seeder
  class Content
    extend Memoist

    def initialize(parsed)
      @parsed = parsed
    end

    def build
      lines = []
      required_vars.each do |name, meta|
        lines << "# Required variables:"
        lines << build_line(name, meta)
      end
      optional_vars.each do |name, meta|
        lines << "\n# Optional variables:"
        lines << build_line(name, meta)
      end
      lines.join("\n") + "\n"
    end

    def build_line(name, meta)
      type = meta["type"]
      value = desc_example(meta["description"]) || type || "any"

      value = if type&.include?('(') # complex type
                "[...] # #{type}"
              else
                %Q|"#{value}"| # add quotes
              end

      name = "%-#{rpad}s" % name # rpad to align = signs
      "#{name} = #{value}"
    end

    def rpad
      all_vars.keys.map(&:size).max
    end
    memoize :rpad

    def desc_example(desc)
      return unless desc
      md = desc.match(/([eE]xample|IE): (.*)/)
      return unless md
      md[2]
    end

    def required_vars
      select_vars(@parsed) { |meta|  meta["default"].nil? }
    end

    def optional_vars
      select_vars(@parsed) { |meta| !meta["default"].nil? }
    end

    def all_vars
      select_vars(@parsed)
    end

    def select_vars(parsed)
      vars = parsed.dig("variable")
      return [] unless vars
      vars.select do |name,meta|
        block_given? ? yield(meta) : true
      end
    end

  end
end
