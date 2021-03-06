class CheckoutsController < ApplicationController

  def create
    job = Job.find(params[:job_id])
    if job.retired
      flash[:danger] = "Retired job cannot be added to cart"
      redirect_to request.referrer
    else
      @cart.add_job(job.id)
      flash[@cart.flash_type.to_sym] = @cart.flash_message
      session[:cart] = @cart.contents
      redirect_to request.referrer
    end
  end

  def show
    @jobs = @cart.find_jobs
  end

  def confirmation
    @jobs = @cart.find_jobs
    @cart.add_resume(params[:resume])
    if @jobs.empty?
      flash[:danger] = "Your basket can't be empty!"
      redirect_to categories_path
    end
  end

  def summary
    @jobs = params[:jobs].keys.map { |id| Job.find(id.to_i)}
  end

  def remove
    job = @cart.remove_job(params[:job_id])
    redirect_to checkout_path
  end
  
end
