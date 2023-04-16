# Usage:
#   UsersImporter.execute(json: File.read('./dump.json'))
class UsersImporter
  # @param [String] json
  # @return [Users]
  def self.execute(json: )
    hash = JSON.parse(json)
    hash['global'].each do |class_name, hash_list|
      klass = class_name.constantize
      case class_name
      when GameSoft.name
        hash_list.each do |hash|
          klass.find_or_create_by!(title: hash['title']) do |record|
            record.remote_macro_templates_count = hash['remote_macro_templates_count']
          end
        end
      when RemoteMacroTemplate.name
        hash_list.each do |hash|
          klass.find_or_create_by!(title: hash['title'], game_soft_id: hash['game_soft_id'], steps: hash['steps'])
        end
      when ProconBypassManVersion.name
        hash_list.each do |hash|
          klass.find_or_create_by!(name: hash['name'])
        end
      else
        Rails.logger.error '知らないクラスです'
      end
    end

    hash['users'].each do |user_id, hash|
      user_hash = hash['user']
      user = User.find_or_create_by!(email: user_hash['email']) do |user|
        user.admin = user_hash['admin']
        user.plan = user_hash['plan']
        user.password = 'dummy'
        user.password_confirmation = 'dummy'
      end
      user.update_columns(crypted_password: user_hash['crypted_password'], salt: user_hash['salt'])

      hash['devices'].each do |device_hash|
        d_hash = device_hash['device']
        user.devices.find_or_create_by!(uuid: d_hash['uuid'], unique_key: d_hash["unique_key"]) do |device|
          device.name = d_hash['name']
          device.hostname = d_hash['hostname']
          device.pbm_version = d_hash['pbm_version']
          device.enable_pbmenv = d_hash['enable_pbmenv']
        end
      end

      hash['splatoon2_sketches'].each do |splatoon2_sketch_hash|
        splatoon2_sketch = user.splatoon2_sketches.find_or_create_by!(name: splatoon2_sketch_hash['name']) do |splatoon2_sketch|
          splatoon2_sketch.encoded_image = splatoon2_sketch_hash['encoded_image']
        end
        splatoon2_sketch.binary_threshold = splatoon2_sketch_hash['binary_threshold']
        splatoon2_sketch.crop_data = splatoon2_sketch_hash['crop_data'] if splatoon2_sketch_hash['crop_data']
        splatoon2_sketch.save!
      end

      hash['saved_buttons_settings'].each do |saved_buttons_setting_hash|
        saved_buttons_setting = user.saved_buttons_settings.find_or_create_by!(content_hash: saved_buttons_setting_hash['content_hash']) do |saved_buttons_setting|
          saved_buttons_setting.content = saved_buttons_setting_hash['content']
          saved_buttons_setting.updated_at = saved_buttons_setting_hash['updated_at']
          saved_buttons_setting.created_at = saved_buttons_setting_hash['created_at']
        end
        if saved_buttons_setting_hash['public_saved_buttons_setting'] && !saved_buttons_setting.public_saved_buttons_setting
          saved_buttons_setting.create_public_saved_buttons_setting!
        end
        saved_buttons_setting.content = saved_buttons_setting_hash['content']
        saved_buttons_setting.name = saved_buttons_setting_hash['name']
        saved_buttons_setting.memo = saved_buttons_setting_hash['memo']
        saved_buttons_setting.save!
      end
    end

    true
  end
end
