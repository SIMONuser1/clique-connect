class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :business

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :business, required: false
  mount_uploader :avatar, AvatarUploader

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
