require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      let(:new_user) { build(:user) }
      let(:registered_user) { create(:user) }
      before { visit sign_up_path }

      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          fill_in 'user[email]', with: new_user.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'SignUp'
          expect(page).to have_content 'User was successfully created.'
          expect(current_path).to eq login_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'SignUp'
          expect(page).to_not have_content 'User was successfully created.'
          expect(current_path).to eq users_path
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'user[email]', with: registered_user.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'SignUp'
          expect(page).to_not have_content 'User was successfully created.'
          expect(current_path).to eq users_path
        end
      end
    end

    describe 'マイページ' do
      let(:user) { create(:user) }

      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'ユーザー編集' do
      let(:user) { create(:user) }
      let(:user_to_be_updated) { build(:user) }
      let(:other_user) { create(:user) }
      let(:user_with_duplicated_title) { build(:user, email: other_user.email) }

      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_path(user)
          fill_in 'user[email]', with: user_to_be_updated.email
          fill_in 'user[password]', with: 'pass'
          fill_in 'user[password_confirmation]', with: 'pass'
          click_button 'Update'
          expect(page).to have_content 'User was successfully updated.'
          expect(current_path).to eq user_path(user)
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: 'pass'
          fill_in 'user[password_confirmation]', with: 'pass'
          click_button 'Update'
          expect(page).to have_content('1 error prohibited this user from being saved')
          expect(page).to have_content("Email can't be blank")
          expect(current_path).to eq user_path(user)
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'user[email]', with: user_with_duplicated_title.email
          fill_in 'user[password]', with: 'pass'
          fill_in 'user[password_confirmation]', with: 'pass'
          click_button 'Update'
          expect(page).to have_content('1 error prohibited this user from being saved')
          expect(page).to have_content('Email has already been taken')
          expect(current_path).to eq user_path(user)
        end
      end
      
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_user_path(other_user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq user_path(user)
        end
      end
    end

    describe 'マイページ' do
      let(:user) { create(:user) }
      let!(:task) { create(:task, user: user) }
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          visit user_path(user)
          expect(page).to have_content('You have 1 task.')
          expect(page).to have_content task.title
          expect(page).to have_content task.status
          expect(page).to have_link('Show')
          expect(page).to have_link('Edit')
          expect(page).to have_link('Destroy')
        end
      end
    end
  end
end
