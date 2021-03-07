require 'rails_helper'
require 'support/login_module'

RSpec.describe "Tasks", type: :system do
  let(:task) { create(:task) }
  let(:user) { create(:user) }

  describe 'タスクまわり' do


    describe 'ログイン前' do
      describe 'ログイン前のTask crud' do
      	context 'ログイン前にタスク作成' do
      	  it 'タスク作成することができない' do
      	  	visit new_task_path
            expect(page).to have_content('Login required')
            expect(current_path).to eq login_path
      	  end
      	end

      	context 'ログイン前にタスク編集画面に遷移' do
      	  it '編集画面に遷移することができない' do
          visit edit_task_path(task)
          expect(page).to have_content('Login required')
          expect(current_path).to eq login_path 
          end	  	
      	end

      	context 'ログイン前にマイページへの遷移' do
      	  it '遷移することができない' do
      	    visit tasks_path(task)
            expect(page).to have_content('Login required')
            expect(current_path).to eq login_path       	    
      	  end
      	end

      	context 'ログイン前にタスク一覧ページへの遷移' do
      	  it '遷移することができない' do
      	  	visit tasks_path
            expect(page).to have_content('Login required')
            expect(current_path).to eq login_path            	  	
      	  end
      	end
      end
    end



    describe 'ログイン後' do
      before {sign_in(user) }
      describe 'Task crud' do
        context 'フォーム入力が正常に行われる' do
          it 'タスク作成が正常に行われる' do
            visit new_task_path
            fill_in 'title', with: 'sample_title'
            fill_in 'content', with: 'sample_content'
            fill_in 'status', with: 'todo'
            fill_in 'deadline', with: '2021/1/6 22:39'
            click_button 'Create Task'
            expect(current_path).to eq '/tasks/1'
            expect(page).to have_content 'Task was successfully created.'
            expect(page).to have_content 'sample_title'    
            expect(page).to have_content 'sample_content'
            expect(page).to have_content 'todo'
            expect(page).to have_content '2021/1/6 22:39'
          end
        end

        context 'フォーム入力が正常に行われる' do
          it 'タスク編集が正常に行われる' do
          	sample_task = create(:task)
            visit edit_task_path(sample_task)
            fill_in 'title', with: 'update_title'
            fill_in 'content', with: 'update_content'
            fill_in 'status', with: 'todo'
            fill_in 'deadline', with: '2019/1/6 22:39'
            click_button 'Update Task'   
            expect(current_path).to eq '/tasks/1'
            expect(page).to have_content 'Task was successfully updated.'
            expect(page).to have_content 'update_content'    
            expect(page).to have_content 'update_content'
            expect(page).to have_content 'todo'
            expect(page).to have_content '2019/1/6 22:39'  
          end
        end

        context 'タスクの削除' do
          it '正常に行われる' do
            visit tasks_path
            click_button 'Destroy'
            expect(current_path).to eq tasks_path
            expect(page).to have_content 'Task was successfully destroyed.'
          end	
        end
      end
    end
  end
end



