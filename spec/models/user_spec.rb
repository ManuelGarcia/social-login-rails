require 'rails_helper'

RSpec.describe User, :type => :model do

  # new user only uid
  # new user only email
  # login user only uid existent
  # login user only uid not existent
  # login user only

  it "should register new user from site" do

    provider = "facebook"
    uid = "123"
    email = "my@email.com"

    user = User.social_authentication(provider, uid, email)

    expect(User.count).to eq(1)
    expect(Uid.count).to eq(1)

    expect(user.persisted?).to be true
    expect(user.provider).to eq(provider)
    expect(user.uid).to eq(uid)
    expect(user.email).to eq(email)

    expect(user.uids.count).to eq(1)
    expect(user.uids.first.persisted?).to be true
    expect(user.uids.first.provider).to eq(provider)
    expect(user.uids.first.uid).to eq(uid)
    expect(user.uids.first.user).to eq(user)
  end

  it "should login user from site using an already registered uid" do

    # registering
    provider = "facebook"
    uid = "123"
    email = "my@email.com"
    user = User.social_authentication(provider, uid, email)

    # logging
    user = User.social_authentication(provider, uid, email)

    expect(User.count).to eq(1)
    expect(Uid.count).to eq(1)

    expect(user.persisted?).to be true
    expect(user.provider).to eq(provider)
    expect(user.uid).to eq(uid)
    expect(user.email).to eq(email)

    expect(user.uids.first.persisted?).to be true
    expect(user.uids.first.provider).to eq(provider)
    expect(user.uids.first.uid).to eq(uid)
    expect(user.uids.first.user).to eq(user)
  end

  it "should login user from site using an already registered uid even if there is a null email" do

    # registering
    provider = "facebook"
    uid = "123"
    email = "my@email.com"
    user = User.social_authentication(provider, uid, email)

    # logging
    user = User.social_authentication(provider, uid, nil)

    expect(User.count).to eq(1)
    expect(Uid.count).to eq(1)

    expect(user.persisted?).to be true
    expect(user.provider).to eq(provider)
    expect(user.uid).to eq(uid)
    expect(user.email).to eq(email)

    expect(user.uids.first.persisted?).to be true
    expect(user.uids.first.provider).to eq(provider)
    expect(user.uids.first.uid).to eq(uid)
    expect(user.uids.first.user).to eq(user)
  end

  it "should register a known user with another uid but same email" do

    # registering at first
    facebook_provider = "facebook"
    facebook_uid = "123"
    facebook_email = "my@email.com"
    facebook_user = User.social_authentication(facebook_provider, facebook_uid, facebook_email)

    # registering the second using twitter
    linkedin_provider = "linkedin"
    linkedin_uid = "321"
    linkedin_email = "my@email.com"
    linkedin_user = User.social_authentication(linkedin_provider, linkedin_uid, linkedin_email)

    expect(User.count).to eq(1)
    expect(Uid.count).to eq(2)

    expect(facebook_user.persisted?).to be true
    expect(facebook_user.provider).to eq(facebook_provider)
    expect(facebook_user.uid).to eq(facebook_uid)
    expect(facebook_user.email).to eq(facebook_email)

    expect(linkedin_user.persisted?).to be true
    expect(linkedin_user.provider).to eq(linkedin_provider)
    expect(linkedin_user.uid).to eq(linkedin_uid)
    expect(linkedin_user.email).to eq(linkedin_email)

    expect(linkedin_user.uids.first.persisted?).to be true
    expect(linkedin_user.uids.first.provider).to eq(facebook_provider)
    expect(linkedin_user.uids.second.provider).to eq(linkedin_provider)
    expect(linkedin_user.uids.first.uid).to eq(facebook_uid)
    expect(linkedin_user.uids.second.uid).to eq(linkedin_uid)
    expect(linkedin_user.uids.first.user).to eq(linkedin_user)
  end

  it "should register new user since the UID is different and the email is different too" do

    # registering at first
    facebook_provider = "facebook"
    facebook_uid = "123"
    facebook_email = "my@email.com"
    facebook_user = User.social_authentication(facebook_provider, facebook_uid, facebook_email)

    # registering the second using twitter
    twitter_provider = "twitter"
    twitter_uid = "321"
    twitter_email = "321@twitter.com"
    twitter_user = User.social_authentication(twitter_provider, twitter_uid, twitter_email)

    expect(User.count).to eq(2)
    expect(Uid.count).to eq(2)

    expect(facebook_user.persisted?).to be true
    expect(facebook_user.provider).to eq(facebook_provider)
    expect(facebook_user.uid).to eq(facebook_uid)
    expect(facebook_user.email).to eq(facebook_email)

    expect(twitter_user.persisted?).to be true
    expect(twitter_user.provider).to eq(twitter_provider)
    expect(twitter_user.uid).to eq(twitter_uid)
    expect(twitter_user.email).to eq(twitter_email)

    expect(twitter_user.uids.first.persisted?).to be true
    expect(twitter_user.uids.first.provider).to eq(twitter_provider)
    expect(twitter_user.uids.first.uid).to eq(twitter_uid)
    expect(twitter_user.uids.first.user).to eq(twitter_user)

    expect(facebook_user).not_to eq(twitter_user)
  end

end
