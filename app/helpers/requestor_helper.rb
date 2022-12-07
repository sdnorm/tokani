module RequestorHelper
  def roles_readable(roles_hash)
    roles_hash.map { |entry| entry[0].titleize if entry[1] == true }.compact.join(", ").to_s
  end
end
