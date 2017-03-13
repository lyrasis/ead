module EAD

  class Generator

    include Component
    include Helpers::ArchDesc
    include Helpers::Description
    include Helpers::Header

    attr_reader :components, :ead, :flat_components

    # ead = EAD::Generator.new
    def initialize
      @ead             = EAD::Metadata.new
      @components      = [] # c01 children
      @flat_components = {} # all descendent components
      @path            = @ead
    end

    def to_xml
      @ead.to_ead_xml
    end

  end

end