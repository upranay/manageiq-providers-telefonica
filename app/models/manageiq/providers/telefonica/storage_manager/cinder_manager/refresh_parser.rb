module ManageIQ::Providers
  class Telefonica::StorageManager::CinderManager::RefreshParser < ManageIQ::Providers::StorageManager::CinderManager::RefreshParser

    def self.ems_inv_to_hashes(ems, options = nil)
      new(ems, options).ems_inv_to_hashes
    end

    def initialize(ems, options = nil)
      @ems               = ems
      @connection        = ems.connect
      @options           = options || {}
      @data              = {}
      @data_index        = {}

      @cinder_service    = ems.parent_manager&.cinder_service
    end

    def ems_inv_to_hashes
      get_volumes
    end

    def get_volumes
      process_collection(volumes, :cloud_volumes) { |volume| parse_volume(volume) }
    end

    def parse_volume(volume)
      uid = volume.id
      new_result = {
          :ems_ref       => uid,
          :type          => "ManageIQ::Providers::Telefonica::CloudManager::CloudVolume",
          :name          => volume_name(volume).blank? ? volume.id : volume_name(volume),
          :status        => volume.status,
          :bootable      => volume.attributes['bootable'],
          :description   => volume_description(volume),
          :volume_type   => volume.volume_type,
          :snapshot_uid  => volume.snapshot_id,
          :size          => volume.size.to_i.gigabytes,
          # Temporarily add the object from the API to the hash - for the cross-linkers.
          :api_obj       => volume
      }
      return uid, new_result
    end

  end
end
