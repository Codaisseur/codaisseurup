require 'rails_helper'

RSpec.describe Registration, type: :model do
  describe "#set_tatus" do
    let(:registration) { create :registration, event: event }

    context "free event" do
      let(:event) { create :event, price: 0.00 }

      it "sets the status to confirmed" do
        expect(registration.status).to eq("confirmed")
      end
    end

    context "non-free event" do
      let(:event) { create :event, price: 10.00 }

      it "sets the status to confirmed" do
        expect(registration.status).to eq("pending")
      end
    end
  end

  describe "#set_total_price" do
    let(:registration) { create :registration, event: event, guests_count: 2 }
    let(:event) { create :event, price: 10.00 }

    it "sets the total price taking into account the number of guests" do
      expect(registration.price).to eq(20.00)
    end
  end
end
