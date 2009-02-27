ARGV.each do |v|
  str = open(v).read

  out = open(v, "w")
  str.each_line do |line|
    break if /^\#\~/ =~ line
    out.write line
  end
  out.close
end

