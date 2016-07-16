
And "I verify global variables initialized in env" do
  expect($applications).to be_an_instance_of(MediTAF::UI::Applications)
  expect($services).to be_an_instance_of(MediTAF::Services::ResourcesMgr)
  expect($faker).to eq(MediTAF::Utils::MediTAFFaker)
  expect($sticky).to be_an_instance_of(MediTAF::Utils::Sticky)
  expect($helpers).to eq(MIST::HelperMethods)
  expect($fix_randoms).to eq({})
end

And "I verify randomize_arg method with options" do
  expect($helpers.randomize_arg('abc<c1>').length).to eq(7)
  expect($helpers.randomize_arg('abc<c2,4>').length).to eq(7)
  expect($helpers.randomize_arg('abc<c3,8>').length).to eq(11)
  expect($helpers.randomize_arg('abc<c99,8>').length).to eq(11)
  expect($helpers.randomize_arg('abc<r1>').include? '<').to be_falsey
  expect($helpers.randomize_arg('abc<r1>').length).to eq(4)
  expect($helpers.randomize_arg('abc<r4>').length).to eq(7)
  expect($helpers.randomize_arg('abc<r8>').length).to eq(11)
  expect($helpers.randomize_arg('abc<l>').length).to eq(19)
  expect($helpers.randomize_arg('abc<s>').length).to eq(13)
  expect($helpers.randomize_arg('abc<m>').length).to eq(14)
  expect($helpers.randomize_arg('cloudadmiral+mcc_admin_user_<r3>@gmail.com ').length).to eq(41)
end
