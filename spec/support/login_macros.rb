module LoginMacros
  def login(user, email=user.email, password='password')
    visit login_path
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_button 'Login'
  end

  def logout
    visit root_path
    click_link 'Logout'
  end
end
