describe SessionsController, type: :controller do
  describe '#create' do
    let(:logged_user) { FactoryGirl.create(:user) }
    let(:user_authentication_service) do
      double('user_authentication_service',
             authenticate!: logged_user)
    end

    before do
      allow(UserAuthenticationService).to receive(:new)
        .and_return(user_authentication_service)
    end

    it 'sets the user_id on session' do
      post :create

      expect(session[:user_id]).to eq(logged_user.id)
    end

    it do
      post :create

      expect(response).to redirect_to(root_path)
    end

    describe 'user_authentication_service usage' do
      before { allow(controller).to receive(:request).and_return(dummy_request) }

      let(:dummy_request) { spy('dummy_request') }

      it 'initializes UserAuthenticationService with request once' do
        expect(UserAuthenticationService).to receive(:new)
          .with(dummy_request).once

        post :create
      end
    end
  end

  describe '#destroy' do
    before do
      session[:user_id] = 1234

      delete :destroy
    end

    it 'cleans user_id from session' do
      expect(session[:user_id]).to be_nil
    end

    it { expect(response).to redirect_to(root_path) }
  end
end
