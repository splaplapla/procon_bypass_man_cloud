class ProconBypassManVersion < ApplicationRecord
  class Client
    def self.get_version
      uri = URI.parse("https://rubygems.org/api/v1/versions/procon_bypass_man/latest.json")
      response = Net::HTTP.get_response uri
      JSON.parse(response.body)["version"]
    end
  end

  def self.fetch_latest_version
    ProconBypassManVersion.find_or_create_by(name: Client.get_version)
  end

  # idがautoincrimentを使っている前提
  def self.is_latest?(name: )
    version = ProconBypassManVersion.find_by(name: name) or return true
    ProconBypassManVersion.where("id > ?", version.id).exists?
  end
end
