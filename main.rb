require_relative 'lexer'
require_relative 'parser'
require 'readline'

def main()
    puts "csq v0.1.0"

    lexer = Lexer.new
    parser = Parser.new

    while buf = Readline.readline(">> ")
        tokens = lexer.tokenize(buf)
        ast = parser.parse(tokens)
        p ast
    end
end

main