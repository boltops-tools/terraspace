describe Terraspace::Logger do
  let(:logger) { described_class.new(@io = StringIO.new) }

  # Terraform opens a warning with the box character U+2577, bytes E2 95 B7.
  # shell.rb reads the terraform output in byte blocks and splits them on
  # newlines, so a block boundary can land in the middle of that character and
  # leave an incomplete sequence at the end of the line.
  let(:box) { "╷" }
  let(:split_line) { "Warning: value for undeclared variable #{box.b[0, 2]}" }

  context "line with an incomplete multi-byte character" do
    it "logs the line" do
      expect { logger.info(split_line) }.to_not raise_error
      expect(@io.string).to include "Warning: value for undeclared variable"
    end

    it "writes valid UTF-8" do
      logger.info(split_line)
      expect(@io.string.force_encoding('UTF-8')).to be_valid_encoding
    end
  end

  context "line with a complete multi-byte character" do
    it "does not change the line" do
      logger.info("#{box} note = \"café\"")
      expect(@io.string).to include "#{box} note = \"café\""
    end
  end
end
