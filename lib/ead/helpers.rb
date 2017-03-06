module EAD

  module Helpers

    module Component

      def title
        @path.did.unittitle.first
      end

      def set_title(title)
        @path.did.unittitle = title
      end

    end

    module Header

      def title
        @path.title.first
      end

      def set_title(title, number = nil, separator = "")
        @path.title        = "#{title}#{separator}"
        @path.title_number = "#{number.to_s}" if number
      end

    end

  end

end