module EAD

  module Component

    # ead.add_c01({ ... })
    def add_c01(id = nil)
      c01 = Component::C01.new(@ead, id)
      @components[c01.id] = c01
      add_flat_component c01
      c01
    end

    # ead.add_c02(1, { ... })
    def add_c02(parent, id = nil)
      c02 = Component::C02.new(@ead, parent, id)
      @components[parent.id].components[c02.id] = c02
      add_flat_component c02
      c02
    end

    def add_c02_by_parent_id(parent_id, id = nil)
      parent = find_component_by_id(parent_id)
      add_c02 parent, id
    end

    # ead.add_c03(1, 1, { ... })
    def add_c03(ancestor, parent, id = nil)
      c03 = Component::C03.new(@ead, ancestor, parent, id)
      @components[ancestor.id].components[parent.id].components[c03.id] = c03
      add_flat_component c03
      c03
    end

    def add_c03_by_parent_id(parent_id, id = nil)
      parent   = find_component_by_id(parent_id)
      ancestor = find_component_by_id(parent.parent_id)
      add_c03 ancestor, parent, id
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
      include Helpers::Description

      attr_reader :components, :id, :level, :parent_id, :path, :position

      def initialize(ead, id = nil)
        @ead        = ead
        @components = {} # c02 children
        @id         = id ? id.to_s : SecureRandom.hex
        @level      = 1
        @parent_id  = nil
        @path       = nil
        @position   = nil
        
        init_tree_position(@id)
        @path = @ead.archdesc.dsc.c01(@position)
      end

      def description_path
        @path
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
      include Helpers::Description

      attr_reader :components, :id, :level, :parent_id, :path, :position

      def initialize(ead, parent, id = nil)
        @ead        = ead
        @components = {} # c03 children
        @id         = id ? id.to_s : SecureRandom.hex
        @level      = 2
        @parent_id  = parent.id
        @path       = nil
        @position   = nil

        init_tree_position(@id, parent.position)
        @path = @ead.archdesc.dsc.c01(parent.position).c02(@position)
      end

      def description_path
        @path
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
      include Helpers::Description

      attr_reader :id, :level, :parent_id, :path, :position

      def initialize(ead, ancestor, parent, id = nil)
        @ead         = ead
        @id          = id ? id.to_s : SecureRandom.hex
        @level       = 3
        @parent_id   = parent.id
        @path        = nil
        @position    = nil

        init_tree_position(@id, ancestor.position, parent.position)
        @path = @ead.archdesc.dsc.c01(ancestor.position).c02(parent.position).c03(@position)
      end

      def description_path
        @path
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