module Merit
  # Rules has a badge name and level, a target to badge, a conditions block
  # and a temporary option.
  # Could split this class between badges and rankings functionality
  class Rule
    attr_accessor :badge_id, :badge_name, :level, :to, :model_name, :level_name,
                  :multiple, :temporary, :score, :block, :category

    # Does this rule's condition block apply?
    def applies?(*args)
      return true if block.nil? # no block given: always true
      # target_obj , user_id = *args
      case block.arity
      when 0
        block.call
      else
        unless args.empty?
          block.call(*args)
        else
          Rails.logger.warn '[merit] no args found on Rule#applies?'
          false
        end
      end
    end

    # Get rule's related Badge.
    def badge
      if badge_id
        Merit::Badge.find(badge_id)
      else
        Merit::Badge.find_by_name_and_level(badge_name, level)
      end
    end
  end
end
