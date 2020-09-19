class Terraspace::CLI
  class Info < Base
    extend Memoist

    def run
      presenter = CliFormat::Presenter.new(@options)
      presenter.header = %w[Name Value]
      info.each do |k,v|
        presenter.rows << [k, v]
      end
      presenter.show
    end

    def info
      @mod.to_info
    end
  end
end
