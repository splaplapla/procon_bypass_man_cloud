class PbmSessionsIdIsFromStringToBigint < ActiveRecord::Migration[6.1]
  def up
    change_column :events, :pbm_session_id, :bigint
  end

  def down
    change_column :events, :pbm_session_id, :string
  end
end
