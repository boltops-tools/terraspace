describe Terraspace::Cloud::Api do
  let(:api) { described_class.new(mod: mod) }
  let(:mod) { Terraspace::Mod.new("demo") }

  context "tsc_output_stack_name" do
    it "conventional defaults" do
      expect(api.tsc_output_stack_name).to eq "demo-dev-us-west-2"
    end

    it "should not consider env vars for app, role, extra" do
      with_env_var("TS_APP", "app1") do
        expect(api.tsc_output_stack_name).to eq "demo-dev-us-west-2"
      end
      with_env_var("TS_ROLE", "worker") do
        expect(api.tsc_output_stack_name).to eq "demo-dev-us-west-2"
      end
      with_env_var("TS_EXTRA", "2") do
        expect(api.tsc_output_stack_name).to eq "demo-dev-us-west-2"
      end
    end

    it "should consider env vars for env" do
      with_env_var("TS_ENV", "qa") do
        expect(api.tsc_output_stack_name).to eq "demo-qa-us-west-2"
      end
    end

    it "should consider options for all" do
      expect(api.tsc_output_stack_name(env: "sbx")).to eq "demo-sbx-us-west-2"
      expect(api.tsc_output_stack_name(app: "app1")).to eq "app1-demo-dev-us-west-2"
      expect(api.tsc_output_stack_name(app: "app1", role: "worker")).to eq "app1-worker-demo-dev-us-west-2"
      expect(api.tsc_output_stack_name(app: "app1", role: "worker", extra: 3)).to eq "app1-worker-demo-dev-3-us-west-2"
    end
  end

  def with_env_var(key, value)
    old = ENV[key]
    ENV[key] = value
    yield
    ENV[key] = old
  end
end
