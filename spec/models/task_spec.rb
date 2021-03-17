require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    it '全ての属性があれば有効であること' do
      task = FactoryBot.build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it 'タイトル無しでは無効であること' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'ステータス無しでは無効であること' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it '重複したタイトルでは無効であること' do
      FactoryBot.create(:task, title: 'テスト')
      task = FactoryBot.build(:task, title: 'テスト')
      task.valid?
      expect(task.errors[:title]).to include('has already been taken')
    end

    it '別のタイトルで有効なタスクが作成できること' do
      FactoryBot.create(:task, title: 'Test')
      task = FactoryBot.build(:task, title: 'Another Test')
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end
  end
end
