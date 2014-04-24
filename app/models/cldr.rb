class Cldr
  # even though the plurals are duplicated for some cases, the plural rules differentiate them 
  cldr_types = {:east_slavic=>%w(one few many other), 
                :one_other => %w(one other),
                :one_upto_two_other=>%w(one other), 
                :one_two_other =>%w(one two other),
                :onewithzero_other =>%w(one other),
                :other =>%w(other),
                :romanian =>%w(one few other),
                :west_slavic =>%w(one few other)
              }
end