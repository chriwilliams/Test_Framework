module StickyHelper

  # Get sticky value if the key exists
  # If sticky doesn't exist, call randomize_arg on the key in string format
  #  It will return string as is if doesn't contain a randomizer e.g. <r4>
  #  It will return a randomize value if the string does contain a randomizer
  # @param key [string] Input in string or symbol format
  def get_sticky(key)
    key = key.to_sym unless key.is_a? Symbol
    if $sticky.has_key? key
      $sticky[key]
    else
      $helpers.randomize_arg(key.to_s)
    end
  end

  # Set the sticky value for given key always overwriting existing value
  # @param key [string] Sticky key in string or symbol format
  # @param value [object] Sticky value can be any object
  def set_sticky(key, value)
    key = key.to_sym unless key.is_a? Symbol
    $sticky[key] = value
  end

  # removes all stickies from global hash
  def remove_all_stickies
    $sticky.clear if $sticky
  end

  # removes a sticky based on its key
  # @param key [string] Sticky key in string or symbol format
  def remove_sticky(key)
    key = key.to_sym unless key.is_a? Symbol
    $sticky.delete(key) if $sticky
  end

end

World(StickyHelper)
