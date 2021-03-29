require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:new_task) { build(:task, user: user) }
  let(:registered_task) { create(:task, user: user) }
  let(:task_with_another_title) { build(:task, user: user) }
  let(:another_user) { create(:user) }
  let(:task_created_by_another_user) { create(:task, user: another_user) }

  describe 'ログイン前' do
    describe 'タスク新規作成' do
      context 'ログインしていない状態' do
        it 'タスク新規作成ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_current_path '/login'
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'タスク編集' do
      context 'ログインしていない状態' do
        it 'タスク編集ページへのアクセスが失敗する' do
          visit edit_task_path(registered_task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'タスク新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          login(user)
          visit new_task_path
          fill_in 'task[title]', with: new_task.title
          fill_in 'task[content]', with: new_task.content
          select 'doing', from: 'task[status]'
          fill_in 'task[deadline]', with: 1.week.from_now
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
          expect(current_path).to eq '/tasks/1'
        end
      end
    end

    describe 'タスク編集' do
      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          login(user)
          visit edit_task_path(registered_task)
          fill_in 'task[title]', with: task_with_another_title.title
          click_button 'Update Task'
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq task_path(task)
        end
      end

      context '他ユーザーのタスク編集ページにアクセス' do
        it 'タスク編集ページへのアクセスが失敗する' do
          login(user)
          visit edit_task_path(task_created_by_another_user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスク削除' do
      context 'フォームの入力値が正常' do
        let!(:task_to_be_destroyed) { create(:task, user: user) }

        it 'タスクの削除が成功する' do
          login(user)
          visit tasks_path
          page.accept_confirm do
            click_on 'Destroy', match: :first
          end
          expect(page).to have_content 'Task was successfully destroyed.'
          expect(current_path).to eq tasks_path
        end
      end
    end
  end
end
