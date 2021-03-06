# -*- encoding : utf-8 -*-
# TODO Refatorar isso pra Page Objects

Dado /^que sou um usuário já cadastrado no Votar Como Vamos$/ do
  test_users = Koala::Facebook::TestUsers.new(
    :app_id => Settings.facebook_app_id, :secret => Settings.facebook_secret)
  @user = test_users.create(true, Settings.facebook_scopes)
  User.create!(
    provider: 'facebook', 
    uid: @user['id'],
    name: 'Test User',
    email: 'test@test.com')
end

Quando /^eu acesso a página principal$/ do
  visit Settings.facebook_app_url 
end

Dado /^que estou logado no facebook$/ do
  visit "http://www.facebook.com"
  fill_in "email", with: @user['email']
  fill_in "pass", with: @user['password']
  click_button "Log In"
end

Então /^devo ser autenticado com sucesso$/ do
  within_frame "iframe_canvas" do 
    page.should have_content("Seja bem vindo!")
  end
end

Dado /^que sou um usuário não cadastrado no Votar Como Vamos$/ do
  test_users = Koala::Facebook::TestUsers.new(
    :app_id => Settings.facebook_app_id, :secret => Settings.facebook_secret)
  @user = test_users.create(false)
end

Quando /^confirmo o pedido de autorização$/ do
  within_frame "iframe_canvas" do
    find(".platform_dialog a").click
  end
  find('#grant_clicked input').click
end
