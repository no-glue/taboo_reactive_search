require "taboo_reactive_search/version"

module TabooReactiveSearch
  class TabooReactiveSearch
    # get distance between cities
    def euc_2d(c1, c2)
      Math.sqrt((c2[0] - c1[0]) ** 2.0 + (c2[1] - c1[1]) ** 2.0).round
    end

    # cost
    def cost(shake, cities)
      distance = 0
      shake.each_with_index do |c1, i|
        c2 = (i == (shake.size - 1)) ? shake[0] : shake[i + 1]
        # +++ get distance between two cities
        distance += euc_2d cities[c1], cities[c2]
      end
      distance
    end

    # shake
    def shake(cities)
      shake = Array.new(cities.size){|i| i}
      shake.each_index do |i|
        r = rand(shake.size - 1) + 1
        shake[i], shake[r] = shake[r], shake[i]
      end
      shake
    end

    # reverse in range
    def two_opt(shake)
      perm = Array.new(shake)
      c1, c2 = rand(perm.size), rand(perm.size)
      collection = [c1]
      collection << ((c1 == 0 ? perm.size - 1 : c1 - 1))
      collection << ((c1 == perm.size - 1) ? 0 : c1 + 1)
      c2 = rand(perm.size) while collection.include? (c2)
      c1, c2 = c2, c1 if c2 < c1
      # +++ reverses in range
      perm[c1...c2] = perm[c1...c2].reverse
      return perm, [[shake[c1 - 1], shake[c1]], [shake[c2 - 1], shake[c2]]]
    end

    # is taboo
    def is_taboo?(edge, taboo_list, iter, prohib_period)
      taboo_list.each do |entry|
        if entry[:edge] = edge
          return true if entry[:iter] >= iter - prohib_period
          return false
        end
      end
      false
    end

    # make taboo
    def make_taboo(taboo_list, edge, iter)
      taboo_list.each do |entry|
        if entry[:edge] == edge
          entry[:iter] = iter
          return entry
        end
      end
      entry = {:edge => edge, :iter => iter}
      taboo_list.push(entry)
      entry
    end

    # to edge list
    def to_edge_list(shake)
      list = []
      shake.each_with_index do |c1, i|
        c2 = (i == (shake.size - 1)) ? shake[0] : shake[i + 1]
        c1, c2 = c2, c1 if c2 < c1
        list << [c1, c2]
      end
      list
    end

    # same
    def equivalent(el1, el2)
      el1.each {|e| return false if !el2.include?(e)}
      true
    end

    # get candidate
    def get_candidate(best, cities)
      candidate = {}
      candidate[:vector], edges = two_opt(best[:vector])
      candidate[:cost] = cost(candidate[:vector], cities)
      return candidate, edges
    end

    # get entry
    def get_candidate_entry(visited_list, shake)
      edge_list = to_edge_list(shake)
      visited_list.each do |entry|
        return entry if equivalent(edge_list, entry[:edge_list])
      end
      nil
    end

    # store shake
    def store_shake(visited_list, shake, iteration)
      entry = {}
      entry[:entry_list] = to_edge_list(shake)
      entry[:iter] = iteration
      entry[:visits] = 1
      visited_list.push(entry)
      entry
    end

    # sort hood
    def sort_neighborhood(candidates, taboo_list, prohib_period, iteration)
      taboo, admissable = [], []
      candidates.each do |a|
        if is_taboo?(a[1][0], taboo_list, iteration, prohib_period) or
          is_taboo?(a[1][1], taboo_list, iteration, prohib_period)
          taboo << a
        else
          admissable << a
        end
      end
      return [taboo, admissable]
    end

    # search
    def search(cities, max_cand, max_iter, increase, decrease)
      # setup
      current = {:vector => shake(cities)}
      current[:cost] = cost(current[:vector], cities)
      best = current
      taboo_list, prohib_period = [], 1
      max_iter.times do |iter|
        candidate_entry = get_candidate_entry()
        if !candidate_entry.nil?
          repetition_interval = iter - candidate_entry[:iter]
          candidate_entry[:iter] = iter
          candidate_entry[:visits] += 1
          if repetition_interval < 2 * (cities.size - 1)
            avg_size = 0.1 * (iter - candidate_entry[:iter]) + 0.9 * avg_size
            prohib_period = (prohib_period.to_f * increase)
            last_change = iter
          end
        else
          store_shake(visited_list, current[:vector], iter)
        end
        if iter - last_change > avg_size
          prohib_period = [prohib_period * decrease, 1].max
          last_change = iter
        end
        candidates = Array.new(max_cand) do |i|
          generate_candidate(current, cities)
        end
        candidates.sort!{|x, y| x.first[:cost] <=> y.first[:cost] }
        tabu, admis = sort_neighborhood(candidates, taboo_list, prohib_period, iter)
        if admis.size < 2
          prohib_period = cities.size - 2
          last_change = iter
        end
        current, best_move_edges = (admis.empty?) ? taboo.first : admis.first
        if !taboo.empty?
          tf = taboo.first[0]
          if tf[:cost] < best[:cost] and tf[:cost] < current[:cost]
            current, best_move_edges = taboo.first
          end
        end
        best_move_edges.each{|edge| make_taboo(taboo_list, edge, iter)}
        best = candidates.first[0] if candidates.first[0][:cost] < best[:cost]
        puts " > iter #{(iter + 1)}, best #{best[:cost]}"
      end
      best
    end
  end
end
