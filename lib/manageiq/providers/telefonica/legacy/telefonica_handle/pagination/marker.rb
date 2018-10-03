require 'manageiq/providers/telefonica/legacy/telefonica_handle/pagination/base'

module TelefonicaHandle
  module Pagination
    class Marker < TelefonicaHandle::Pagination::Base
      def list
        all_objects = objects_on_page = call_list_method(@collection_type, @options, @method)

        while more_pages?(objects_on_page)
          last_page_count = objects_on_page.length
          objects_on_page = call_list_method(@collection_type,
                                             @options,
                                             @method,
                                             :marker => marker(objects_on_page),
                                             :limit  => @service.default_pagination_limit)
          break if pagination_break?(all_objects, objects_on_page)
          all_objects.concat(objects_on_page)
          # Break after adding this page if it contained less elements than the previous page.
          # having less elements should indicate that this is the last page in the set.
          # This is a sanity test to prevent timing-related looping or repetition
          break if objects_on_page.length < last_page_count
        end

        all_objects
      end

      private

      def more_pages?(objects_on_page)
        marker(objects_on_page) && @service.more_pages?(objects_on_page)
      end

      def marker(objects_on_page)
        objects_on_page.try(:last).try(:identity)
      end

      def pagination_break?(all_objects, objects_on_page)
        # Test if the whole set of records isn't already present, if it is, break the pagination.
        # E.g. Neutron can have disabled pagination like this, then it just returns the same result and pagination
        # would loop forever.
        all_objects.blank? || objects_on_page.blank? || repeated_objects?(all_objects, objects_on_page)
      end

      def repeated_objects?(all_objects, objects_on_page)
        objects_on_page.try(:last).try(:identity) == all_objects.try(:last).try(:identity)
      end
    end
  end
end
