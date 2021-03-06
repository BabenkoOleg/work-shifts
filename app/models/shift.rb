# == Schema Information
#
# Table name: shifts
#
#  id          :bigint(8)        not null, primary key
#  end_time    :string
#  name        :string
#  start_time  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  business_id :bigint(8)
#  facility_id :bigint(8)
#  position_id :bigint(8)
#
# Indexes
#
#  index_shifts_on_business_id  (business_id)
#  index_shifts_on_facility_id  (facility_id)
#  index_shifts_on_position_id  (position_id)
#

class Shift < ApplicationRecord
  # === constants ===
  TIME_FORMAT = /\A(0[0-9]|1[0-2]):[0-5][0-9]\s[ap]m\z/

  # === audited ===
  audited

  # === relations ===
  belongs_to :business
  belongs_to :facility
  belongs_to :position, class_name: 'Position::Employee'

  # === validations ===
  validates_presence_of :name, :start_time, :end_time
  validates :start_time, format: { with: TIME_FORMAT }
  validates :end_time, format: { with: TIME_FORMAT }

  # === callbacks ===
  before_validation :normalize_time

  private

  def normalize_time
    self.start_time = Time.parse(start_time).strftime('%I:%M %P') rescue nil
    self.end_time = Time.parse(end_time).strftime('%I:%M %P') rescue nil
  end
end
