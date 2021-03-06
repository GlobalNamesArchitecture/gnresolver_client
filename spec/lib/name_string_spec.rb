# frozen_string_literal: true

describe GnresolverClient::NameStrings do
  describe ".uuid" do
    let(:res) { subject.uuid("00000983-28b3-54c3-a858-e03121fa535d") }

    it "finds record by name uuid" do
      expect(res.keys.sort).to eq(
        %i(data page perPage).sort
      )
      expect(res[:data].first[:results].first.keys.sort).to eq(
        %i(canonicalName canonicalNameUuid classificationPath
           classificationPathIds classificationPathRanks dataSourceId
           dataSourceTitle globalId localId matchType nameString
           nameStringUuid prescore surrogate taxonId vernaculars)
      )
      expect(res[:data].first[:results].first[:canonicalNameUuid]).
        to eq("7ce58a7d-d3dd-5108-b490-d42c9915f45f")
    end

    it "finds any capitalization" do
      expect(subject.uuid("00000983-28B3-54C3-a858-e03121fa535d")[:data].first[:total]).to be > 0
    end

    it "does not find record by canonical form uuid" do
      expect(subject.uuid("7ce58a7d-d3dd-5108-b490-d42c9915f45f")[:data].first[:total]).to be 0
    end

    it "does not find result if it is not uuid" do
      expect(subject.uuid("ha!")[:data].first[:total]).to be 0
    end

    it "finds all existing matches" do
      expect(res[:data].first[:total]).to be > 1
    end

    it "shows number of matchies in total field" do
      expect(res[:data].first[:total]).to be 2
      expect(res[:data].first[:total]).to be == res[:data].first[:results].size
    end

    # Pending...

    context "vernacular names flag" do
    end

    context "surrogate names flag" do
    end
  end

  describe "search" do
    context "simple search" do
      it "finds results" do
        res = subject.search("Ilyrgis olivacea")
        expect(res[:data].first[:total]).to be > 0
      end

      it "returns empty result for unknown data" do
        res = subject.search("blablabla")
        expect(res[:data].first[:total]).to be 0
      end

      it "finds results using wildcard" do
        res = subject.search("Ilyrgis oliv*")
        expect(res[:data].first[:total]).to be > 0
      end
    end

    context "search by canonical form" do
      it "finds strings with authorship" do
        res = subject.search("Metepedanus accentuatus")
        expect(res[:data].first[:total]).to be > 0
        expect(res[:data].first[:results].first[:nameString]).
          to eq "Metepedanus accentuatus (Roewer, 1911)"
      end
    end

    context "wild card search" do
      it "finds binomial results" do
        res = subject.search("Ilyr*")
        ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
        expect(res[:data].first[:total]).to be > 0
        expect(ns).to include "Ilyrgis olivacea"
      end

      it "finds uninomial with authorship" do
        res = subject.search("Itarch*")
        ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
        expect(ns).to eq ["Itarchytas Blanchard 1940"]
        expect(res[:data].first[:total]).to be > 0
      end

      it "finds uninomial without authorship" do
        res = subject.search("Jura*")
        ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
        expect(ns).to eq ["Jurapteryx"]
        expect(res[:data].first[:total]).to be > 0
      end
    end

    context "'faceted' search" do
      context "search by exact match" do
        it "finds names by exact matching" do
          res1 = subject.search("Hyphessobrycon panamensis daguae")
          res2 = subject.search("exact:Hyphessobrycon panamensis daguae")
          ns1 = res1[:data].first[:results].map { |m| m[:nameString] }.uniq
          ns2 = res2[:data].first[:results].map { |m| m[:nameString] }.uniq
          expect(ns1.size).to be 2
          expect(ns2.size).to be 1
        end
      end

      context "name string search" do
        it "finds names using name string only" do
          res1 = subject.search("ns:Hyphessobrycon panamensis daguae")
          ns1 = res1[:data].first[:results].map { |m| m[:nameString] }.uniq
          expect(ns1.size).to be 1
        end

        it "finds names using name string only with wildcard" do
          res1 = subject.search("ns:Hyphessobrycon panamensis daguae*")
          ns1 = res1[:data].first[:results].map { |m| m[:nameString] }.uniq
          expect(ns1.size).to be 2
        end
      end

      context "canonical search" do
        it "finds names only using canonical" do
          res1 = subject.search("ns:Alph*")
          ns1 = res1[:data].first[:results].map { |m| m[:nameString] }.uniq
          expect(ns1.size).to be > 0
          expect(ns1).to include("Alphavirus: rio negro virus Ictv")
          res2 = subject.search("can:Alph*")
          ns2 = res2[:data].first[:results].map { |m| m[:nameString] }.uniq
          expect(ns2.size).to be > 0
          expect(ns2).to_not include("Alphavirus: rio negro virus Ictv")
        end
      end

      context "search by author" do
        it "finds names with known author" do
          res = subject.search("au:Linnaeus")
          expect(res[:data].first[:total]).to be > 1
        end

        it "shows number of matches in total" do
          res = subject.search("au:Linnaeus")
          expect(res[:data].first[:total]).to be 91
          expect(res[:data].first[:total]).to be == res[:data].first[:results].size
        end

        it "does not find names with unknown author" do
          res = subject.search("au:astalavistababy")
          expect(res[:data].first[:total]).to be 0
        end

        it "finds names with known author in lowcase" do
          res = subject.search("au:linnaeus")
          expect(res[:data].first[:total]).to be > 0
        end

        it "does find all 'filius' authors" do
          # TODO: fix a bug #95
          # res = subject.search("au:f.")
          # expect(res[:total]).to be > 1
        end

        it "does find initials" do
          res = subject.search("au:L.")
          expect(res[:data].first[:total]).to be > 1
        end

        it "finds authors with non-ASCII chars" do
          res = subject.search("au:Aspöck")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(ns).to contain_exactly("Agulla kaszabi Aspock & Aspock 1967",
                                        "Austroberothella Aspöck & Aspöck 1985")
          expect(res[:data].first[:results].size).to be > 0
          expect(res[:data].first[:total]).to be > 0
        end

        it "finds authors with non-ASCII chars with ASCII substitution" do
          pending "empty due to missing name_string_index"
