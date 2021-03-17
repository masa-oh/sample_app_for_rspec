require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    it '全ての属性があれば有効であること' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it 'タイトル無しでは無効であること' do
      task_without_title = build(:task, title: "")
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    it 'ステータス無しでは無効であること' do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end

    it '重複したタイトルでは無効であること' do
      task = create(:task)
      task_with_duplicated_title = build(:task, title: task.title)
      expect(task_with_duplicated_title).to be_invalid
      expect(task_with_duplicated_title.errors[:title]).to include('has already been taken')
    end

    it '別のタイトルで有効なタスクが作成できること' do
      task = create(:task)
      task_with_another_title = build(:task, title: 'Another Test')
      expect(task_with_another_title).to be_valid
      expect(task_with_another_title.errors).to be_empty
    end
  end
end
