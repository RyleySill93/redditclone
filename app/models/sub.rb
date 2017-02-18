# == Schema Information
#
# Table name: subs
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text
#  moderator_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Sub < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :description, :moderator, presence: true
  #todo write moderator method
  belongs_to :moderator,
    class_name: :User

  has_many :posts,
    through: :post_subs,
    source: :post

  has_many :post_subs,
    primary_key: :id,
    foreign_key: :sub_id,
    class_name: :PostSub
end
