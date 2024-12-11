class ReadingStatsController < ApplicationController
  def index
    stats = ReadingStat.all
    render json: stats
  end

  def show
    stat = ReadingStat.find_by(book_id: params[:id])
    if stat
      render json: stat
    else
      render json: { error: 'Estatística não encontrada' }, status: :not_found
    end
  end

  def create
    stat = ReadingStat.new(stat_params)
    if stat.save
      render json: stat, status: :created
    else
      render json: { errors: stat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def stat_params
    params.require(:reading_stat).permit(:book_id, :total_readers, :average_rating, 
                                       :reading_time_minutes, :completion_rate)
  end
end 