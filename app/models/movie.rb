class Movie < ActiveRecord::Base
    def self.movie_ratings
        return ['G','PG','PG-13','R']
    end
    
    def self.chosen_rating(rtng)
        Movie.where(rating: rtng)
    end
end
