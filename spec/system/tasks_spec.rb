require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe 'ログイン前' do
    describe 'タスク新規作成' do
      context 'ログインしていない状態' do
        it 'タスク新規作成ページへのアクセスが失敗する'
      end
    end

    describe 'タスク編集' do
      context 'ログインしていない状態' do
        it 'タスク編集ページへのアクセスが失敗する'
      end
    end
  end

  describe 'ログイン後' do
    describe 'タスク新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する'
      end
    end

    describe 'タスク編集' do
      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する'
      end
      context '他ユーザーのタスク編集ページにアクセス' do
        it 'タスク編集ページへのアクセスが失敗する'
      end
    end

    describe 'タスク削除' do
      context 'フォームの入力値が正常' do
        it 'タスクの削除が成功する'
      end
    end
  end
end
