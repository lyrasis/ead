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
            t.author
            t.titleproper {
              t.num
            }
            # titleproper options with type attribute
            t.formal(path: "titleproper", attributes: { type: "formal" }) {
              t.num
            }
            t.filing(path: "titleproper", attributes: { type: "filing" }) {
              t.audience(path: { attribute: "audience" })
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

          t.notestmt {
            t.note {
              t.type(path: { attribute: "type" })
              t.p_ {
                t.num {
                  t.type(path: { attribute: "type" })
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

          t.repository {
            t.corpname
          }

          t.abstract
          t.unitid
          t.unittitle
          t.unitdate {
            t.normal(path: { attribute: 'normal' })
            t.type(path: { attribute: 'type' })
          }

          t.origination {
            t.label(path: { attribute: 'label' })
            t.persname {
              t.role(path: { attribute: 'role' })
              t.source(path: { attribute: 'source' })
              t.normal(path: { attribute: 'normal' })
            }
            t.corpname {
              t.role(path: { attribute: 'role' })
              t.source(path: { attribute: 'source' })
            }
          }

          t.physdesc {
            t.altrender(path: { attribute: 'altrender' })
            t.extent {
              t.altrender(path: { attribute: 'altrender' })
            }
          }
        }

        t.accessrestrict {
          t.audience(path: { attribute: 'audience' })
          t.head
          t.p_
        }

        t.arrangement {
          t.audience(path: { attribute: 'audience' })
          t.head
          t.p_
        }

        t.bioghist {
          t.audience(path: { attribute: 'audience' })
          t.head
          t.p_
        }

        t.odd {
          t.audience(path: { attribute: 'audience' })
          t.head
          t.p_
        }

        t.prefercite {
          t.audience(path: { attribute: 'audience' })
          t.head
          t.p_
        }

        t.processinfo {
          t.audience(path: { attribute: 'audience' })
          t.head
          t.p_
        }

        t.relatedmaterial {
          t.audience(path: { attribute: 'audience' })
          t.head
          t.p_
        }

        t.scopecontent {
          t.audience(path: { attribute: 'audience' })
          t.encodinganalog(path: { attribute: 'encodinganalog' })
          t.head
          t.p_
        }

        t.userestrict {
          t.audience(path: { attribute: 'audience' })
          t.head
          t.p_
        }

        t.controlaccess {
          t.subject {
            t.source(path: { attribute: 'source' })
          }
          t.geogname {
            t.source(path: { attribute: 'source' })
          }
          t.genreform {
            t.source(path: { attribute: 'source' })
          }
          t.persname {
            t.source(path: { attribute: 'source' })
          }
          t.corpname {
            t.source(path: { attribute: 'source' })
          }
        }

        # dsc
        t.dsc {
          # c01
          t.c01 {
            t.id(path: { attribute: 'id' })
            t.level(path: { attribute: 'level' })
            t.otherlevel(path: { attribute: 'otherlevel' })
            t.did {
              t.abstract
              t.unittitle
              t.unitdate {
                t.normal(path: { attribute: 'normal' })
                t.type(path: { attribute: 'type' })
              }

              t.origination {
                t.label(path: { attribute: 'label' })
                t.persname {
                  t.role(path: { attribute: 'role' })
                  t.source(path: { attribute: 'source' })
                  t.normal(path: { attribute: 'normal' })
                }
                t.corpname {
                  t.role(path: { attribute: 'role' })
                  t.source(path: { attribute: 'source' })
                }
              }

              t.physdesc {
                t.altrender(path: { attribute: 'altrender' })
                t.extent {
                  t.altrender(path: { attribute: 'altrender' })
                }
                t.physfacet {
                  t.id(path: { attribute: 'id' })
                  t.corpname
                  t.date
                }
              }
              t.container {
                t.id(path: { attribute: 'id' })
                t.label(path: { attribute: 'label' })
                t.type(path: { attribute: 'type' })
                t.altrender(path: { attribute: 'altrender' })
              }
            }

            t.prefercite {
              t.audience(path: { attribute: 'audience' })
              t.head
              t.p_
            }

            t.accessrestrict {
              t.audience(path: { attribute: 'audience' })
              t.head
              t.p_
            }

            t.userestrict {
              t.audience(path: { attribute: 'audience' })
              t.head
              t.p_
            }

            t.bioghist {
              t.audience(path: { attribute: 'audience' })
              t.head
              t.p_
            }

            t.controlaccess {
              t.subject {
                t.source(path: { attribute: 'source' })
              }
              t.geogname {
                t.source(path: { attribute: 'source' })
              }
              t.genreform {
                t.source(path: { attribute: 'source' })
              }
              t.persname {
                t.source(path: { attribute: 'source' })
              }
              t.corpname {
                t.source(path: { attribute: 'source' })
              }
            }

            # c02 (same as c01)
            t.c02 {
              t.id(path: { attribute: 'id' })
              t.level(path: { attribute: 'level' })
              t.otherlevel(path: { attribute: 'otherlevel' })
              t.did {
                t.abstract
                t.unittitle

                t.unitdate {
                  t.normal(path: { attribute: 'normal' })
                  t.type(path: { attribute: 'type' })
                }

                t.origination {
                  t.label(path: { attribute: 'label' })
                  t.persname {
                    t.role(path: { attribute: 'role' })
                    t.source(path: { attribute: 'source' })
                    t.normal(path: { attribute: 'normal' })
                  }
                  t.corpname {
                    t.role(path: { attribute: 'role' })
                    t.source(path: { attribute: 'source' })
                  }
                }

                t.physdesc {
                  t.altrender(path: { attribute: 'altrender' })
                  t.extent {
                    t.altrender(path: { attribute: 'altrender' })
                  }
                  t.physfacet {
                    t.id(path: { attribute: 'id' })
                    t.corpname
                    t.date
                  }
                }
                t.container {
                  t.id(path: { attribute: 'id' })
                  t.label(path: { attribute: 'label' })
                  t.type(path: { attribute: 'type' })
                  t.altrender(path: { attribute: 'altrender' })
                }
              }

              t.prefercite {
                t.audience(path: { attribute: 'audience' })
                t.head
                t.p_
              }

              t.accessrestrict {
                t.audience(path: { attribute: 'audience' })
                t.head
                t.p_
              }

              t.userestrict {
                t.audience(path: { attribute: 'audience' })
                t.head
                t.p_
              }

              t.bioghist {
                t.audience(path: { attribute: 'audience' })
                t.head
                t.p_
              }

              t.controlaccess {
                t.subject {
                  t.source(path: { attribute: 'source' })
                }
                t.geogname {
                  t.source(path: { attribute: 'source' })
                }
                t.genreform {
                  t.source(path: { attribute: 'source' })
                }
                t.persname {
                  t.source(path: { attribute: 'source' })
                }
                t.corpname {
                  t.source(path: { attribute: 'source' })
                }
              }

              # c03 (same as c01)
              t.c03 {
                t.id(path: { attribute: 'id' })
                t.level(path: { attribute: 'level' })
                t.otherlevel(path: { attribute: 'otherlevel' })
                t.did {
                  t.abstract
                  t.unittitle

                  t.unitdate {
                    t.normal(path: { attribute: 'normal' })
                    t.type(path: { attribute: 'type' })
                  }

                  t.origination {
                    t.label(path: { attribute: 'label' })
                    t.persname {
                      t.role(path: { attribute: 'role' })
                      t.source(path: { attribute: 'source' })
                      t.normal(path: { attribute: 'normal' })
                    }
                    t.corpname {
                      t.role(path: { attribute: 'role' })
                      t.source(path: { attribute: 'source' })
                    }
                  }

                  t.physdesc {
                    t.altrender(path: { attribute: 'altrender' })
                    t.extent {
                      t.altrender(path: { attribute: 'altrender' })
                    }
                    t.physfacet {
                      t.id(path: { attribute: 'id' })
                      t.corpname
                      t.date
                    }
                  }
                  t.container {
                    t.id(path: { attribute: 'id' })
                    t.label(path: { attribute: 'label' })
                    t.type(path: { attribute: 'type' })
                    t.altrender(path: { attribute: 'altrender' })
                  }
                }

              } # END c03
            } # END c02
          } # END c01
        } # END dsc
      }
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
      ', nil, "UTF-8")
    end

  end

end
