json.array!(@asteks) do |astek|
  json.extract! astek, :id
  json.url astek_url(astek, format: :json)
end
