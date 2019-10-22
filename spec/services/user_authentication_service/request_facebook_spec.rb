describe UserAuthenticationService::RequestFacebook do
  let(:raw_request) { spy('raw_request', env: raw_request_env) }

  let(:raw_request_env) do
    {
      "omniauth.auth" => request_auth,
      "omniauth.strategy" => request_strategy
    }
  end

  let(:request_auth) { double('request_auth') }
  let(:request_strategy) { double('request_strategy') }

  subject { described_class.new(raw_request) }

  it { expect(subject).to be_a_kind_of(UserAuthenticationService::RequestBase) }

  describe 'initialization' do
    describe 'request_auth' do
      it { expect(subject.instance_variable_get(:@request_auth)).to eq(request_auth) }
    end

    describe 'request_strategy' do
      it do
        expect(subject.instance_variable_get(:@request_strategy)).to eq(request_strategy)
      end
    end
  end

  describe '#request_auth' do
    it { expect(subject.request_auth).to eq(request_auth) }
  end

  describe '#request_strategy' do
    it { expect(subject.request_strategy).to eq(request_strategy) }
  end

  describe '#provider' do
    it { expect(subject.provider).to eq('facebook') }
  end

  describe 'dependents from request_auth' do
    let(:request_auth_obj) do
      JSON.parse(request_auth.to_json, object_class: OpenStruct)
    end

    let(:request_auth) do
      {
        uid: 'dummy uid',
        info: {
          name: 'dummy name',
          email: 'dummy email',
          image: 'dummy_raw_image_url',
        },
        credentials: {
          token: 'dummy token',
          expires_at: 1501690375
        }
      }
    end

    before { allow(subject).to receive(:request_auth).and_return(request_auth_obj) }

    describe '#uid' do
      it { expect(subject.uid).to eq('dummy uid') }
    end

    describe '#user_name' do
      it { expect(subject.user_name).to eq('dummy name') }
    end

    describe '#user_email' do
      it { expect(subject.user_email).to eq('dummy email') }
    end

    describe '#raw_image_url' do
      it { expect(subject.raw_image_url).to eq('dummy_raw_image_url') }
    end

    describe '#credentials_token' do
      it { expect(subject.credentials_token).to eq('dummy token') }
    end

    describe '#credentials_expiration' do
      it do
        expect(subject.credentials_expiration).to eq(Time.at(1501690375))
      end
    end
  end

  describe 'dependents from facebook api' do
    before { allow(subject).to receive(:valid?).and_return(valid_response) }

    context 'when request is NOT valid' do
      let(:valid_response) { false }

      describe '#user_gender' do
        it { expect(subject.user_gender).to be_nil }
      end

      describe '#user_locale' do
        it { expect(subject.user_locale).to :en }
      end

      describe 'facebook API usage' do
        before do
          allow(Koala::Facebook::API).to receive(:new)
        end

        it 'does NOT initialize Koala::Facebook::API' do
          subject.user_gender

          expect(Koala::Facebook::API).to_not have_received(:new)
        end
      end
    end

    context 'when request is valid' do
      let(:valid_response) { true }

      before do
        allow(subject).to receive(:credentials_token).and_return(credentials_token)

        allow(Koala::Facebook::API).to receive(:new)
          .with(credentials_token).and_return(koala_facebook_api_service)

        allow(koala_facebook_api_service).to receive(:get_object)
          .with("me?fields=gender,locale").and_return(graph_api_response)
      end

      let(:credentials_token) { 'dummy_token' }

      let(:koala_facebook_api_service) { double('koala_facebook_api_service') }

      let(:graph_api_response) do
        {
          'gender' => 'dummy gender',
          'locale' => 'dummy locale'
        }
      end

      describe '#user_gender' do
        it { expect(subject.user_gender).to eq('dummy gender') }
      end

      describe '#user_locale' do
        it { expect(subject.user_locale).to eq('dummy locale') }
      end

      describe 'facebook API usage' do
        before do
          subject.user_gender
        end

        it 'initializes Koala::Facebook::API once' do
          expect(Koala::Facebook::API).to have_received(:new).once
        end

        it 'hits the Facebook API once' do
          expect(koala_facebook_api_service).to have_received(:get_object).once
        end
      end
    end
  end

  describe 'dependents from request_strategy' do
    before do
      allow(subject).to receive(:request_strategy).and_return(request_strategy_obj)
    end

    let(:request_strategy_obj) do
      JSON.parse(request_strategy.to_json, object_class: OpenStruct)
    end

    let(:request_strategy) do
      {
        options: {
          client_id: 'dummy request token',
        }
      }
    end

    describe '#request_validation_token' do
      it { expect(subject.request_validation_token).to eq('dummy request token') }
    end
  end

  describe '#user_image_url' do
    before { allow(subject).to receive(:raw_image_url).and_return(raw_image_url) }

    context 'when raw_image_url is defined' do
      let(:raw_image_url) { 'http://dummy_raw_url' }

      it { expect(subject.user_image_url).to eq('http://dummy_raw_url?type=large') }
    end

    context 'when raw_image_url is NOT defined' do
      let(:raw_image_url) { '' }

      it { expect(subject.user_image_url).to be_nil }
    end
  end

  describe '#valid?' do
    let(:dummy_token) { 'dUmmy_r3qu3st_t0k3n' }

    before do
      allow(subject).to receive(:request_validation_token).and_return(dummy_token)
      ENV['FACEBOOK_CLIENT_ID'] = 'dUmmy_r3qu3st_t0k3n'
    end

    context 'when request validation token is equal to the environment' do
      it { expect(subject.valid?).to eq(true) }
    end

    context 'when request validation token is NOT equal to the environment' do
      let(:dummy_token) { 'd1ff3r3nt_dUmmy_r3qu3st_t0k3n' }

      it { expect(subject.valid?).to eq(false) }
    end
  end
end
