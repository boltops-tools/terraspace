describe Terraspace::Seeder do
  let(:seeder) { described_class.new(mod) }
  let(:mod) do
    mod = double(:mod).as_null_object
    allow(mod).to receive(:cache_dir).and_return("spec/fixtures/cache_dir")
    mod
  end

  context "tf files" do
    it "parse" do
      parsed = seeder.parse
      expect(parsed).to eq(
        {"variable"=>
          {"project"=>{"description"=>"Project name. IE: test-project", "type"=>"string"},
          "name"=>{"default"=>"demo-name", "type"=>"string"}}}
      )
    end
  end
end

