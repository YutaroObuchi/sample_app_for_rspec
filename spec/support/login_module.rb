module LoginModule
  def sign_in(user)
    visit sign_in_path
    click_link "Login"
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Login"
  end
end
