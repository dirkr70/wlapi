# -*- coding: utf-8 -*-
require 'test/unit'
require 'wlapi'


class TestApi < Test::Unit::TestCase

  METHODS = [:baseform,
             :domain,
             :wordforms,
             :thesaurus,
             :synonyms,
             :sentences,
             :left_neighbours,
             :right_neighbours,
             :similarity,
             :experimental_synonyms,
             :right_collocation_finder,
             :left_collocation_finder,
             :cooccurrences,
             :cooccurrences_all,
             :intersection,
             :frequencies
            ]
  def setup
    @api = WLAPI::API.new
    @word = 'Stuhl'
  end

  def teardown
  end
  
  # test constants
  def test_constants
    assert(WLAPI::VERSION.is_a?(String))
    assert_equal(false, WLAPI::VERSION.empty?)
  end

  def test_availability_of_pulic_methods
    METHODS.each { |m| assert_respond_to(@api, m) }
  end

  def test_for_absent_arguments
    assert_raise(ArgumentError) do
      METHODS.each { |m| @api.send(m) }
    end
  end

  def test_for_redundant_arguments
    one_par = [:frequencies,
               :baseform,
               :domain
              ]
    assert_raise(ArgumentError) do
      one_par.each { |m| @api.send(m, 1, 2) }
    end

    two_par = [:wordforms,
               :thesaurus,
               :synonyms,
               :sentences,
               :left_neighbours,
               :right_neighbours,
               :similarity,
               :experimental_synonyms
              ]
    assert_raise(ArgumentError) do
      two_par.each { |m| @api.send(m, 1, 2, 3) }
    end
    
    three_par = [:right_collocation_finder,
                 :left_collocation_finder,
                 :cooccurrences,
                 :cooccurrences_all,
                 :intersection
                ]
    assert_raise(ArgumentError) do
      three_par.each { |m| @api.send(m, 1, 2, 3, 4) }
    end    
  end

  # one parameter
  def test_frequencies
    response = @api.frequencies('Haus')
    check_response(response)

    assert_equal(2, response.size)
    assert_match(/\d+/, response[0])
    assert_match(/\d+/, response[1])
    assert_equal(["122072", "7"], response)
  end

  def test_baseform
    response = @api.baseform('Autos')
    check_response(response)

    assert_equal(2, response.size)
    assert_match(/\w+/, response[0])
    assert_match(/[AVN]/, response[1])
    assert_equal(["Auto", "N"], response)
  end

  def test_domain
    response = @api.domain('Buch')
    check_response(response)

    expected_response = ["Sprachwissenschaft",
                         "Nachname",
                         "Stadt",
                         "Buchkunde/Buchhandel",
                         "Motive",
                         "Literarische/Motive/Stoffe/Gestalten",
                         "Buchkunde/Buchhandel",
                         "Papierherstellung/Graphische/Technik",
                         "Buchkunde/Buchhandel",
                         "Bücher",
                         "Ort in D"
                        ]
    assert_equal(expected_response, response)
    # We cannot predict the minimal structure of the response.
  end
  
  # two parameters
  def test_wordforms
    response = @api.wordforms('Buch')
    check_response(response)

    expected_response = ["Buch",
                         "Bücher",
                         "Büchern",
                         "Buches",
                         "Buchs",
                         "Bucher"
                        ]
    assert_equal(expected_response, response)
  end

  def test_thesaurus
    response = @api.thesaurus('Buch')
    check_response(response)

    expected_response = ["Buch", "Titel", "Werk", "Zeitung", "Band",
                         "Literatur", "Zeitschrift", "Bruch", "Lektüre",
                         "Schrift"]
    assert_equal(expected_response, response)
  end

  def test_synonyms
    response = @api.synonyms('Brot')
    check_response(response)

    expected_response = ["Laib", "Brotlaib", "Laib", "Schnitte", "Stulle"]
    assert_equal(expected_response, response)
  end

  def test_sentences
    response = @api.sentences('Klasse', 1)
    check_response(response)
    expected_response = ["40829928",
                         "Bei den Grünen war ich wohl im Urteil der politisch korrekten Klasse bei den Richtigen, auch wenn ich in ihren Augen das Falsche sagte."] 
    assert_equal(expected_response, response)
  end

  def test_left_neighbours
    response = @api.left_neighbours('Stuhl', 2)
    check_response(response)

    expected_response = ["elektrischen", "Stuhl", "626",
                         "seinem", "Stuhl", "592"]
    assert_equal(expected_response, response)
  end

  def test_right_neighbours
    response = @api.right_neighbours('Stuhl', 2)
    check_response(response)

    expected_response = ["Stuhl", "räumen", "189",
                         "Stuhl", "hin und her", "130"]
    assert_equal(expected_response, response)
  end

  def test_similarity
    response = @api.similarity('Stuhl', 3)
    check_response(response)

    expected_response = ["Stuhl", "Sessel", "26",
                         "Stuhl", "Lehnstuhl", "24",
                         "Stuhl", "Sofa", "21"] 
    assert_equal(expected_response, response)   
  end

  def test_experimental_synonyms
    response = @api.experimental_synonyms('Stuhl')
    check_response(response)

    expected_response = ["Einrichtungsgegenstand", "v",
                         "Bett", "v",
                         "Lampe", "v",
                         "Tisch", "v",
                         "Schrank", "v",
                         "Teppich", "v",
                         "Gebrauchsmöbel", "v",
                         "Möbelstück", "v",
                         "Bank", "v",
                         "Bord", "v"
                        ]
    assert_equal(expected_response, response)
  end
  
  # three parameters
  def test_right_collocation_finder
    response = @api.right_collocation_finder('Stuhl', 'V', 3)
    check_response(response)

    expected_response = ["Stuhl", "aufmöbeln", "V",
                         "Stuhl", "aufreihen", "V",
                         "Stuhl", "aufspringen", "V"
                        ]
    assert_equal(expected_response, response) 
  end

  def test_left_collocation_finder
    response = @api.left_collocation_finder('Stuhl', 'A', 3)
    check_response(response)
    expected_response = ["Hl", "A", "Stuhl",
                         "abwaschbar", "A", "Stuhl",
                         "alle", "A", "Stuhl"
                        ]
    assert_equal(expected_response, response) 
  end

  def test_cooccurrences
    response = @api.cooccurrences('Haus', 10000)
    check_response(response)
    expected_response = ["Haus", "das", "11747"]
    
    assert_equal(expected_response, response) 
  end

  def test_cooccurrences_all
    begin
      @api.cooccurrences_all('Haus', 10000)
    rescue RuntimeError => e
      assert_match(/You're not allowed to access this service./, e.message)
    end
    # Not possible to test without access credential.
  end

  def test_intersection
    begin
      @api.intersection('Haus', 'Brot', 1)
    rescue RuntimeError => e
      assert_match(/You're not allowed to access this service./, e.message)
    end
    # Not possible to test without access credential.
  end


################## HELPER METHODS ###############################################
  def check_response(response)
    assert_not_nil(response)
    assert_instance_of(Array, response)
    assert(response.any?)
  end
end
