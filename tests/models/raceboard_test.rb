class TestRaceBoard < MiniTest::Unit::TestCase
  def setup
    @state = GameState.new
    @state.reset!
    @raceboard = @state.raceboard
    @player = Player.new("Bob", "East")
    @player2 = Player.new("Alice", "East")
  end

  class TestAddRaceChoice < TestRaceBoard
    def first_active_race
      @raceboard.active_races.first
    end

    def test_adds_a_race_choice
      initial_races = @raceboard.races.clone
      @raceboard.add_race_choice
      assert_includes initial_races, first_active_race
    end

    def test_adds_no_coins_to_the_race_choice
      @raceboard.add_race_choice
      assert_equal 0, @raceboard.race_choices.first.last
    end

    def test_removes_active_race_from_races
      @raceboard.add_race_choice
      refute_includes @raceboard.races, first_active_race
    end
  end

  class TestPickActiveRaces < TestRaceBoard
    def test_returns_6_elements
      @raceboard.pick_active_races
      assert_equal 6, @raceboard.active_races.length
    end

    def test_throw_error_if_too_many_races_required
      @raceboard.races = []
      assert_raises(TooManyRacesRequired) { @raceboard.pick_active_races }
    end

    def test_if_active_races_is_empty
      assert @raceboard.active_races_empty?
      @raceboard.pick_active_races
      refute @raceboard.active_races_empty?
    end

    def test_throw_error_if_races_already_picked
      assert_raises(ActiveRacesAlreadyPicked) do
        @raceboard.pick_active_races
        @raceboard.pick_active_races
      end
    end
  end

  class TestPickRace < TestRaceBoard
    def test_raise_race_not_active_error_if_the_race_is_not_active
      @raceboard.pick_active_races
      assert_raises(RaceNotActive) do
        @raceboard.pick_race(@raceboard.races.first, @player)
      end
    end

    def test_throws_error_if_not_enough_races
      @raceboard.pick_active_races
      @raceboard.races = []
      assert_raises(NotEnoughRaces) do
        chosen_race = @raceboard.active_races.first
        @raceboard.pick_race(chosen_race, @player)
      end
    end

    def test_it_adds_coins_to_race_choices_depending_on_the_race_position
      @raceboard.pick_active_races
      chosen_race = @raceboard.active_races[3]
      @raceboard.pick_race(chosen_race, @player)
      @raceboard.race_choices[0..2].each do |race_choice|
        assert_equal 1, race_choice.last
      end
      @raceboard.race_choices[3..5].each do |race_choice|
        assert_equal 0, race_choice.last
      end
    end

    def test_readjust_players_coins_when_no_coins_next_to_races
      @raceboard.pick_active_races
      chosen_race = @raceboard.active_races[3]
      @raceboard.pick_race(chosen_race, @player)
      assert_equal 2, @player.coins
    end

    def test_readjust_players_coins_when_other_player_picked_race
      @raceboard.pick_active_races
      # First player chooses 4th race
      chosen_race_1 = @raceboard.active_races[3]
      @raceboard.pick_race(chosen_race_1, @player)
      # Second player chooses 3rd race
      chosen_race_2 = @raceboard.active_races[0]
      @raceboard.pick_race(chosen_race_2, @player2)
      assert_equal 6, @player2.coins
    end
  end
end
