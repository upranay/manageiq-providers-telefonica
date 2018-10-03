module TelefonicaHandle
  class BaremetalDelegate < DelegateClass(Fog::Baremetal::Telefonica)
    include TelefonicaHandle::HandledList
    include Vmdb::Logging

    SERVICE_NAME = "Baremetal"

    attr_reader :name

    def initialize(dobj, os_handle, name)
      super(dobj)
      @os_handle = os_handle
      @name      = name
    end
  end
end
