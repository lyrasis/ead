module EAD

  class Generator

    include Component
    include Helpers::Description
    include Helpers::Header

    attr_reader :components, :ead, :flat_components

    # ead = EAD::Generator.new
    def initialize
      @ead             = EAD::Metadata.new
      @components      = {} # c01 children
      @flat_components = {} # all descendent components
      @path            = @ead
    end

    def description_path
      @ead.archdesc
    end

    def header_path
      @ead.eadheader
    end

    def to_xml
      @ead.to_ead_xml
    end

  end

end