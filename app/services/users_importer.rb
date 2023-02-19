# Usage:
#   UsersImporter.execute(json: File.read('./dump.json'))
class UsersImporter
  # @param [String] json
  # @return [Users]
  def self.execute(json: )
    hash = JSON.parse(json)
    global = hash['global']
  end
end
