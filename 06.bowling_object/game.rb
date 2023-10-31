require_relative 'frame.rb'
require 'debug'

class Game
  attr_reader :first_frame, :second_frame, :third_frame, :fourth_frame, :fifth_frame, :sixth_frame, :seventh_frame, :eighth_frame, :ninth_frame, :tenth_frame

  def initialize(shots_text)
    shots = perse_shots_text(shots_text)
      
    frames = []
    current_frame = []
    shots.each_with_index do |shot, index|
      frames << [] if next_frame?(frames, current_frame)
      current_frame = frames.last
      current_frame << shot
    end

    @first_frame = Frame.new(1, frames[0])
    @second_frame = Frame.new(2, frames[1])
    @third_frame = Frame.new(3, frames[2])
    @fourth_frame = Frame.new(4, frames[3])
    @fifth_frame = Frame.new(5, frames[4])
    @sixth_frame = Frame.new(6, frames[5])
    @seventh_frame = Frame.new(7, frames[6])
    @eighth_frame = Frame.new(8, frames[7])
    @ninth_frame = Frame.new(9, frames[8])
    @tenth_frame = Frame.new(10, frames[9])
  end

  def perse_shots_text(shots_text)
    shots_text.split(',').map
  end

  def next_frame?(frames, current_frame)
    not_last_frame?(frames) && (frames.empty? || strike?(current_frame) || current_frame.size == 2)
  end

  def not_last_frame?(frames)
    frames.size != 10
  end
  
  def strike?(current_frame)
    current_frame[0] == 'X'
  end

  def score
    [first_frame.score(second_frame, third_frame),
    second_frame.score(third_frame, fourth_frame),
    third_frame.score(fourth_frame, fifth_frame),
    fourth_frame.score(fifth_frame, sixth_frame),
    fifth_frame.score(sixth_frame, seventh_frame),
    sixth_frame.score(seventh_frame, eighth_frame),
    seventh_frame.score(eighth_frame, ninth_frame),
    eighth_frame.score(ninth_frame, tenth_frame),
    ninth_frame.score(tenth_frame),
    tenth_frame.score].sum
  end
end
