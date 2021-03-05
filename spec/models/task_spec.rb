require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do

  	it 'titleが存在する' do 
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
  	end

  	it 'statusが存在する' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
  	end

  	it 'titleが一意性を持っている' do
  	  FactoryBot.create(:task, title: "mtg準備")
      task = FactoryBot.build(:task, title: "mtg準備")
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
  	end  	  		
  end
end