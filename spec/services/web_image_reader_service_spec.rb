describe WebImageReaderService do
  let(:url) { 'http://dummy_url' }

  subject { described_class.new(url) }

  describe 'initialization' do
    context 'when url is defined' do
      it 'assigns url to @url' do
        expect(subject.instance_variable_get(:@url)).to eq(url)
      end
    end

    context 'when url is NOT defined' do
      let(:url) { nil }

      it { expect{subject}.to raise_error(ArgumentError) }
    end
  end

  describe '#url' do
    it { expect(subject.url).to eq(url) }
  end

  describe '#image' do
    let(:image) { 'dummy_image' }
    let(:opened_image) { double('opened_image') }

    before do
      allow(subject).to receive(:open)
        .with(url, allow_redirections: :safe).and_return(opened_image)

      allow(opened_image).to receive(:read).and_return(image)
    end

    it { expect(subject.image).to eq(image) }

    describe 'singleton behavior' do
      it 'gets the image once' do
        subject.image
        subject.image

        expect(subject).to have_received(:open).once
      end
    end
  end

  describe '#image_base64' do
    let(:image) { 'dummy_image' }
    let(:image_base64) { 'dummy_image_base64' }

    before do
      allow(subject).to receive(:image).and_return(image)
      allow(Base64).to receive(:encode64).with(image).and_return(image_base64)
    end

    it { expect(subject.image_base64).to eq(image_base64) }

    describe 'singleton behavior' do
      it 'encodes the image once' do
        subject.image_base64
        subject.image_base64

        expect(Base64).to have_received(:encode64).once
      end
    end
  end
end
