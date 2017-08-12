describe ApplicationController do
  describe '#current_user' do
    before { allow(subject).to receive(:session).and_return(session_value) }

    let(:session_value) do
      {
        user_id: user_id
      }
    end

    context 'when session[:user_id] is defined' do
      let(:user) { FactoryGirl.create(:user) }
      let(:user_id) { user.id }

      it 'finds the user on database' do
        expect(subject.current_user).to eq(user)
      end

      describe 'singleton behavior' do
        before { allow(User).to receive(:find).with(user_id).and_return(user) }

        it 'hits database just once' do
          expect(User).to receive(:find).with(user_id).once

          subject.current_user
          subject.current_user
        end
      end
    end

    context 'when session[:user_id] is NOT defined' do
      let(:user_id) { nil }

      it { expect(subject.current_user).to be_nil }
    end
  end
end
