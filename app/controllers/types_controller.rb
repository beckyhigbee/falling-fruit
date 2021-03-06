class TypesController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource

  # GET /types
  # GET /types.json
  def index
    @types = Type.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @types }
      format.csv { render csv: @types }
    end
  end

  def grow
    @type_others = {}
    LocationsType.select('type_other,id,location_id').where("type_id IS NULL and type_other IS NOT NULL").each{ |lt|
      safer_type = lt.type_other.tr('^A-Za-z- \'','').capitalize
      @type_others[safer_type] = [] if @type_others[safer_type].nil?
      @type_others[safer_type].push(lt)
    }
    respond_to do |format|
      format.html
      format.json { render json: @types }
    end
  end

  def merge
    if params[:id].present?
      from = Type.find(params[:id].to_i)
      to = Type.find(params[:into_id].to_i)
      Cluster.select("*, ST_X(cluster_point) AS cx, ST_Y(cluster_point) AS cy").
        where("type_id = ?",from.id).each{ |c|
        c2 = Cluster.select("*, ST_X(cluster_point) AS cx, ST_Y(cluster_point) AS cy").
                     where("type_id = ? AND zoom = ? AND muni = ? AND grid_point = ?",to.id,c.zoom,c.muni,c.grid_point).first
        # to type doesn't have a cluster here, so just change the type
        if c2.nil?
          c.type_id = to.id
          c.save
        # to type does have a cluster here so merge with from type's cluster
        else
          c2.count = c2.count.to_i + c.count.to_i
          newx = c2.cx.to_f+((c.cx.to_f-c2.cx.to_f)/c2.count.to_f)
          newy = c.cy.to_f+((c.cx.to_f-c2.cy.to_f)/c2.count.to_f)
          c2.cluster_point = "POINT(#{newx} #{newy})"
          c2.save
          c.destroy
        end 
      }
      LocationsType.where("type_id = ?",from.id).each{ |lt|
        lt.type = to
        lt.save
      }
      from.destroy
      respond_to do |format|
        format.html { redirect_to types_url, :notice => "Type #{from.id} was successfully merged into type #{to.id}" }
        format.json { head :no_content }
      end
    elsif params[:lts].present?
      to = Type.find(params[:into_id].to_i)
      n = 0
      params[:lts].split(/:/).each{ |ltid|
        lt = LocationsType.find(ltid)
        lt.type_other = nil
        lt.type = to
        lt.save
        n += 1
      }
      respond_to do |format|
        format.html { redirect_to grow_types_url, :notice => "Type #{to.id} absorbed #{n} location-types" }
        format.json { head :no_content }
      end
    end
  end

  # GET /types/new
  # GET /types/new.json
  def new
    @type = Type.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @type }
    end
  end

  # GET /types/1/edit
  def edit
    @type = Type.find(params[:id])
    @categories = mask_to_array(@type.category_mask,Type::Categories)
  end

  # POST /types
  # POST /types.json
  def create
    @type = Type.new(params[:type])
    @type.category_mask = array_to_mask(params["categories"],Type::Categories)
    respond_to do |format|
      if @type.save
        andtext = ""
        if params[:lts].present?
          n = 0
          locs = []
          params[:lts].split(/:/).each{ |ltid|
            lt = LocationsType.find(ltid.to_i)
            lt.type_other = nil
            lt.type = @type
            lt.save
            locs << lt.location unless lt.location.nil?
          }
          locs.uniq.each{ |loc|
            n += 1
            ApplicationController.cluster_increment(loc,[@type.id])
          }
          format.html { redirect_to grow_types_path, notice: "Type was successfully created and #{n} locations were updated to use this new type." }
          format.json { render json: @type, status: :created, location: @type }
        else
          format.html { redirect_to types_path, notice: "Type was successfully created." }
          format.json { render json: @type, status: :created, location: @type }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /types/1
  # PUT /types/1.json
  def update
    @type = Type.find(params[:id])
    params[:type][:category_mask] = array_to_mask(params["categories"],Type::Categories)
    respond_to do |format|
      if @type.update_attributes(params[:type])

        format.html { redirect_to types_path, notice: 'Type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @type.errors, status: :unprocessable_entity }
      end
    end
  end

  #def update_location_category_mask(type)
  #  Location.joins(:locations_types,:types).select("bit_or(types.category_mask), locations.id").
  #    where("type_id = ?",type.id). SELECT bit_or(t.category_mask) AS category_mask, location_id AS id INTO TEMPORARY TABLE temp
  #  FROM locations l, locations_types lt, types t WHERE lt.location_id=l.id AND lt.type_id=t.id GROUP BY location_id;

  # DELETE /types/1
  # DELETE /types/1.json
  def destroy
    @type = Type.find(params[:id])
    @type.destroy
    Cluster.where("type_id = ?",params[:id]).each{ |c|
      c.destroy
    }
    respond_to do |format|
      format.html { redirect_to types_url }
      format.json { head :no_content }
    end
  end
end
