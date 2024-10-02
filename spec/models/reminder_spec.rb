require 'rails_helper'

RSpec.describe Reminder, type: :model do
  subject { FactoryBot.create(:reminder) }

  describe "validations" do
    context "creating or updating a reminder" do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:due_date) }
    end

    context "creating a new reminder" do
      it "must have a due date set in the future" do
        expect { subject }.to_not raise_error
      end
      it "should raise an exception if due date is set in the past" do
        expect { 
          FactoryBot.create(:reminder, due_date: DateTime.now - 1.days) 
        }.to raise_exception(ActiveRecord::RecordInvalid)
      end
    end
  end
end