# == Schema Information
#
# Table name: invitations
#
#  id          :bigint(8)        not null, primary key
#  email       :string
#  role        :integer          not null
#  status      :integer          default("pending")
#  token       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  business_id :bigint(8)
#  manager_id  :bigint(8)
#  position_id :bigint(8)
#
# Indexes
#
#  index_invitations_on_business_id  (business_id)
#  index_invitations_on_email        (email)
#  index_invitations_on_manager_id   (manager_id)
#  index_invitations_on_position_id  (position_id)
#

class Invitation < ApplicationRecord
  # === relations ===
  belongs_to :business
  belongs_to :position
  belongs_to :manager, class_name: 'User', foreign_key: :manager_id
  has_and_belongs_to_many :allowed_facilities,
                          class_name: 'Facility',
                          join_table: :facilities_invitation

  # === validations ===
  validates_presence_of :email, :token
  validates_format_of :email, with: /\A[^@\s]+@[^@\s]+\z/

  # === callbacks ===
  before_validation :set_token, on: [:create]

  # === enums ===
  enum role: %i[employee manager]
  enum status: %i[pending received]

  # === class methods ===
  class << self
    def generate_token
      self.token = SecureRandom.urlsafe_base64
      generate_token if ModelName.exists?(token: self.token)
    end
  end

  # === instance methods ===
  def set_token
    self.token = SecureRandom.urlsafe_base64(64, false)
    set_token if Invitation.exists?(token: token)
  end
end
