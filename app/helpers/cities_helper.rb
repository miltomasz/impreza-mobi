module CitiesHelper
  class Sorter
    def initialize
      super
    end
    def sort_events(events)
      events.sort! {
        |e, y| y.date <=> e.date
      }
    end

    def sort_events_by_voice(events)
      events.sort do |e, y|
        if y.voices_index == nil
          y.voices_index = 0
        end

        if e.voices_index == nil
          e.voices_index = 0
        end

        y.voices_index <=> e.voices_index
      end
    end
  end

  class VoicesCalculator
    def initialize
      super
    end
    def calculate(voices_index, voices_number)
      average_note = voices_number / voices_index
      return average_note.round 
    end
  end
end
