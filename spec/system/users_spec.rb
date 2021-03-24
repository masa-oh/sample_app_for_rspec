require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      let(:user) { build(:user) }
      let(:registered_user) { create(:user) }

      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit sign_up_path
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'SignUp'
          expect(page).to have_current_path '/login'
          expect(page).to have_content 'User was successfully created.'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'SignUp'
          expect(page).to_not have_content 'User was successfully created.'
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'user[email]', with: registered_user.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'SignUp'
          expect(page).to_not have_content 'User was successfully created.'
        end
      end
    end

    describe 'マイページ' do
      let(:user) { create(:user) }

      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(page).to have_current_path '/login'
          expect(page).to have_content 'Login required'
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー編集' do
      let(:user) { create(:user) }
      let(:user_to_be_updated) { build(:user) }
      let(:another_user) { create(:user) }
      let(:user_with_duplicated_title) { build(:user, email: another_user.email) }

      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          login(user)
          visit edit_user_path(user)
          fill_in 'user[email]', with: user_to_be_updated.email
          fill_in 'user[password]', with: 'pass'
          fill_in 'user[password_confirmation]', with: 'pass'
          click_button 'Update'
          expect(page).to have_content 'User was successfully updated.'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          login(user)
          visit edit_user_path(user)
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: 'pass'
          fill_in 'user[password_confirmation]', with: 'pass'
          click_button 'Update'
          expect(page).to_not have_content 'User was successfully updated.'
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          login(user)
          visit edit_user_path(user)
          fill_in 'user[email]', with: user_with_duplicated_title.email
          fill_in 'user[password]', with: 'pass'
          fill_in 'user[password_confirmation]', with: 'pass'
          click_button 'Update'
          expect(page).to_not have_content 'User was successfully updated.'
        end
      end
      
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          login(user)
          visit edit_user_path(another_user)
          expect(page).to have_current_path "/users/#{user.id}"
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end

    describe 'マイページ' do
      let(:user) { create(:user) }
      let!(:task) { create(:task, user: user) }
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          login(user)
          visit user_path(user)
          expect(page).to have_content task.title
        end
      end
    end
  end
end
