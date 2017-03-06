module EAD

  module Component

    # ead.add_c01({ ... })
    def add_c01(id = nil)
      c01 = Component::C01.new(@ead, id)
      @components << c01
      add_flat_component c01
      c01
    end

    # ead.add_c02(1, { ... })
    def add_c02(parent_idx, id = nil)
      c02 = Component::C02.new(@ead, parent_idx, id)
      @components[parent_idx].components << c02
      add_flat_component c02
      c02
    end

    def add_c02_by_parent_id(parent_id, id = nil)
      parent     = @components.find { |c| c.id == parent_id }
      parent_idx = @components.find_index(parent)
      add_c02 parent_idx, id
    end

    # ead.add_c03(1, 1, { ... })
    def add_c03(ancestor_idx, parent_idx, id = nil)
      c03 = Component::C03.new(@ead, ancestor_idx, parent_idx, id)
      @components[ancestor_idx].components[parent_idx].components << c03
      add_flat_component c03
      c03
    end

    def add_c03_by_parent_id(parent_id, id = nil)
      ancestor = @components.find { |c| c.components.find { |s| s.id == parent_id } }
      add_c03_by_ancestor ancestor, parent_id, id
    end

    def add_c03_by_ancestor_id_parent_id(ancestor_id, parent_id, id = nil)
      ancestor = @components.find { |c| c.id == ancestor_id }
      add_c03_by_ancestor ancestor, parent_id, id
    end

    def add_c03_by_ancestor(ancestor, parent_id, id = nil)
      ancestor_idx = @components.find_index(ancestor)
      parent       = ancestor.components.find { |c| c.id == parent_id }
      parent_idx   = ancestor.components.find_index(parent)
      add_c03 ancestor_idx, parent_idx, id
    end

    def find_component_by_id(id)
      @flat_components.fetch(id)
    end

    private

    def add_flat_component(component)
      if @flat_components.has_key? component.id
        raise "Cannot add duplicate component id #{component.id}: #{component} #{@flat_components[component.id]}"
      else
        @flat_components[component.id] = component
      end
    end

    class C01

      include Helpers::Component

      attr_reader :components, :id, :level, :path

      def initialize(ead, id = nil)
        @ead        = ead
        @components = [] # c02 children
        @id         = id ? id : SecureRandom.hex
        @level      = 1
        @path       = nil
        @position   = nil
        
        init_tree_position(@id)
        @path = @ead.archdesc.dsc.c01(@position)
      end

      private

      def init_tree_position(id)
        next_position = @ead.archdesc.dsc.c01.count
        if next_position == 0
          @position = 0
          @ead.archdesc.dsc.c01.id = nil
          @ead.archdesc.dsc.c01.id = id
        else
          @position = next_position
          @ead.archdesc.dsc.c01(@position).id = nil
          @ead.archdesc.dsc.c01(@position).id = id
        end
      end

    end

    class C02

      include Helpers::Component

      attr_reader :components, :id, :level, :path

      def initialize(ead, parent_idx, id = nil)
        @ead        = ead
        @components = [] # c03 children
        @id         = id ? id : SecureRandom.hex
        @level      = 2
        @path       = nil
        @position   = nil

        init_tree_position(@id, parent_idx)
        @path = @ead.archdesc.dsc.c01(parent_idx).c02(@position)
      end

      private

      def init_tree_position(id, parent_idx)
        next_position = @ead.archdesc.dsc.c01(parent_idx).c02.count
        if next_position == 0
          @position = 0
          @ead.archdesc.dsc.c01(parent_idx).c02.id = nil
          @ead.archdesc.dsc.c01(parent_idx).c02.id = id
        else
          @position = next_position
          @ead.archdesc.dsc.c01(parent_idx).c02(@position).id = nil
          @ead.archdesc.dsc.c01(parent_idx).c02(@position).id = id
        end
      end

    end

    class C03

      include Helpers::Component

      attr_reader :id, :level, :path

      def initialize(ead, ancestor_idx, parent_idx, id = nil)
        @ead      = ead
        @id       = id ? id : SecureRandom.hex
        @level    = 3
        @path     = nil
        @position = nil
        
        init_tree_position(@id, ancestor_idx, parent_idx)
        @path = @ead.archdesc.dsc.c01(ancestor_idx).c02(parent_idx).c03(@position) 
      end

      def init_tree_position(id, ancestor_idx, parent_idx)
        next_position = @ead.archdesc.dsc.c01(ancestor_idx).c02(parent_idx).c03.count
        if next_position == 0
          @position = 0
          @ead.archdesc.dsc.c01(ancestor_idx).c02(parent_idx).c03.id = nil
          @ead.archdesc.dsc.c01(ancestor_idx).c02(parent_idx).c03.id = id
        else
          @position = next_position
          @ead.archdesc.dsc.c01(ancestor_idx).c02(parent_idx).c03(@position).id = nil
          @ead.archdesc.dsc.c01(ancestor_idx).c02(parent_idx).c03(@position).id = id
        end
      end

    end

  end

end