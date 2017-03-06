module EAD

  class Metadata

    # cleanup attributes (_ to - for EAD output)
    @@reformat_attrs = [
      'xlink_href',
      'xlink_show',
      'xlink_title',
      'xlink_type',
    ]

    include OM::XML::Document

    set_terminology do |t|
      t.root(
        path: "ead",
        xmlns: "urn:isbn:1-931666-22-9",
        "xmlns:xlink" => "http://www.w3.org/1999/xlink",
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" => "urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
      )
      
      # eadheader
      t.eadheader(attributes: {
        countryencoding: "iso3166-1",
        dateencoding: "iso8601",
        langencoding: "iso639-2b",
        repositoryencoding: "iso15511",
      }) {
        t.eadid

        t.filedesc {
          t.titlestmt {
            t.titleproper {
              t.num
            }
          }

          t.publicationstmt {
            t.publisher
            t.address {
              t.addressline {
                t.extptr {
                  t.xlink_href(path: { attribute: 'xlink_href' })
                  t.xlink_show(path: { attribute: 'xlink_show' })
                  t.xlink_title(path: { attribute: 'xlink_title' })
                  t.xlink_type(path: { attribute: 'xlink_type' })
                }
              }
            }
          }
        }

        t.profiledesc {
          t.creation_ {
            t.date_
          }
          t.descrules
        }
      }

      # archdesc
      t.archdesc(attributes: { level: "collection" }) {
        t.did {
          t.langmaterial {
            t.language {
              t.langcode(path: { attribute: 'langcode' })
            }
          }
        }

        # dsc
        t.dsc {
          # c01
          t.c01 {
            t.id(path: { attribute: 'id' })
            t.did {
              t.unittitle
              t.physdesc {
                t.altrender(path: { attribute: 'altrender' })
                t.extent {
                  t.altrender(path: { attribute: 'altrender' })
                }
              }
            }

            # c02 (same as c01)
            t.c02 {
              t.id(path: { attribute: 'id' })
              t.did {
                t.unittitle
                t.physdesc {
                  t.altrender(path: { attribute: 'altrender' })
                  t.extent {
                    t.altrender(path: { attribute: 'altrender' })
                  }
                }
              }

              # c03 (same as c01)
              t.c03 {
                t.id(path: { attribute: 'id' })
                t.did {
                  t.unittitle
                  t.physdesc {
                    t.altrender(path: { attribute: 'altrender' })
                    t.extent {
                      t.altrender(path: { attribute: 'altrender' })
                    }
                  }
                }

              }              
            }
          }
        }
      }

      t.title(proxy: [:eadheader, :filedesc, :titlestmt, :titleproper])
      t.title_number(proxy: [:eadheader, :filedesc, :titlestmt, :titleproper, :num])
      t.publisher(proxy: [:eadheader, :filedesc, :publicationstmt, :publisher])
      t.address(proxy: [:eadheader, :filedesc, :publicationstmt, :address, :addressline])
    end

    def to_ead_xml
      xml = to_xml.to_s
      @@reformat_attrs.each do |attribute|
        xml = xml.gsub(attribute, attribute.gsub('_', ':'))
      end
      xml
    end

    def self.xml_template
      Nokogiri::XML.parse('
        <ead
          xmlns="urn:isbn:1-931666-22-9"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
        />
      ')
    end

  end

end