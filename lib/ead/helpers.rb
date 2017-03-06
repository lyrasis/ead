module EAD

  module Helpers

    module ArchDesc

      def set_language(language = "English", code = "eng")
        @path.language = language
        @path.langcode = code
      end

    end

    module Component

      def title
        @path.did.unittitle.first
      end

      def set_title(title)
        @path.did.unittitle = title
      end

    end

    module Header

      def address
        @path.address
      end

      def address=(address)
        @path.address = address
      end

      def publisher
        @path.publisher
      end

      def publisher=(publisher)
        @path.publisher = publisher
      end

      def title
        @path.title.first
      end

      def title=(title)
        @path.title = title
      end

      def set_title(title, number = nil, separator = "")
        @path.title        = "#{title}#{separator}"
        @path.title_number = "#{number.to_s}" if number
      end

    end

  end

end