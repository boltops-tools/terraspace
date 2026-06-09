require "tmpdir"

describe Terraspace::CLI::Fmt::Runner do
  let(:dir)    { "app/stacks/demo" }
  let(:runner) { described_class.new(dir, {}) }

  around(:each) do |example|
    Dir.mktmpdir do |root|
      base = "#{root}/#{dir}/tfvars"
      FileUtils.mkdir_p(base)
      File.write("#{root}/#{dir}/main.tf", "foo = 1\n")          # plain tf
      File.write("#{root}/#{dir}/erb.tf",  "foo = <%= 1 %>\n")   # erb tf
      File.write("#{base}/plain.tfvars",   "foo = 1\n")          # plain tfvars
      File.write("#{base}/erb.tfvars",     "foo = <%= 1 %>\n")   # erb tfvars

      saved, Terraspace.root = Terraspace.root, root
      example.run
      Terraspace.root = saved
    end
  end

  def exist?(path)
    File.exist?("#{Terraspace.root}/#{dir}/#{path}")
  end

  it "includes tfvars files alongside tf files" do
    names = runner.send(:tf_files).map { |p| File.basename(p) }
    expect(names).to include("main.tf", "erb.tf", "plain.tfvars", "erb.tfvars")
  end

  # Regression: terraform fmt -recursive descends into the tfvars subfolder and
  # errors on ERB tfvars. They must be renamed out of the way like ERB tf files.
  it "renames only ERB files (including ERB tfvars) to .skip" do
    runner.rename_to_skip_fmt

    expect(exist?("erb.tf.skip")).to be true
    expect(exist?("tfvars/erb.tfvars.skip")).to be true
    expect(exist?("erb.tf")).to be false
    expect(exist?("tfvars/erb.tfvars")).to be false

    # non-ERB files are left untouched for terraform fmt to format
    expect(exist?("main.tf")).to be true
    expect(exist?("tfvars/plain.tfvars")).to be true
  end

  it "restores skipped ERB tfvars back to their original name" do
    runner.rename_to_skip_fmt
    runner.restore_rename

    expect(exist?("tfvars/erb.tfvars")).to be true
    expect(exist?("tfvars/erb.tfvars.skip")).to be false
    expect(exist?("erb.tf")).to be true
    expect(exist?("erb.tf.skip")).to be false
  end
end
