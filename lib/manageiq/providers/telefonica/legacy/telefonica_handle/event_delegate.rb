module TelefonicaHandle
  class EventDelegate < DelegateClass(Fog::Event::Telefonica)
    include TelefonicaHandle::HandledList
    include Vmdb::Logging

    SERVICE_NAME = "Event".freeze

    attr_reader :name

    def initialize(dobj, os_handle, name)
      super(dobj)
      @os_handle = os_handle
      @name      = name
    end
  end
end
