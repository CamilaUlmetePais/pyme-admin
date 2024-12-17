# User-created reminders of tasks that need to be done by a certain date, like client orders and supply purchases. 
#
# @modelAttribute title [string] a summary of what needs to be done.
# @modelAttribute text [text] a more detailed explanation of the task with additional information.
# @modelAttribute done [boolean] <tt>true</tt> if the task has been completed, <tt>false</tt> if it hasn't. 
# @modelAttribute due_date [datetime] the date and time the task is due. 
# @validation title must be present
# @validation due_date must be present and cannot be in the past at the moment of creation. It can, however, be updated once it's in the past. 
class Reminder < ApplicationRecord
	validates :title, :due_date, presence: true
  validate :due_date_cannot_be_in_the_past, on: :create
  
  # Custom validation to check that due_date is not in the past
  def due_date_cannot_be_in_the_past
    errors.add(:due_date, I18n.t('activerecord.errors.messages.due_date')) if
      due_date < DateTime.now
  end
end