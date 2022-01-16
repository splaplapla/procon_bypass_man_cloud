require 'rails_helper'

RSpec.describe Api::CreateEventForm, type: :model do
  describe 'validtion' do
    describe '#device_id' do
      context '\w-uuid' do
        it do
          form = described_class.new(event_type: :any, hostname: "foo", session_id: "foo", device_id: "m_#{SecureRandom.uuid}", body: { name: :any })
          expect(form.valid?).to eq(true)
        end
      end

      context '1文字' do
        it do
          form = described_class.new(event_type: :any, hostname: "foo", session_id: "foo", device_id: "a", body: { name: :any })
          form.valid?
          expect(form.errors.added?(:device_id, :invalid)).to eq(true)
        end
      end

      context 'uuidそのまま' do
        it do
          form = described_class.new(event_type: :any, hostname: "foo", session_id: "foo", device_id: SecureRandom.uuid, body: { name: :any })
          form.valid?
          expect(form.errors.added?(:device_id, :invalid)).to eq(true)
        end
      end
    end
  end
end
