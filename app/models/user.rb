class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

# Roles allow the owner to give more specific permissions to employees with different clearance.
  enum role: [:employee, :cashier, :supervisor, :manager, :owner]
end
