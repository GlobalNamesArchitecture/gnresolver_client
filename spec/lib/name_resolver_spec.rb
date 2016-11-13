# frozen_string_literal: true

describe GnresolverClient::NameResolvers do
  context "exact and canonical search" do
    it "finds results for a canonical" do
      res = subject.search(
        :get, '{"value":"Hyphessobrycon panamensis daguae", "localId": 1}'
      )
      expect(res).to be_kind_of Array
      expect(res.first.keys.sort).
        to eq %i(localId matches page perPage suppliedNameString total)
      expect(res.first[:matches].size).to be > 1
      expect(res.first[:matches].first.keys.sort).
        to eq %i(canonicalName canonicalNameUuid classificationPath
                 classificationPathIds classificationPathRanks dataSourceId
                 dataSourceTitle globalId kind nameString nameStringUuid
                 surrogate taxonId vernacular)
    end

    it "finds results for a name string" do
      res = subject.search(
        :get, '{"value":"Aegipan grallator Scudder, S.H., 1877"}'
      )
      expect(res).to be_kind_of Array
      expect(res.first.keys.sort).
        to eq %i(localId matches page perPage suppliedNameString total)
      # TODO: change to ExactNameStringMatch
      expect(res.first[:matches].first[:kind]).
        to eq "ExactNameMatchByUUID"
      expect(res.first[:matches].size).to be > 1
      expect(res.first[:matches].first.keys.sort).
        to eq %i(canonicalName canonicalNameUuid classificationPath
                 classificationPathIds classificationPathRanks dataSourceId
                 dataSourceTitle globalId kind nameString nameStringUuid
                 surrogate taxonId vernacular)
    end

    it "finds results for a name without localId" do
      res = subject.search(
        :get, '{"value":"Hyphessobrycon panamensis daguae"}'
      )
      expect(res).to be_kind_of Array
      expect(res.first.keys.sort).
        to eq %i(localId matches page perPage suppliedNameString total)
      expect(res.first[:localId]).to be_nil
      expect(res.first[:matches].size).to be > 1
      # TODO: it should be ExactCanonicalFormMatch
      expect(res.first[:matches].first[:kind]).
        to eq "ExactCanonicalNameMatchByUUID"
      expect(res.first[:matches].first.keys.sort).
        to eq %i(canonicalName canonicalNameUuid classificationPath
                 classificationPathIds classificationPathRanks dataSourceId
                 dataSourceTitle globalId kind nameString nameStringUuid
                 surrogate taxonId vernacular)
    end

>>>>>>> 4d6f3dc... wip
    it "finds results for several names" do
      res = subject.search(
        :get, '[{"value":"Hyphessobrycon panamensis daguae", "localId": 1},
                {"value": "Aegilops", "localId": 2}]'
      )
      expect(res.size).to be 2
      expect(res.last[:total]).to be 3
      expect(res.last[:matches].size).to be 3
      expect(res.last.keys.sort).
        to eq %i(localId matches page perPage suppliedNameString total)
    end
<<<<<<< HEAD
=======

    it "finds results for several names using post"
  end

  context "fuzzy canonical match" do
    it "makes fuzzy match" do
      res = subject.search(
        :get, '{"value":"Hyphesobrycon panamensis daguae"}'
      )
      expect(res.first[:localId]).to be_nil
      expect(res.first[:matches].size).to be > 1
      # TODO: change to FuzzyCanonicalFormMatch
      # TODO: show edit distance
      expect(res.first[:matches].first[:kind]).
        to eq "Fuzzy"
    end

    it "does not match when edit distance is > 1" do
      res = subject.search(:get, '{"value":"Hypheobrycon panamensis daguae"}')
      # TODO: should not match if edit distance is more then 1
      expect(res.first[:matches].first[:kind]).
        to eq "Fuzzy"
    end

    it "does not make fuzzy match of a uninomial" do
      res = subject.search(:get, '{"value":"Agonostoma"}')
      expect(res.first[:matches].size).to be 1
      res = subject.search(:get, '{"value":"Agonostomaa"}')
      # TODO: empty result should return empty matches, but still
      # return localId, total, suppliedNameString etc.
      expect(res).to eq []
    end
  end

  context "partial canonical match" do
    it "makes fuzzy match" do
      res = subject.search(
        :get, '{"value":"Agriotes taiyarui neponyatnaya"}'
      )
      expect(res.first[:matches].size).to be > 1
      # TODO: should be "PartialCanonicalFormMatch"
      expect(res.first[:matches].first[:kind]).
        to eq "Fuzzy"
    end
  end

  context "partial fuzzy match" do
    it "makes fuzzy match" do
      res = subject.search(
        :get, '{"value":"Agriotes teiyarui neponyatnaya"}'
      )
      expect(res.first[:matches].size).to be > 1
      # TODO: should be "PartialFuzzyCanonicalFormMatch"
      expect(res.first[:matches].first[:kind]).
        to eq "Fuzzy"
    end
  end

  context "partial genus match" do
    it "makes match by genus" do
      res = subject.search(:get, '{"value":"Agrotontia"}')
      expect(res.first[:matches].size).to be > 1
      res = subject.search(:get, '{"value":"Agrotontia neponyatnaya"}')
      expect(res.first[:matches].size).to be > 1
      # TODO: should be "PartialGenusMatch"
      expect(res.first[:matches].first[:kind]).
        to eq "Fuzzy"
    end

    it "makes match by genus for infraspecies" do
      res = subject.search(:get, '{"value":"Agrotontia neponyatnaya ochen"}')
      expect(res.first[:matches].size).to be > 1
      # TODO: should be "PartialGenusMatch"
      expect(res.first[:matches].first[:kind]).
        to eq "Fuzzy"
    end

    it "does not fuzzy-match by genus" do
      res = subject.search(:get, '{"value":"Agrotonta neponyatnaya ochen"}')
      expect(res).to be_empty
    end
  end

  context "partial fuzzy match" do
    it "makes fuzzy match" do
      res = subject.search(
        :get, '{"value":"Agriotes teiyarui neponyatnaya"}'
      )
      expect(res.first[:matches].size).to be > 1
      # TODO: should be "PartialFuzzyCanonicalFormMatch"
      expect(res.first[:matches].first[:kind]).
        to eq "Fuzzy"
    end
  end

  context "pagination" do
    it "returns pagination as a global parameter" do
      # TODO: Fix #102
      # Currently page and perPage show on the same level as total and
      # localId/suppliedId, but it should come on the root-based "parameters"
      # sections or something like that
    end
  end
end
