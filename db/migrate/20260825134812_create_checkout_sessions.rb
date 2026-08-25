class CreateCheckoutSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :checkout_sessions do |t|
      t.references :order, null: false, foreign_key: true
      t.string :stripe_session_id, null: false
      t.string :status, default: "pending"
      t.string :payment_intent_id
      t.timestamps
    end

    add_index :checkout_sessions, :stripe_session_id, unique: true
  end
end
