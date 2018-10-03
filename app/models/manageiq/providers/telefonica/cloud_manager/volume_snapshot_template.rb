class ManageIQ::Providers::Telefonica::CloudManager::VolumeSnapshotTemplate < ManageIQ::Providers::CloudManager::Template
  # VolumeSnapshotTemplates are proxies to allow provisioning instances from volumes
  # without having to refactor the entire provisioning workflow to support types
  # other than VmOrTemplate subtypes. VolumeSnapshotTemplates are created 1-to-1 during
  # inventory refresh for each eligible snapshot.

  belongs_to :cloud_tenant

  def volume_snapshot_template?
    true
  end
end
