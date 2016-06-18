feature 'sign in' do
  scenario 'register adds user to database' do
    expect{sign_up}.to change(User, :count).by(1)
  end

  scenario 'welcomes signed in user to chitter' do
    sign_up
    expect(page).to have_content "Welcome, Tobes"
  end

  scenario 'does not sign in if password & confirmation do not match' do
    sign_up(password_confirmation: 'wrong')
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'does not create a user if confirmation password is wrong' do
      expect{sign_up(password_confirmation: 'wrong')}.not_to change(User, :count)
  end


  scenario 'does not allow sign up if username or password is duplicated' do
      sign_up
      sign_up
      expect(page).to have_content "Email is already taken"
      expect(page).to have_content "Username is already taken"
  end
end
