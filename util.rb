def numeric?(input)
    input =~ /[0-9]/
end

def alphabetic?(input)
    input =~ /[A-Za-z]/
end

def keyword?(input)
    ["sort", "asc", "desc", "contains", "pluck", "open"].include?(input)
end