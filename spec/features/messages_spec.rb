feature 'create messages' do

  before(:each) do
    sign_up
  end

  it 'adds a new peep to the database' do
    expect{new_peep}.to change(Peep, :count).by 1
  end

  it 'allows you to post a message' do
    new_peep
    expect(page).to have_content 'Makers Academy is the best'
  end

end
