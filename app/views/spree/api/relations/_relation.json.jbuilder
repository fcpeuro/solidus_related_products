# frozen_string_literal: true

json.call(
  relation,
  :id, :relation_type_id,
  :relatable_id, :relatable_type,
  :related_to_id, :related_to_type,
  :discount_amount, :description, :position,
  :created_at, :updated_at
)
