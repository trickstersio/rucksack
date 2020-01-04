RSpec.describe "Rucksack::Route#handle" do
  subject { Rucksack::Route.new(verb, path, endpoint, params, content_types) }

  let(:verb) { "POST" }
  let(:path) { "/test" }

  let(:params) do
    {}
  end

  let(:content_types) do
    [ Rucksack::ContentTypes::JSON ]
  end

  let(:endpoint) do
    Class.new(Rucksack::Endpoint) do
      def handle
        raise ArgumentError, "This is test error"
      end
    end
  end

  it "raises an error" do
    expect { subject.handle(Rack::Request.new, {}) }.to raise_error(ArgumentError)
  end
end
