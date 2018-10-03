module EAD

  module Helpers

    module Component

      # [ { id: "...", barcode: "...", number: "..." } ] OR
      # [ { id: "...", barcode: "...", number: "...", label_type: "...", type: "..." } ]
      def add_containers(containers = [], label_type = "mixed_materials", type = "Box", profile = nil)
        containers.each do |c|
          label   = c.has_key?(:label_type) ? c[:label_type] : label_type
          # aspace formatting gunk
          label   = "#{label} (#{c[:barcode]})" if c.has_key? :barcode
          type    = c.has_key?(:type) ? c[:type] : type
          profile = c.has_key?(:profile) ? c[:profile] : profile

          pos = description_path.did.container.count
          if pos == 0
            # initialize container
            description_path.did.container.id = nil
          end
          # initialize id b4 setting it
          description_path.did.container(pos).id        = nil
          description_path.did.container(pos).id        = c[:id].to_s
          description_path.did.container(pos).label     = label
          description_path.did.container(pos).type      = type
          description_path.did.container(pos).altrender = profile if profile
          description_path.did.send(:container, pos, c[:number].to_s)
        end
      end

      def add_physfacet(physfacet)
        pos = description_path.did.physdesc.count
        if pos == 0
          # initialize physdesc
          description_path.did.physdesc.altrender = nil
        end
        description_path.did.physdesc(pos).physfacet = nil
        description_path.did.physdesc(pos).physfacet = physfacet
      end

      def add_physfacet_date(physfacet, date)
        pos = description_path.did.physdesc.count
        if pos == 0
          # initialize physdesc
          description_path.did.physdesc.altrender = nil
        end
        description_path.did.physdesc(pos).physfacet = nil
        description_path.did.physdesc(pos).physfacet = physfacet
        description_path.did.physdesc(pos).physfacet.date = date.to_s
      end


      def add_physfacet_corpname(physfacet, corpname)
        pos = description_path.did.physdesc.count
        if pos == 0
          # initialize physdesc
          description_path.did.physdesc.altrender = nil
        end
        description_path.did.physdesc(pos).physfacet = nil
        description_path.did.physdesc(pos).physfacet = physfacet
        description_path.did.physdesc(pos).physfacet.corpname = corpname
      end

      def level=(level)
        description_path.level = level
      end

    end

    module Description

      # [ { type: "..." name: "...", source: "..." } ]
      def add_authorities(authorities = [])
        authorities.each do |a|
          pos = description_path.controlaccess.send("#{a[:type]}").count
          if pos == 0
            description_path.controlaccess.send("#{a[:type]}=", a[:name])
            description_path.controlaccess.send("#{a[:type]}").source = a[:source]
          else
            description_path.controlaccess.send(a[:type], pos).source = nil
            description_path.controlaccess.send(a[:type], pos).source = a[:source]
            description_path.controlaccess.send(a[:type], pos, a[:name])
          end
        end
      end

      def add_extent(extent, altrender = "whole", extent_altrender = "materialtype spaceoccupied")
        pos = description_path.did.physdesc.count
        if pos == 0
          # initialize physdesc
          description_path.did.physdesc.altrender = nil
        end
        description_path.did.physdesc(pos).altrender = nil
        description_path.did.physdesc(pos).altrender = altrender
        description_path.did.physdesc(pos).extent.altrender = extent_altrender
        description_path.did.physdesc(pos).extent = extent
      end

      # TODO DRY
      # [ { "Header title" => "Paragraph content" } ]
      def add_odds(odds = [], internal = true)
        odds.each do |odd|
          odd.each do |head, p|
            pos = description_path.odd.count
            if pos == 0
              # initialize odd
              description_path.odd.audience = nil
            end
            description_path.odd(pos).audience = nil
            description_path.odd(pos).audience = "internal" if internal
            description_path.odd(pos).head = head
            description_path.odd(pos).p = p
          end
        end
      end

      # [ { type: "..." name: "...", role: "...", source: "..." } ]
      def add_originations(originations = [])
        originations.each do |o|
          pos  = description_path.did.origination.count
          if pos == 0
            # initialize origination
            description_path.did.origination.label = nil
          end
          # initialize label b4 setting it
          description_path.did.origination(pos).label = nil
          description_path.did.origination(pos).label = "creator"
          description_path.did.origination(pos).send("#{o[:type]}=", o[:name])
          path = description_path.did.origination(pos).send(o[:type])
          path.role = o[:role]
          path.source = o[:source]
          path.normal = o[:normal] if o.has_key? :normal
        end
      end

      # TODO DRY
      # [ { "Header title" => "Paragraph content" } ]
      def add_related_materials(related_materials = [], internal = true)
        related_materials.each do |related_material|
          related_material.each do |head, p|
            pos = description_path.relatedmaterial.count
            if pos == 0
              # initialize relatedmaterial
              description_path.relatedmaterial.audience = nil
            end
            description_path.relatedmaterial(pos).audience = nil
            description_path.relatedmaterial(pos).audience = "internal" if internal
            description_path.relatedmaterial(pos).head = head
            description_path.relatedmaterial(pos).p = p
          end
        end
      end

      def abstract
        description_path.did.abstract.first
      end

      def abstract=(abstract)
        description_path.did.abstract = abstract
      end

      def accessrestrict
        description_path.accessrestrict.p.first
      end

      def accessrestrict=(accessrestrict)
        description_path.accessrestrict.head = "Access Restrictions"
        description_path.accessrestrict.p = accessrestrict
      end

      def arrangement
        description_path.arrangement.p.first
      end

      def arrangement=(arrangement)
        description_path.arrangement.head = "Arrangement"
        description_path.arrangement.p = arrangement
      end

      def prefercite
        description_path.prefercite.p.first
      end

      def prefercite=(prefercite)
        description_path.prefercite.head = "Preferred Citation"
        description_path.prefercite.p = prefercite
      end

      def repository
        description_path.did.repository.corpname.first
      end

      def repository=(repository)
        description_path.did.repository.corpname = repository
      end

      def scopecontent
        description_path.scopecontent.p.first
      end

      def scopecontent=(scopecontent)
        description_path.scopecontent.head = "Scope and Content"
        description_path.scopecontent.p = scopecontent
      end

      def unitdate=(date)
        pos = description_path.did.unitdate.count
        if pos == 0
          # initialize unitdate
          description_path.did.unitdate.type = nil
        end
        description_path.did.unitdate(pos).type   = nil
        description_path.did.unitdate(pos).type   = "inclusive"
        d = date.to_s
        description_path.did.unitdate(pos).normal = d
        description_path.did.send(:unitdate, pos, d)
      end

      def unitid
        description_path.did.unitid.first
      end

      def unitid=(unitid)
        description_path.did.unitid = unitid
      end

      def unittitle
        description_path.did.unittitle.first
      end

      def unittitle=(unittitle)
        description_path.did.unittitle = unittitle
      end

      def userestrict
        description_path.userestrict.p.first
      end

      def userestrict=(userestrict)
        description_path.userestrict.head = "Use Restrictions"
        description_path.userestrict.p = userestrict
      end

      def set_language(language = "English", code = "eng")
        description_path.did.langmaterial.language = language
        description_path.did.langmaterial.language.langcode = code
      end

    end

    module Header

      def address
        header_path.filedesc.publicationstmt.address.addressline
      end

      def address=(address)
        header_path.filedesc.publicationstmt.address.addressline = address
      end

      def author
        header_path.filedesc.titlestmt.author.first
      end

      def author=(author)
        header_path.filedesc.titlestmt.author = author
      end

      def descrules
        header_path.profiledesc.descrules.first
      end

      def descrules=(descrules)
        header_path.profiledesc.descrules = descrules
      end

      def eadid
        header_path.eadid.first
      end

      def eadid=(eadid)
        header_path.eadid = eadid
      end

      def note
        header_path.filedesc.notestmt.note.p.first
      end

      def publisher
        header_path.filedesc.publicationstmt.publisher.first
      end

      def publisher=(publisher)
        header_path.filedesc.publicationstmt.publisher = publisher
      end

      def title
        header_path.filedesc.titlestmt.titleproper.first
      end

      def title=(title)
        header_path.filedesc.titlestmt.titleproper = title
      end

      def set_create_date(date, message = nil)
        header_path.profiledesc.creation = message if message
        header_path.profiledesc.creation.date = date.to_s
      end

      def set_note(note, type = nil, number = nil, separator = "", number_type = nil)
        header_path.filedesc.notestmt.note.p          = "#{note}#{separator}"
        header_path.filedesc.notestmt.note.type       = type if type
        header_path.filedesc.notestmt.note.p.num      = number.to_s if number
        header_path.filedesc.notestmt.note.p.num.type = number_type if number_type
      end

      def set_title(title, number = nil, separator = "")
        header_path.filedesc.titlestmt.titleproper     = "#{title}#{separator}"
        header_path.filedesc.titlestmt.titleproper.num = "#{number.to_s}" if number
      end

      # TODO DRY
      def set_filing_title(title, number = nil, separator = "")
        header_path.filedesc.titlestmt.filing     = "#{title}#{separator}"
        header_path.filedesc.titlestmt.filing.num = "#{number.to_s}" if number
        header_path.filedesc.titlestmt.filing.audience = "internal"
      end

      # TODO DRY
      def set_formal_title(title, number = nil, separator = "")
        header_path.filedesc.titlestmt.formal     = "#{title}#{separator}"
        header_path.filedesc.titlestmt.formal.num = "#{number.to_s}" if number
      end

    end

  end

end
