module TokenType
    IDENT = 'IDENT'
    SORT = 'SORT'
    ASC = 'ASC'
    DESC = 'DESC'
    CONTAINS = 'CONTAINS'
    PIPE = 'PIPE'
    COMMA = 'COMMA'
    PLUCK = 'PLUCK'
    OPEN = 'OPEN'
    STRING = 'STRING'
    NUMBER = 'NUMBER'
end

class Token
    attr_accessor :type, :literal

    def initialize(type, literal)
        @type = type
        @literal = literal
    end
end

class Lexer
    def tokenize(source)
        tokens = []
        chars = source.chars

        return tokens if chars.count == 0

        i = 0
        while i < chars.count
            char = chars[i]
            i += 1

            next if char.include?(' ')

            tokens.append(char)
        end

        tokens
    end
end