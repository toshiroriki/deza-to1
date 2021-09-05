class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :cart_items
  has_many :addresses
  has_many :orders
devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number, presence: true

  enum is_active: {Available: true, Invalid: false}
    #有効会員はtrue、退会済み会員はfalse

    def active_for_authentication?
        super && (self.is_active === "Available")
    end
    #is_activeが有効の場合は有効会員(ログイン可能)


end
