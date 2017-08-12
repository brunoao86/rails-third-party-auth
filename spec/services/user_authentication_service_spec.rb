describe UserAuthenticationService do
  let(:raw_request) { double('raw_request') }
  let(:request_provider) { double('request_provider') }

  before do
    allow(UserAuthenticationService::RequestProviderBuilder).to receive(:build)
      .with(raw_request).and_return(request_provider)
  end

  subject { described_class.new(raw_request) }

  describe 'initialization' do
    describe 'request_provider' do
      it 'assigns the built request provider' do
        expect(subject.instance_variable_get(:@request_provider)).to eq(request_provider)
      end
    end
  end

  describe '#request_provider' do
    it do
      expect(subject.request_provider).to eq(request_provider)
    end
  end

  describe '#user' do
    describe 'provider request validation' do
      before do
        allow(request_provider).to receive(:valid?).and_return(valid_response)
      end

      context 'when request is valid' do
        let(:valid_response) { true }

        describe 'first_or_initialize behavior' do
          context 'when user does NOT exist' do
            let(:request_provider) do
              double('request_provider',
                     provider: 'dummy_provider',
                     uid: 'dummy_uid')
            end

            it 'returns a NON-persistent user' do
              expect(subject.user.persisted?).to eq(false)
            end
          end

          context 'when user already exist' do
            let(:user) { FactoryGirl.create(:user) }

            let(:request_provider) do
              double('request_provider',
                     provider: user.provider,
                     uid: user.uid)
            end

            it 'returns a persisted user' do
              expect(subject.user.persisted?).to eq(true)
            end
          end
        end
      end

      context 'when request is NOT valid' do
        let(:valid_response) { false }
        let(:expected_error) { UserAuthenticationService::InvalidRequest }

        it { expect{subject.user}.to raise_error(expected_error) }
      end
    end
  end

  describe '#authenticate!' do
    let(:user) { FactoryGirl.create(:user) }

    let(:expiration_date) { DateTime.tomorrow.at_end_of_day }

    let(:request_provider) do
      double('request_provider',
             provider: user.provider,
             uid: user.uid,
             user_name: 'dummy user_name',
             user_gender: 'dummy user_gender',
             user_email: 'dummy user_email',
             user_image: 'dummy user_image',
             user_locale: 'dummy user_locale',
             credentials_token: 'dummy credentials_token',
             credentials_expiration: expiration_date
            )
    end

    before { allow(subject).to receive(:user).and_return(user) }

    let(:logged_user) { subject.authenticate! }

    describe 'user update' do
      describe 'provider' do
        it { expect(logged_user.provider).to eq(user.provider) }
      end

      describe 'uid' do
        it { expect(logged_user.uid).to eq(user.uid) }
      end

      describe 'name' do
        it { expect(logged_user.name).to eq('dummy user_name') }
      end

      describe 'gender' do
        it { expect(logged_user.gender).to eq('dummy user_gender') }
      end

      describe 'email' do
        it { expect(logged_user.email).to eq('dummy user_email') }
      end

      describe 'image' do
        it { expect(logged_user.image).to eq('dummy user_image') }
      end

      describe 'locale' do
        it { expect(logged_user.locale).to eq('dummy user_locale') }
      end

      describe 'oauth_token' do
        it { expect(logged_user.oauth_token).to eq('dummy credentials_token') }
      end

      describe 'oauth_expires_at' do
        it { expect(logged_user.oauth_expires_at).to eq(expiration_date) }
      end
    end
  end
end
