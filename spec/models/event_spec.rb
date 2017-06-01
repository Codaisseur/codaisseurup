require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "validations" do
    it "is invalid without a name" do
      event = Event.new(name: "")
      event.valid?
      expect(event.errors).to have_key(:name)
    end

    it "is invalid without a description" do
      event = Event.new(description: "")
      event.valid?
      expect(event.errors).to have_key(:description)
    end

    it "is invalid with a description longer than 500 characters" do
      event = Event.new(description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta mi nec urna facilisis, nec porttitor felis sagittis. In porttitor tellus vel nibh fermentum, at ornare tellus ultrices. Pellentesque condimentum aliquam sollicitudin. Mauris posuere lectus vel sagittis luctus. Quisque volutpat tellus orci. Mauris porttitor ipsum consequat elit sollicitudin, eget lacinia tortor maximus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.Maecenas nec sapien id dolor facilisis sodales vitae quis sapien. Nulla fringilla elit dolor, sit amet cras amet.")
      event.valid?
      expect(event.errors).to have_key(:description)
    end
  end

  describe "#bargain?" do
    let(:bargain_event) { create :event, price: 20 }
    let(:non_bargain_event) { create :event, price: 200 }

    it "returns true if the price is smaller than 30 EUR" do
      expect(bargain_event.bargain?).to eq(true)
      expect(non_bargain_event.bargain?).to eq(false)
    end
  end

  describe ".order_by_price" do
    let!(:event1) { create :event, price: 100 }
    let!(:event2) { create :event, price: 200 }
    let!(:event3) { create :event, price: 300 }

    it "returns a sorted array of events by prices" do
      expect(Event.order_by_price).to match_array [event1, event2, event3]
    end
  end

  describe "association with user" do
    let(:user) { create :user }

    it "belongs to a user" do
      event = user.events.new(name: "Weekly football match")

      expect(event.user).to eq(user)
    end
  end

  describe "association with category" do
    let(:event) { create :event }

    let(:category1) { create :category, name: "Bright", events: [event] }
    let(:category2) { create :category, name: "Clean lines", events: [event] }
    let(:category3) { create :category, name: "A Man's Touch", events: [event] }

    it "has categorys" do
      expect(event.categories).to include(category1)
      expect(event.categories).to include(category2)
      expect(event.categories).to include(category3)
    end
  end

  describe "association with registration" do
    let(:guest_user) { create :user, email: "guest@user.com" }
    let(:host_user) { create :user, email: "host@user.com" }

    let!(:event) { create :event, user: host_user }
    let!(:registration) { create :registration, event: event, user: guest_user }

    it "has guests" do
      expect(event.guests).to include(guest_user)
    end
  end

  describe ".by_name returns events ordered by their name in alphabetical order" do
    let!(:b_event) { create :event, name: "Bs" }
    let!(:c_event) { create :event, name: "Cmon" }
    let!(:a_event) { create :event, name: "Aha" }

    it { expect(Event.by_name.to_a).to eq [a_event, b_event, c_event] }
  end

  describe ".published returns only published events" do
    let!(:pub_events) { create_list :event, 3, active: true }
    let!(:unpub_events) { create_list :event, 2, active: false }

    it { expect(Event.published).not_to match_array unpub_events }
    it { expect(Event.published).to match_array pub_events }
  end

  describe "date magic" do
    let!(:long_event) { create :event, starts_at: "2017-06-01", ends_at: "2017-06-04" }
    let!(:short_event) { create :event, starts_at: "2017-06-02", ends_at: "2017-06-02" }

    let(:june1) { Date.parse("2017-06-01") }
    let(:june2) { Date.parse("2017-06-02") }
    let(:june3) { Date.parse("2017-06-03") }
    let(:june4) { Date.parse("2017-06-04") }
    let(:june5) { Date.parse("2017-06-05") }
    let(:last_year) { Date.parse("2016-06-03") }
    let(:crazy_time) { DateTime.parse("2017-06-02 11:45:59") }

    describe ".on_date returns events planned on that date" do
      it { expect(Event.on_date(june1)).to include(long_event) }
      it { expect(Event.on_date(june1)).not_to include(short_event) }
      it { expect(Event.on_date(june2)).to include(long_event) }
      it { expect(Event.on_date(june2)).to include(short_event) }
      it { expect(Event.on_date(june3)).to include(long_event) }
      it { expect(Event.on_date(june3)).not_to include(short_event) }
      it { expect(Event.on_date(june4)).to include(long_event) }
      it { expect(Event.on_date(june4)).not_to include(short_event) }
      it { expect(Event.on_date(june5)).not_to include(long_event) }
      it { expect(Event.on_date(june5)).not_to include(short_event) }
      it { expect(Event.on_date(last_year)).not_to include(long_event) }
      it { expect(Event.on_date(last_year)).not_to include(short_event) }
    end

    describe ".starts_on returns events on that date" do
      it { expect(Event.starts_on(june1)).to include(long_event) }
      it { expect(Event.starts_on(june1)).not_to include(short_event) }
      it { expect(Event.starts_on(crazy_time)).to include(short_event) }
    end
  end
end
