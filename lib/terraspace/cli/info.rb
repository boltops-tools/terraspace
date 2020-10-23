class Terraspace::CLI
  class Info < Base
    extend Memoist

    def run
      if @options[:path]
        show_path
      else
        show_all
      end
    end

    def show_all
      presenter = CliFormat::Presenter.new(@options)
      presenter.header = %w[Name Value]
      info.each do |k,v|
        presenter.rows << [k, v]
      end
      presenter.show
    end

    def show_path
      puts info[:cache_dir]
    end

    def info
      @mod.to_info
    end
  end
end
