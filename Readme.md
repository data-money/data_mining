# DataMining

DataMining is a little collection of several Data-Mining-Algorithms.
Since is written in pure ruby and does not depend on any extension,
it is platform independent.

## Alogrithms

#### Already implemented
1. Density Based Clustering (DBSCAN)
2. Apriori
3. PageRank

#### Coming soon
4. k-Means
5. k-Nearest Neighbor Classifier
6. Naive Bayes
7. ...

## Installation

  $ gem install data_mining

## Usage

#### For Density Based Clustering

```ruby
  require 'data_mining'

  #
  # Point with id 'point1', x-value 1 and y-value 2:
  # [:point1, [1, 2]]
  #
  input_data = [
                [:point1, [1,2]],
                [:point2, [2,1]],
                [:point3, [10,10]]
               ]
  radius = 3
  min_points = 2
  dbscan = DataMining::DBScan.new(input_data, radius, min_points)
  dbscan.cluster!

  dbscan.clusters # gives 1 cluster found containing point1 and point2

  dbscan.outliers # gives point3 as outlier
```

#### For Apriori

```ruby
  require 'data_mining'

  transactions = [
                    [:transaction1, [:product_a, :product_b, :product_e]],
                    [:transaction2, [:product_b, :product_d]],
                    [:transaction3, [:product_b, :product_c]],
                    [:transaction4, [:product_a, :product_b, :product_d]]
                  ]
  min_support  = 2
  apriori      = DataMining::Apriori.new(transactions, min_support)
  apriori.mine!

  apriori.results
  # gives the following array:
  # => [ [[:product_a], [:product_b], [:product_d]],
  #      [[:product_a, :product_b], [:product_b, :product_d]]
  #    ]
  # where position 0 in the array, holds an array of all single items which
  # satisfy the min_support. position 1, holds an array of all pair items
  # satisfying the min_support and so on as long as min_support is satisified.

  # Perhaps an easier way to get an item_set immediately:
  apriori.item_sets_size(2)
  # gives the following array, representing all item sets of size two, satisfying
  # the min_support:
  # [[:product_a, :product_b], [:product_b, :product_d]]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

(The MIT License)

