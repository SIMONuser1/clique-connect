class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :business
  has_many :notes, foreign_key: :author_id

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :business, required: false
  mount_uploader :avatar, AvatarUploader

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
