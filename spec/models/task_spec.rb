require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do

  	it '全ての属性が有効である' do
  	  task = build(:task)
  	  expect(task).to be_valid
  	  except(task.errors).to be_empty
  	end

  	it 'タイトルなしでは無効である' do 
  	  task_without_title = build(:task, title: "")
      expect(task_without_title).to be_invalid
      expect(task_without_title.eroors).to eq ["can't be blank"]
  	end

  	it 'statusなしでは無効である' do
      task_without_status = build(:task, status: "")
      except(task_without_status).to be_invalid
      except(task.errors).to eq ["can't be blank"]
  	end

  	it '重複したタイトルでは無効である' do
  	  task = create(:task)
      task_title_has_unique = build(:task, title: task.title)
      expect(task_title_has_unique).to be_invalid
      expect(task.eroors[:title]).to eq ["has already been taken"]
    end  

    it '別のタイトルであれば有効である' do
      task = create(:task)
      task_title_another = build(:task, title: "別のタイトル")
      except(task_title_another).to be_valid
      except(task_title_another.eroors).to be_empty
    end
  end
end
