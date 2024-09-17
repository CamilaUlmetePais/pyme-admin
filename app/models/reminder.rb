class Reminder < ApplicationRecord
	validates :title, :due_date, presence: true
  validate :due_date_cannot_be_in_the_past, on: create

  scope :last_60_days, -> { where('created_at >= ?', 60.days.ago) }

  def due_date_cannot_be_in_the_past
    errors.add(:due_date, I18n.t('activerecord.errors.messages.due_date')) if
      !due_date.blank? and due_date < DateTime.now
  end
end