# == Schema Information
#
# Table name: businesses
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  time_zone  :string           default("Pacific Time (US & Canada)")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Business < ApplicationRecord
  # === audited ===
  audited

  # === relations ===
  has_many :users
  has_many :managers
  has_many :employees
  has_many :facilities
  has_many :positions
  has_many :manager_positions, -> { where(role: :manager) }, class_name: 'Position'
  has_many :employee_positions, -> { where(role: :employee) }, class_name: 'Position'
  has_many :shifts
  has_many :email_loader_results, class_name: 'EmailLoader::Result'
  has_many :audits, class_name: 'BusinessAudit'
end
