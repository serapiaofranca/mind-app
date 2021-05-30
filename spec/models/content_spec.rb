require 'rails_helper'

RSpec.describe Content, type: :model do
  it { should have_many(:tag_contents) }
end
