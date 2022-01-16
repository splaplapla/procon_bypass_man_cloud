class PbmSessionsIdIsFromStringToBigint < ActiveRecord::Migration[6.1]
  def up
    if Rails.env.production?
      change_column :events, :pbm_session_id, 'bigint USING CAST(column_name AS bigint)'
    else
      change_column :events, :pbm_session_id, :bigint
    end
  end

  def down
    change_column :events, :pbm_session_id, :string
  end
end
