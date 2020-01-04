RSpec.describe Rucksack::Endpoint do
  let(:endpoint) do
    Class.new(Rucksack::Endpoint) do
      def handle
        raise ArgumentError, "This is test error"
      end
    end
  end

  subject { endpoint.new(request) }

  let(:request) { Rucksack::Request.new(env, params) }

  let(:env) do
    {}
  end

  let(:params) do
    {}
  end

  it "raises an error" do
    expect { subject.handle }.to raise_error(ArgumentError)
  end

  context "when endpoints is rescued from error" do
    let(:endpoint_class) do
      Class.new(Rucksack::Endpoint) do
        register_rescue_callback ArgumentError do
          render status: 422
        end

        def handle
          raise ArgumentError, "This is test error"
        end
      end
    end

    it "raises an error" do
      expect { subject.handle }.to raise_error(ArgumentError)
    end
  end
end
