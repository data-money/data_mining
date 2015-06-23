module DataMining
  # Density-Based clustering / Outlier-Detection Algorithu
  class DBScan
    # Find clusters and outliers
    #
    # Example:
    #   >> input      = [[:p1, 1], [:p2, 2], [:p3, 10]]
    #   >> radius     = 3
    #   >> min_points = 2
    #   >> dbscan     = DataMining::DBScan.cluster(input, radius, min_points)
    #   >> dbscan.build!
    #   >>
    #   >> dbscan.clusters # gives array of clusters found (:p1, :p2)
    #   >>
    #   >> dbscan.outliers # gives array of outliers found (:p3)
    #
    # Arguments:
    #   data: (array of arrays, like [[:id, value], [:id2, value2]]
    #   radius: (integer)
    #   min_points: (integer)

    def self.cluster(data, radius, min_points)
      DBScan.new(data, radius, min_points)
    end

    def initialize(data, radius, min_points)
      @data               = data.map { |i, v| DataMining::Point.new(i, v) }
      @radius             = radius
      @min_points         = min_points
      @current_cluster_id = 0
      @clusters           = {}
      @unvisited_points   = @data.shuffle
    end

    def build!
      dbscan
      clusters
    end

    def outliers
      @data.select { |p| !p.assigned_to_cluster? }
    end

    def clusters
      @clusters.map { |cluster, points| { cluster => points.each(&:id) } }
    end

    private

    def dbscan
      until unvisited_points.empty?
        p = unvisited_points.pop
        p.visit!

        neighborhood = get_neighborhood(p)
        create_cluster(p, neighborhood) if core_object?(neighborhood)
      end
    end

    def unvisited_points
      @unvisited_points.select! { |p| !p.visited? }
      @unvisited_points
    end

    def create_cluster(point, neighborhood)
      @current_cluster_id += 1
      point.assign_to_cluster!
      (@clusters[@current_cluster_id] ||= []) << point
      fill_current_cluster(neighborhood)
    end

    def fill_current_cluster(neighborhood)
      neighborhood.each do |neighbor|
        elaborate(neighbor) unless neighbor.visited?
        neighbor.assign_to_cluster!
      end
    end

    def elaborate(point)
      point.visit!
      @clusters[@current_cluster_id] << point unless point.assigned_to_cluster?
      neighborhood = get_neighborhood(point)
      fill_current_cluster(neighborhood) if core_object?(neighborhood)
    end

    # use map instead of each?
    def get_neighborhood(point)
      neighborhood = []
      @data.each { |p| neighborhood << p if neighbors?(p, point) }
      neighborhood
    end

    def core_object?(neighborhood)
      return true if neighborhood.size >= (@min_points - 1)
      false
    end

    def neighbors?(p1, p2)
      return true if (p1.value - p2.value).abs <= @radius && p1 != p2
      false
    end
  end
end

require 'data_mining/point'