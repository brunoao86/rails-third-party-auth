describe UserAuthenticationService::RequestFacebook do
  let(:raw_request) { spy('raw_request', env: raw_request_env) }

  let(:raw_request_env) do
    {
      "omniauth.auth" => facebook_response_obj,
      "omniauth.strategy" => facebook_strategy_obj
    }
  end

  let(:facebook_response_obj) do
    JSON.parse(facebook_response.to_json, object_class: OpenStruct)
  end

  let(:facebook_response) do
    {
      uid: 'dummy uid',
      info: {
        name: 'dummy name',
        email: 'dummy email',
        image: 'dummy image',
      },
      credentials: {
        token: 'dummy token',
        expires_at: 1501690375
      }
    }
  end

  let(:facebook_strategy_obj) do
    JSON.parse(facebook_strategy.to_json, object_class: OpenStruct)
  end

  let(:facebook_strategy) do
    {
      options: {
        client_id: dummy_request_token_value,
      }
    }
  end

  let(:dummy_request_token_value) { 'dUmmy_r3qu3st_t0k3n' }

  let(:koala_facebook_api_service) { double('koala_facebook_api_service') }

  let(:graph_api_response) do
    {
      'gender' => 'dummy gender',
      'locale' => 'dummy locale'
    }
  end

  before do
    allow(Koala::Facebook::API).to receive(:new)
      .with('dummy token').and_return(koala_facebook_api_service)

    allow(koala_facebook_api_service).to receive(:get_object)
      .with("me?fields=gender,locale").and_return(graph_api_response)
  end

  subject { described_class.new(raw_request) }

  it { expect(subject).to be_a_kind_of(UserAuthenticationService::RequestBase) }

  describe 'initialization' do
    let(:valid_response) { true }

    before do
      allow_any_instance_of(described_class).to receive(:valid?)
        .and_return(valid_response)
    end

    describe 'provider' do
      it { expect(subject.instance_variable_get(:@provider)).to eq('facebook') }
    end

    describe 'uid' do
      it { expect(subject.instance_variable_get(:@uid)).to eq('dummy uid') }
    end

    describe 'user_name' do
      it { expect(subject.instance_variable_get(:@user_name)).to eq('dummy name') }
    end

    describe 'user_email' do
      it { expect(subject.instance_variable_get(:@user_email)).to eq('dummy email') }
    end

    describe 'user_image' do
      it { expect(subject.instance_variable_get(:@user_image)).to eq('dummy image') }
    end

    describe 'credentials_token' do
      it do
        expect(subject.instance_variable_get(:@credentials_token)).to eq('dummy token')
      end
    end

    describe 'credentials_expiration' do
      it do
        expected = Time.at(1501690375)
        expect(subject.instance_variable_get(:@credentials_expiration)).to eq(expected)
      end
    end

    describe 'request_validation_token' do
      it do
        expected = 'dUmmy_r3qu3st_t0k3n'
        expect(subject.instance_variable_get(:@request_validation_token)).to eq(expected)
      end
    end

    describe 'user_locale' do
      context 'when request is valid' do
        it { expect(subject.instance_variable_get(:@user_locale)).to eq('dummy locale') }
      end

      context 'when request is NOT valid' do
        let(:valid_response) { false }

        it { expect(subject.instance_variable_get(:@user_locale)).to be_nil }
      end
    end

    describe 'user_gender' do
      context 'when request is valid' do
        it { expect(subject.instance_variable_get(:@user_gender)).to eq('dummy gender') }
      end

      context 'when request is NOT valid' do
        let(:valid_response) { false }

        it { expect(subject.instance_variable_get(:@user_gender)).to be_nil }
      end
    end

    describe 'facebook API usage' do
      before { subject }

      context 'when request is valid' do
        it 'initializes Koala::Facebook::API once' do
          expect(Koala::Facebook::API).to have_received(:new).once
        end

        it 'hits the Facebook API once' do
          expect(koala_facebook_api_service).to have_received(:get_object).once
        end
      end

      context 'when request is NOT valid' do
        let(:valid_response) { false }

        it 'does NOT initialize Koala::Facebook::API' do
          expect(Koala::Facebook::API).to_not have_received(:new)
        end
      end
    end
  end

  describe '#valid?' do
    before do
      ENV['FACEBOOK_CLIENT_ID'] = 'dUmmy_r3qu3st_t0k3n'
    end

    context 'when request validation token is equal to the environment' do
      it { expect(subject.valid?).to eq(true) }
    end

    context 'when request validation token is NOT equal to the environment' do
      let(:dummy_request_token_value) { 'd1ff3r3nt_dUmmy_r3qu3st_t0k3n' }

      it { expect(subject.valid?).to eq(false) }
    end
  end
end
