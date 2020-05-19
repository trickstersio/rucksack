RSpec.describe Rucksack::Response do
  subject { described_class.new(status, headers, body) }

  let(:status) { 200 }

  let(:headers) do
    {}
  end

  let(:body) do
    Rucksack::Serializers::Json.new({ test: "test" })
  end

  it "adds body specific content type to headers" do
    expect(subject.headers["Content-Type"]).to eq("application/json")
  end
end
