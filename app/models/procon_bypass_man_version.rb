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
  def self.latest(name: )
    latest_name = ProconBypassManVersion.last&.name
    return {} unless latest_name
    { is_latest: Gem::Version.new(latest_name) <= Gem::Version.new(name),
      latest_version: latest_name,
    }
  end
end
