# frozen_string_literal: true

json.relations(@relations) do |relation|
  json.partial! 'spree/api/relations/relation', relation: relation
end
json.partial! 'spree/api/shared/pagination', pagination: @relations
