require 'rails_helper'
require 'support/login_module'

RSpec.describe "Users", type: :system do
  include LoginModule
  let(:user) { create(:user) }
  let(:another_user) {create(:user)}

  describe 'User crud' do
    describe 'ログイン前' do
      describe '新規作成' do

        context 'フォーム入力が正常に行われる' do
          it 'ユーザーの新規登録が成功する' do
            visit sign_up_path
            fill_in 'email', with: 'test@example.com'
            fill_in 'password', with: '111111'
            fill_in 'password_confirmation', with: '111111'
            click_button 'SignUp'
            expect(current_path).to eq login_path
            expect(page).to have_content 'User was successfully created.'
          end
        end

        context 'メールアドレスが未入力' do
          it 'ユーザーの新規作成が失敗する'do
            visit sign_up_path
            fill_in 'email', with: ""
            fill_in 'password', with: '111111'
            fill_in 'password_confirmation', with: '111111'
            click_button 'SignUp'
            expect(current_path).to eq sign_up_path
          end
        end

        context 'メールアドレスに一意性がない' do
          it 'ユーザーに新規作成が失敗する' do
            exist_user = create(:user)
            visit sign_up_path
            fill_in 'email', with: exist_user.email
            fill_in 'password', with: exist_user.password
            fill_in 'password_confirmation', with: exist_user.password_confirmation
            click_button 'SignUp'
            expect(page).to have_content '1 error prohibited this user from being saved'
            expect(page).to have_content 'Email has already been taken'
            expect(current_path).to eq sign_up_path
          end
        end
      end
      
      describe 'マイページ' do
        context 'ログインしていない' do
          it 'マイページへのアクセスができない' do
          visit users_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
          end
        end
      end
    end


    describe 'ログイン後' do
      before {sign_in(user) }

      describe 'ユーザーの編集' do

        context 'フォームの入力が正常' do
          it '編集に成功する' do
          	visit edit_user_path(user)
          	fill_in 'email', with: 'updated@example.com'
            fill_in 'password', with: '222222'
            fill_in 'password_confirmation', with: '22222'
            click_button 'Update'
            expect(page).to have_content 'User was successfully updated.' 
            expect(current_path).to eq edit_user_path(user)
          end
        end

        context 'メールアドレスが未入力' do
          it '編集に失敗する' do
            visit edit_user_path(user)
            fill_in 'email', with: ""
            fill_in 'password', with: 'updated_pass'            
            fill_in 'password_confirmation', with: 'updated_pass'
            click_button 'Update'
            expect(page).to have_content '1 error prohibited this user from being saved'            
            expect(page).to have_content "Email can't be blank"
            expect(current_path).to eq edit_user_path(user)       
          end     
        end

        context 'メールアドレスに一意性がない' do
          it '編集に失敗する' do
          	exist_user = create(:user)
          	visit edit_user_path(user)
          	fill_in 'email', with: exist_user.email
            fill_in 'password', with: 'updated_pass'            
            fill_in 'password_confirmation', with: 'updated_pass'
            expect(page).to have_content '1 error prohibited this user from being saved'
            expect(page).to have_content 'Email has already been taken'
            expect(current_path).to eq edit_user_path(user)
          end
        end

        context '他ユーザーの編集ページにアクセスする' do
          it 'アクセスできない' do
            another_user = create(:user)
            visit edit_user_path(another_user)
            expect(page).to have_content 'Forbidden access.'
            expect(current_path).to eq user_path(user)  
          end          
        end


      end
    end

    describe 'マイページ' do
      context 'タスクの作成' do
        it '新規作成したタスクが表示される' do
          sample_task = create(:task)
          visit tasks_path
          expect(page).to have_content sample_task.title
          expect(page).to have_content sample_task.content
          expect(page).to have_content sample_task.status
          expect(page).to have_content sample_task.dedline
          expect(page).to have_content 'Task was successfully created.'
          expect(current_path).to eq task_path(sample_task)
        end 	
      end
    end
  end
end
