describe Terraspace::All::Summary do
  let(:summary) do
    summary = described_class.new(data)
    allow(summary).to receive(:logger).and_return(logger)
    summary
  end
  # To capture logger output for testing
  let(:logger) do
    @io = StringIO.new
    Logger.new(@io)
  end
  let(:data) do
    {
      command: command,
      log_path: log_path,
      terraspace_command: "fake-terrraspace-commands",
    }
  end

  context "terraspace up success" do
    let(:command) { "up" }
    let(:log_path) { "spec/fixtures/summary/up/success.log" }
    it "run" do
      summary.run
      expect(@io.string).to include "Resources: 2 added, 0 changed, 0 destroyed"
    end
  end

  context "terraspace up error" do
    let(:command) { "up" }
    let(:log_path) { "spec/fixtures/summary/up/error.log" }
    it "run" do
      summary.run
      expect(@io.string).to include "Error"
      expect(@io.string).to include "Unsupported attribute"
    end
  end
  context "terraspace down" do
    let(:command) { "down" }
    let(:log_path) { "spec/fixtures/summary/down.log" }
    it "run" do
      summary.run
      expect(@io.string).to include "Destroy complete! Resources: 2 destroyed"
    end
  end

  context "terraspace plan error" do
    let(:command) { "plan" }
    let(:log_path) { "spec/fixtures/summary/plan/error.log" }
    it "run" do
      summary.run
      expect(@io.string).to include "Error"
      expect(@io.string).to include "Unbalanced parentheses"
    end
  end

  context "terraspace plan success" do
    let(:command) { "plan" }
    let(:log_path) { "spec/fixtures/summary/plan/success.log" }
    it "run" do
      summary.run
      expect(@io.string).to include "No changes. Infrastructure is up-to-date"
    end
  end

  context "terraspace output" do
    let(:command) { "output" }
    let(:log_path) { "spec/fixtures/summary/output.log" }
    it "run" do
      summary.run
      expect(@io.string).to include "pet1 = krill"
    end
  end

  context "terraspace show" do
    let(:command) { "show" }
    let(:log_path) { "spec/fixtures/summary/show.log" }
    it "run" do
      summary.run
      expect(@io.string).to include "Resources: 2 Outputs: 2"
    end
  end

  context "terraspace validate error" do
    let(:command) { "validate" }
    let(:log_path) { "spec/fixtures/summary/validate/error.log" }
    it "run" do
      summary.run
      expect(@io.string).to include "Error"
      expect(@io.string).to include "Unsupported attribute"
    end
  end
end
