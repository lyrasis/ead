module EAD

  module Helpers

    module ArchDesc

      def add_authorities(authorities = [])
        authorities.each do |a|
          pos = @ead.archdesc.controlaccess.send("#{a[:type]}").count
          if pos == 0
            @ead.archdesc.controlaccess.send("#{a[:type]}=", a[:name])
            @ead.archdesc.controlaccess.send("#{a[:type]}").source = a[:source]
          else
            @ead.archdesc.controlaccess.send(a[:type], pos).source = nil
            @ead.archdesc.controlaccess.send(a[:type], pos).source = a[:source]
            @ead.archdesc.controlaccess.send(a[:type], pos, a[:name])
          end
        end
      end

      # TODO DRY
      def add_odds(odds = [])
        odds.each do |odd|
          odd.each do |head, p|
            pos = @ead.archdesc.odd.count
            if pos == 0
              # initialize odd
              @ead.archdesc.odd.audience = nil
            end
            @ead.archdesc.odd(pos).audience = nil
            @ead.archdesc.odd(pos).audience = "internal"
            @ead.archdesc.odd(pos).head = head
            @ead.archdesc.odd(pos).p = p
          end
        end
      end

      def add_originations(originations = [])
        originations.each do |o|
          pos  = @ead.archdesc.did.origination.count
          if pos == 0
            # initialize origination
            @ead.archdesc.did.origination.label = nil
          end
          # initialize label b4 setting it
          @ead.archdesc.did.origination(pos).label = nil
          @ead.archdesc.did.origination(pos).label = "creator"
          @ead.archdesc.did.origination(pos).send("#{o[:type]}=", o[:name])
          path = @ead.archdesc.did.origination(pos).send(o[:type])
          path.role = o[:role]
          path.source = o[:source]
        end
      end

      # TODO DRY
      def add_related_materials(related_materials = [])
        related_materials.each do |related_material|
          related_material.each do |head, p|
            pos = @ead.archdesc.relatedmaterial.count
            if pos == 0
              # initialize relatedmaterial
              @ead.archdesc.relatedmaterial.audience = nil
            end
            @ead.archdesc.relatedmaterial(pos).audience = nil
            @ead.archdesc.relatedmaterial(pos).audience = "internal"
            @ead.archdesc.relatedmaterial(pos).head = head
            @ead.archdesc.relatedmaterial(pos).p = p
          end
        end
      end

      def prefercite
        @ead.archdesc.prefercite.p.first
      end

      def prefercite=(prefercite)
        @ead.archdesc.prefercite.head = "Preferred Citation"
        @ead.archdesc.prefercite.p = prefercite
      end

      def repository
        @path.repository.first
      end

      def repository=(repository)
        @path.repository = repository
      end

      def set_language(language = "English", code = "eng")
        @path.language = language
        @path.langcode = code
      end

      def unitid
        @path.unitid.first
      end

      def unitid=(unitid)
        @path.unitid = unitid
      end

      def unittitle
        @path.unittitle.first
      end

      def unittitle=(unittitle)
        @path.unittitle = unittitle
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