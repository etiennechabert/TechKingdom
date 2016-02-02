json.array!(@pedagos) do |pedago|
  json.extract! pedago, :id
  json.url pedago_url(pedago, format: :json)
end
