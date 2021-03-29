require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'タスク新規作成ページへのアクセス' do
        it 'タスク新規作成ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスク編集ページへのアクセス' do
        it 'タスク編集ページへのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスク詳細ページへのアクセス' do
        it 'タスクの詳細情報が表示される' do
          visit task_path(task)
          expect(page).to have_content task.title
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タスクの一覧ページにアクセス' do
        it 'すべてのユーザーのタスク情報が表示される' do
          task_list = create_list(:task, 3)
          visit tasks_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).to have_content task_list[2].title
          expect(current_path).to eq tasks_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'タスク新規作成' do
      let!(:new_task) { build(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      before { visit new_task_path }

      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          fill_in 'task[title]', with: new_task.title
          fill_in 'task[content]', with: new_task.content
          select 'doing', from: 'task[status]'
          fill_in 'task[deadline]', with: 1.week.from_now
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
          expect(current_path).to eq '/tasks/1'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          fill_in 'task[title]', with: ''
          fill_in 'task[content]', with: new_task.content
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          fill_in 'task[title]', with: other_task.title
          fill_in 'task[content]', with: new_task.content
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe 'タスク編集' do
      let(:task) { create(:task, user: user) }
      let(:updated_task) { build(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      let(:another_user) { create(:user) }
      let(:task_created_by_another_user) { create(:task, user: another_user) }
      before { visit edit_task_path(task) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する' do
          fill_in 'task[title]', with: updated_task.title
          click_button 'Update Task'
          expect(page).to have_content "Title: #{updated_task.title}"
          expect(page).to have_content "Status: #{updated_task.status}"
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'task[title]', with: ''
          select :todo, from: 'task[status]'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end

      context '登録済のタイトルを入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'task[title]', with: other_task.title
          select :todo, from: 'task[status]'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq task_path(task)
        end
      end

      context '他ユーザーのタスク編集ページにアクセス' do
        it 'タスク編集ページへのアクセスが失敗する' do
          visit edit_task_path(task_created_by_another_user)
          expect(page).to have_content 'Forbidden access.'
          expect(current_path).to eq root_path
        end
      end
    end

    describe 'タスク削除' do
      let!(:task) { create(:task, user: user) }

      it 'タスクの削除が成功する' do
        visit tasks_path
        page.accept_confirm do
          click_on 'Destroy', match: :first
        end
        expect(page).to have_content 'Task was successfully destroyed.'
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
  end
end
