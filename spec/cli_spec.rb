describe Terraspace::CLI do
  before(:all) do
    @args = "--from Tung"
  end

  describe "terraspace" do
    it "up" do
      out = execute("exe/terraspace up vpc")
      puts out
      # expect(out).to include("from: Tung\nHello world")
    end
  end
end
