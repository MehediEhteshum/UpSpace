class PagesController < ApplicationController
  def home
    @featured = Space.where(active: true, featured: true).limit(3)
    @healthy_categories = ['Health/Wellness Studio', 'Salon/Spa', 'Sports Facility']
    @meeting_categories = ['Boardroom', 'Meeting Space', 'Government Office', 'Workspace']
    @social_categories = ['Art Gallery', 'Cafe or Coffee Shop', 'Community Center', 'Event Center', 'Golf Club', 'Lounge', 'Restaurant']
    @coworking_categories = ['Coworking Space', 'Workspace']
    @classroom_categories = ['Classroom']
    @search = Space.ransack(params[:q])
    @results = @search.result(distinct: true)
    @reviews = Review.where(type: 'GuestReview', star: 5).order('created_at DESC').limit(3)
  end

  def how_it_works
  end

  def resources
  end

  def about
  end

  def become_a_host
  end

  def feature_me
    signup = SendInBlue::Client.addFeaturedRequest(params[:email])
  end

  def faq
  end

  def planning
  end

  def ambassador
  end

  def hiring
  end

  def investing
  end

  def terms
  end

  def privacy
  end

  def search
    # STEP 1 make sure search term is entered
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    else
      session[:loc_search] = ""
    end

    # STEP 2 if have value for location, find nearby spaces, otherwise return all listings

    if session[:loc_search] && session[:loc_search] != ""
      @spaces_address = Space.where(active: true).near(session[:loc_search], 5, order: 'distance')
    else
      @spaces_address = Space.where(active: true).all
    end

    # STEP 3 returns spaces with additional criteria (q) so they can be filtered further
    @search = @spaces_address.ransack(params[:q])
    @search.sorts = ['featured desc', 'updated_at desc']
    @spaces = @search.result

    @arrSpaces = @spaces.to_a

    # STEP 4 if a date range is searched, find any reservations that exist in that range and remove those spaces from the results
    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? &&  !params[:end_date].empty?)

      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      @spaces.each do |space|

        not_available = space.reservations.where(
          "((? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date))
          AND status = ?",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date,
          1
        ).limit(1)

        not_available_in_calendar = space.calendars.where(
          "status = ? AND ? <= day AND day <= ?",
          1, start_date, end_date
        ).limit(1)

        if not_available.length > 0 || not_available_in_calendar.size > 0
          @arrSpaces.delete(space)
        end
      end
    end

    # @arrSpaces = @arrSpaces.paginate(:page => params[:page], :per_page => 3) THIS IS GETTING READY FOR PAGINATION BUT FILTERS ARE CLEARED ON PAGE CHANGES

  rescue Exception
    #redirect_back(fallback_location: request.referer, notice: "Something went wrong. Please try again.")

  end

  def has_filter_item(item)
    params[:q].present? && params[:q][item].present?
  end
  helper_method :has_filter_item

end
