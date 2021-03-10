require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:another_user) {create(:user)}

  describe 'User crud' do
    describe 'ログイン前' do
      describe '新規作成' do

        context 'フォーム入力が正常に行われる' do
          it 'ユーザーの新規登録が成功する' do
            visit sign_up_path
            fill_in 'Email', with: 'test@example.com'
            fill_in 'Password', with: '111111'
            fill_in 'Password confirmation', with: '111111'
            click_button 'SignUp'
            expect(current_path).to eq login_path
            expect(page).to have_content 'User was successfully created.'
          end
        end

        context 'メールアドレスが未入力' do
          it 'ユーザーの新規作成が失敗する'do
            visit sign_up_path
            fill_in 'Email', with: ""
            fill_in 'Password', with: '111111'
            fill_in 'Password confirmation', with: '111111'
            click_button 'SignUp'
            expect(current_path).to eq users_path
          end
        end

        context 'メールアドレスに一意性がない' do
          it 'ユーザーに新規作成が失敗する' do
            exist_user = create(:user)
            visit sign_up_path
            fill_in 'Email', with: exist_user.email
            fill_in 'Password', with: '111111'
            fill_in 'Password confirmation', with: '111111'
            click_button 'SignUp'
            expect(page).to have_content '1 error prohibited this user from being saved'
            expect(page).to have_content 'Email has already been taken'
            expect(current_path).to eq users_path
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
      before { login_as(user) }

      describe 'ユーザーの編集' do

        context 'フォームの入力が正常' do
          it '編集に成功する' do
          	visit edit_user_path(user)
          	fill_in 'Email', with: 'updated@example.com'
            fill_in 'Password', with: 'password'
            fill_in 'Password confirmation', with: 'password'
            click_button 'Update'
            expect(page).to have_content ('User was successfully updated.') 
            expect(current_path).to eq user_path(user)
          end
        end

        context 'メールアドレスが未入力' do
          it '編集に失敗する' do
            visit edit_user_path(user)
            fill_in 'Email', with: ""
            fill_in 'Password', with: 'password'            
            fill_in 'Password confirmation', with: 'password'
            click_button 'Update'
            expect(page).to have_content '1 error prohibited this user from being saved'            
            expect(page).to have_content "Email can't be blank"
            expect(current_path).to eq user_path(user)      
          end     
        end

        context 'メールアドレスに一意性がない' do
          it '編集に失敗する' do
            visit edit_user_path(user)
          	exist_user = create(:user)
          	fill_in 'Email', with: exist_user.email
            fill_in 'Password', with: 'password'            
            fill_in 'Password confirmation', with: 'password'
            click_button 'Update'
            expect(page).to have_content '1 error prohibited this user from being saved'
            expect(page).to have_content 'Email has already been taken'
            expect(current_path).to eq user_path(user)
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
      before { login_as(user) }
      context 'タスクの作成' do
        it '新規作成したタスクが表示される' do
          create(:task, title: 'test_title', status: :doing, user: user)
          visit user_path(user)
          expect(page).to have_content 'test_title'
          expect(page).to have_content('You have 1 task.')
          expect(page).to have_content('test_title')
          expect(page).to have_content('doing')
        end 	
      end
    end
  end
end
