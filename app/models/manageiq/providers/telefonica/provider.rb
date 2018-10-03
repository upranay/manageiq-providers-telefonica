class ManageIQ::Providers::Telefonica::Provider < ::Provider
  has_many :cloud_ems,
           :foreign_key => "provider_id",
           :class_name  => "ManageIQ::Providers::Telefonica::CloudManager",
           :dependent   => :nullify,
           :autosave    => true
  has_many :network_managers,
           :foreign_key => "provider_id",
           :class_name  => "ManageIQ::Providers::Telefonica::NetworkManager",
           :dependent   => :nullify,
           :autosave    => true

  validates :name, :presence => true, :uniqueness => true

  def destroy
    # Bypass the superclass orchestrated destroy for this Provider.
    #   In the Telefonica provider, the Provider instance is only tightly coupled
    #   to the InfraManager.  That is, when the InfraManager is created, then
    #   the Provider is created and vice-versa, when the InfraManager is
    #   destroyed, we need to destroy the Provider.  The CloudManager objects
    #   associated to that Provider should *not* be destroyed, and only need to
    #   be nullified.  For other Providers, the Provider instance is what is
    #   destroyed, so by default the orchestrated destroy destroys all of its
    #   managers, but we here don't want that to happen, so we are bypassing.
    self.class.instance_method(:destroy).super_method.super_method.bind(self).call
  end
end
