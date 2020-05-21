class Terraspace::CLI
  class Seed < Base
    def run
      puts "Seeding tfvar files for #{@mod.name}"
      Terraspace::Builder.new(@options).run
      Terraspace::Seeder.new(@mod, @options).seed
    end
  end
end
