require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }
  describe 'ログインとログアウト' do
  	describe 'ログインに成功する' do
  	  context 'フォームに正常な値が入力される' do
  	  	it 'ログインに成功する' do
  	  	  visit_login_path 
  	  	  fill_in 'email' with, user.email
  	  	  fill_in 'password' with, user.password
  	  	  click_button 'login'
  	  	  expect(page).to have_content ('Login successful')
  	  	  expect(current_path).to eq tasks_path
  	  	end
  	  end	
  	end

  	describe 'ログインに失敗する' do
  	  context 'フォームに値が入力されない' do
  	  	it 'ログインに失敗する' do
  	  	  visit_login_path
  	  	  fill_in 'email' with, ""
  	  	  fill_in 'password' with, ""
  	  	  click_button 'login'
  	  	  expect(page).to have_content ('Login failed')
  	  	  expect(current_path).to eq login_path        
  	  	end
  	  end
  	end	

  	describe 'ログアウトに成功する' do
  	  context 'ログアウトボタンを押す' do
  	  	it 'ログアウトに成功する' do
  	  	  sign_in(user)
          click_link 'Logout'
          expect(page).to have_content 'Logged out'
          expect(current_path).to eq root_path
  	  	end
  	  end
  	end
  end
end
