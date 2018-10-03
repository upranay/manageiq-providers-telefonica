class ManageIQ::Providers::Telefonica::Inventory::Collector::StorageManager::CinderManager < ManageIQ::Providers::Telefonica::Inventory::Collector
  include ManageIQ::Providers::Telefonica::Inventory::Collector::HelperMethods

  def cloud_volumes
    return @cloud_volumes if @cloud_volumes.any?
    @cloud_volumes = cinder_service.handled_list(:volumes, {}, cinder_admin?)
  end

  def cloud_volume_snapshots
    return @cloud_volume_snapshots if @cloud_volume_snapshots.any?
    @cloud_volume_snapshots = cinder_service.handled_list(:list_snapshots_detailed, {:__request_body_index => "snapshots"}, cinder_admin?)
  end

  def cloud_volume_backups
    return @cloud_volume_backups if @cloud_volume_backups.any?
    @cloud_volume_backups = cinder_service.handled_list(:list_backups_detailed, {:__request_body_index => "backups"}, cinder_admin?)
  end

  def cloud_volume_types
    return @cloud_volume_types if @cloud_volume_types.any?
    @cloud_volume_types = cinder_service.handled_list(:volume_types, {}, cinder_admin?)
  end
end
