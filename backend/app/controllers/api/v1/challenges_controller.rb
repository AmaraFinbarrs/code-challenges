class Api::V1::ChallengesController < ApplicationController
  before_action :set_challenge, only: %i[ show update destroy ]

  # GET /api/v1/challenges
  def index
    @challenges = Challenge.all
    render json: @challenges
  end

   # GET /api/v1/challenges/:id
  def show
    render json: @challenge
  end

  # POST /api/v1/challenges
  def create
    @challenge = Challenge.new(challenge_params)

    if @challenge.save
      render json: @challenge, status: :created
    else
      render json: @challenge.errors, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/challenges/:id(
  # PUT /api/v1/challenges/:id(
  def update
    if @challenge.update(challenge_params)
      render json: @challenge
    else
      render json: @challenge.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/challenges/:id(
  def destroy
    if @challenge.destroy
      render json: @challenge, status: :ok, message: "Deleted Sucessfully!"
    else
      render json: @challenge.errors, status: :unprocessable_entity
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  # Only allow trusted parameters through
  def challenge_params
    params.expect(challenges: [:title, :description, :start_date, :end_date])
  end
end
