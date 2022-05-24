require_relative 'lexer'
require 'readline'

def main()
    puts "csq v0.1.0"

    lexer = Lexer.new

    while buf = Readline.readline(">> ")
        p lexer.tokenize(buf)
    end
end

main