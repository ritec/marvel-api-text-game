require_relative '../marvel_challenge.rb'

RSpec.configure do |config|
  config.mock_with :mocha
  config.formatter = :documentation
end

describe MarvelChallenge do

  describe 'play' do

    let(:hulk_json) {
      { "code"=>200,
       "status"=>"Ok",
       "data"=>
        {"total"=>1,
         "count"=>1,
         "results"=>
          [{"id"=>1009351,
            "name"=>"Hulk",
            "description"=>
             "Caught in a gamma bomb explosion while trying to save the life of a teenager, Dr. Bruce Banner..."
          }]
        }
      }
    }

    let(:spider_man_json) {
      {"code"=>200,
        "status"=>"Ok",
        "data"=>
         {"total"=>1,
          "count"=>1,
          "results"=>
           [{"id"=>1009610,
             "name"=>"Spider-Man",
             "description"=>
              "Bitten by a radioactive spider, high school student Peter Parker gained the speed"
          }]
        }
      }
    }

    let(:aim_json) {
      {"code"=>200,
        "status"=>"Ok",
        "data"=>
         {"total"=>1,
          "count"=>1,
          "results"=>
           [{"id"=>1009144,
             "name"=>"A.I.M.",
             "description"=>
              "AIM is a terrorist organization bent on destroying the world."
          }]
        }
      }
    }

    let(:not_200) {
      {"code"=>404,
        "status"=>"Not Found",
        "data"=>
         {"total"=>1,
          "count"=>0,
          "results"=>
           [{
          }]
        }
      }
    }

    let(:no_results) {
      {
        "code"=>200,
        "status"=>"Ok",
        "data"=>{"offset"=>0, "limit"=>20, "total"=>0, "count"=>0, "results"=>[]}
      }
    }

    context 'when magic words are present' do
      describe 'and both players have magic words' do
        it 'prints a message saying both players have magic words' do
          MarvelApiService.any_instance.stubs(:call).returns(hulk_json, spider_man_json)
          expect do
            MarvelChallenge.new('hulk', 'spider-man', 4).play
          end.to output("*** Both players have magic words: [\"gamma\", \"radioactive\"]! It is a tie?! ***\n").to_stdout
        end
      end

      describe 'and only one player has magic words' do
        it 'prints a message saying player has magic word gamma and won' do
          MarvelApiService.any_instance.stubs(:call).returns(hulk_json, aim_json)
          expect do
            MarvelChallenge.new('hulk', 'A.I.M.', 4).play
          end.to output("*** Magic Word gamma found! Winner is hulk! ***\n").to_stdout
        end

        it 'prints a message saying player has magic word radioactive and won' do
          MarvelApiService.any_instance.stubs(:call).returns(aim_json, spider_man_json)
          expect do
            MarvelChallenge.new('A.I.M.', 'spider-man', 4).play
          end.to output("*** Magic Word radioactive found! Winner is spider-man! ***\n").to_stdout
        end
      end
    end

    context 'with regular non magic words' do
      it 'prints a message saying player with longer word won' do
        MarvelApiService.any_instance.stubs(:call).returns(hulk_json, aim_json)
        expect do
          MarvelChallenge.new('hulk', 'A.I.M.', 1).play
        end.to output("The description words were [\"caught\", \"aim\"]. The winner is player one hulk\n").to_stdout
      end

      it 'prints a message saying there is a tie if both words are same length' do
        MarvelApiService.any_instance.stubs(:call).returns(spider_man_json, aim_json)
        expect do
          MarvelChallenge.new('spider-man', 'A.I.M.', 6).play
        end.to output("The description words were [\"high\", \"bent\"]. It's a tie!\n").to_stdout
      end
    end

    context 'when response is not 200' do
      it 'exits if there was a response other than 200' do
        MarvelApiService.any_instance.stubs(:call).returns(not_200, aim_json)
        expect do
          MarvelChallenge.new('hulk', 'not_200', 5).play
        end.to raise_error(SystemExit)
      end
    end

    context 'when a character is not found' do
      it 'exits if one of the characters is not found' do
        MarvelApiService.any_instance.stubs(:call).returns(no_results, aim_json)
        expect do
          MarvelChallenge.new('no-results', 'hulk', 5).play
        end.to raise_error(SystemExit)
      end
    end
  end
end
