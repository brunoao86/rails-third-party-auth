describe HomeController, type: :controller do
  describe '#index' do
    before { get :index }

    it { expect(response).to render_template(:index) }

    it { expect(response).to have_http_status(:ok) }
  end
end