=begin
SELECT "name_uuid"
FROM "name_strings__author_words"
WHERE "author_word" = unaccent('FROL.')

000fb7f3-ad82-5cc0-9373-c18ce308558d

but there is no such name_string_index at
https://media.githubusercontent.com/media/GlobalNamesArchitecture/gnresolver/d8e1f1c328850d2c5fbc4ee491a9a215670f00e4/db-migration/db/seed/development/name_string_indices.csv
=end
          res = subject.search("au:Frol.")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(ns).to include "Anomotaenia stentorea Fröl."
          expect(res[:data].first[:results].size).to be > 1
          expect(res[:total]).to be > 1
        end

        it "works with wildcard" do
          res = subject.search("au:Linn*")
          expect(res[:data].first[:results].size).to be > 10
        end
      end

      context "search by year" do
        it "finds year" do
          res = subject.search("yr:1911")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be > 1
          expect(ns).to include "Triepeolus obliteratila Graenicher 1911"
        end

        it "finds year with a letter" do
          res = subject.search("yr:1933b")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be > 1
          expect(ns).to eq ["Neodryocoetes hymenaeae Eggers, 1933b"]
        end

        it "finds nothing with year less than 1758" do
          (1500..1750).step(15) do |yr|
            res = subject.search("yr:%d" % yr)
            expect(res[:data].first[:results].size).to be 0
          end
        end

        it "finds year with a wildcard" do
          res = subject.search("yr:193*")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be > 1
          expect(ns).to include "Neodryocoetes hymenaeae Eggers, 1933b"
        end
      end

      context "searth by canonical form" do
        it "finds by canonical form" do
        end
      end

      context "search by uninomial" do
        it "finds by uninomial" do
          res = subject.search("uni:Algae")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be > 0
          expect(ns).to include "Algae C. Linnaeus, 1753"
        end

        it "finds by lowcase uninomial" do
          res = subject.search("uni:algae")
          expect(res[:data].first[:results].size).to be 1
        end

        it "finds by uninomial with wildcard" do
          res = subject.search("uni:Alga*")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be 1
          expect(ns).to include "Algae C. Linnaeus, 1753"
        end
      end

      context "search by genus" do
        it "finds by genus" do
          res = subject.search("gen:Acacia")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be > 1
          expect(ns).to include "Acacia fruticosa Voigt"
        end

        it "finds genus in lowcase" do
          res = subject.search("gen:acacia")
          expect(res[:data].first[:total]).to be 53
        end

        it "finds by genus with wildcard" do
          res = subject.search("gen:Acac*")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be > 1
          expect(ns).to include "Acacia fruticosa Voigt"
        end
      end

      context "search by species" do
        it "finds by species" do
          res = subject.search("sp:linearis")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be > 1
          expect(ns).to include "Malachius linearis Morawitz, 1861"
        end

        it "finds species in uppercase" do
          res = subject.search("sp:Linearis")
          expect(res[:data].first[:results].size).to be 12
        end

        it "finds by species with wildcard" do
          res = subject.search("sp:line*")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:results].size).to be > 1
          expect(ns).to include "Malachius linearis Morawitz, 1861"
        end
      end

      context "search by susbspecies" do
        it "finds by subspecies" do
          res = subject.search("ssp:albiflorum")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:total]).to be > 1
          expect(ns).to include "Cirsium arvense albiflorum"
        end

        it "finds by subspecies with wildcard" do
          res = subject.search("ssp:albi*")
          ns = res[:data].first[:results].map { |m| m[:nameString] }.uniq.sort
          expect(res[:data].first[:total]).to be > 1
          expect(ns).to include "Cirsium arvense albiflorum"
        end

        it "find subspecies in uppercase" do
          res = subject.search("ssp:Albiflorum")
          expect(res[:data].first[:total]).to be 2
        end
      end
    end

    context "pagination" do
      it "paginates search results" do
        res = subject.search("au:Linnaeus", page: 1, per_page: 10)
        expect(res[:data].first[:results].size).to be 10
        expect(res[:data].first[:total]).to be 91
      end

      it "keeps list consistent page by page" do
        res1 = subject.search("au:Linnaeus", page: 0, per_page: 10)
        res2 = subject.search("au:Linnaeus", page: 1, per_page: 10)
        res3 = subject.search("au:Linnaeus", page: 9, per_page: 10)
        res4 = subject.search("au:Linnaeus")
        expect(res1[:data].first[:results].size).to be 10
        expect(res2[:data].first[:results].size).to be 10
        expect(res3[:data].first[:results].size).to be 1
        expect(res1[:data].first[:results]).to eq res4[:data].first[:results][0..9]
        expect(res2[:data].first[:results]).to eq res4[:data].first[:results][10..19]
        expect(res3[:data].first[:results]).to eq [res4[:data].first[:results][-1]]
      end

      it "keeps list consistent independently of page size" do
        res1 = subject.search("au:Linnaeus", page: 7, per_page: 3)
        res2 = subject.search("au:Linnaeus", page: 1, per_page: 21)
        expect(res1[:data].first[:results]).to eq(res2[:data].first[:results][0..2])
      end

      it "returns empty resuslt or negative pages" do
        # TODO: Make a ticket -- does not make sense to me
        res1 = subject.search("au:Linnaeus", page: -1, per_page: 3)
        res2 = subject.search("au:Linnaeus", page: 0, per_page: 3)
        expect(res1[:data].first[:results]).to eq res2[:data].first[:results]
      end

      it "returns empty result on negative per_page" do
        res = subject.search("au:Linnaeus", page: 0, per_page: -3)
        expect(res[:data].first[:results].size).to be 0
      end

      it "returns empty result if page is out of boundaries" do
        res = subject.search("au:Linnaeus", page: 70, per_page: 3)
        expect(res[:data].first[:results]).to eq []
      end
    end
  end
end
