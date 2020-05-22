describe Terraspace::CLI do
  before(:all) do
    @args = "--from Tung"
  end

  describe "terraspace" do
    it "up" do
      ts_root = "spec/fixtures/projects/hcl/aws"
      out = execute("TS_ROOT=#{ts_root} exe/terraspace up core")
      puts out
    end
  end
end
