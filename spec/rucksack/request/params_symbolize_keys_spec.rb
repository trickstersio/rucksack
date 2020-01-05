RSpec.describe Rucksack::Request do
  subject { described_class.new(rack_request, params) }

  let(:rack_request) { double(Rack::Request) }

  let(:params) do
    {
      "a" => 1,
      b: 2
    }
  end

  it "converts keys in params to symbols" do
    expect(subject.params[:a]).to eq(1)
    expect(subject.params[:b]).to eq(2)
  end
end
