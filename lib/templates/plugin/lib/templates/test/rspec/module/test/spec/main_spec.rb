# This starter example of a spec that creates a test harness and provisions a real s3 bucket.
# The test harness will be created at:
#
#    /tmp/terraspace-test-harnesses/<%= @name %>
#
# It's recommended to run this on a test AWS account.
#
describe "main" do
  before(:all) do
    mod_path = File.expand_path("../..", __dir__)
    terraspace.build_test_harness(
      name: "<%= @name %>",
      modules: {example: mod_path},
      stacks:  {example: "#{mod_path}/test/spec/fixtures/stack"},
    )
    terraspace.up("example")
  end
  after(:all) do
    terraspace.down("example")
  end

  it "successful deploy" do
    # Replace with your actual test
    expect(true).to be true
    # Example:
    # some_output = terraspace.output("example", "some_output")
    # expect(some_output).to include("output_value)
  end
end
