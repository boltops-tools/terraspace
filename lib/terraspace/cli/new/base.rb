class Terraspace::CLI::New
  class Base < Sequence
    argument :name

    def add_base_files
      args = ["project"]
      args.unshift("edge") if ENV['TS_EDGE']
      set_base_source(*args)
      directory ".", "#{name}"
    end
  end
end
