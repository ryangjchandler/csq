require_relative 'util'

class UnrecognisedTokenError < StandardError
end

class InvalidNumericRepresentation < StandardError
end

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
    EOF = 'EOF'
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
        while i < chars.count do
            char = chars[i]
            i += 1

            next if char.include?(' ')

            if alphabetic?(char)
                word = char

                while i < chars.count && alphabetic?(chars[i]) do
                    word += chars[i]
                    i += 1
                end

                tokens.append(Token.new(TokenType::IDENT, word))
            elsif numeric?(char)
                number = char

                while i < chars.count && (numeric?(chars[i]) || chars[i] == '.') do
                    if chars[i] == '.' && number.include?('.')
                        raise InvalidNumericRepresentation.new("Numeric value already contains a period.")
                    end

                    number += chars[i]
                    i += 1
                end

                tokens.append(Token.new(TokenType::NUMBER, number))
            else
                raise UnrecognisedTokenError.new("Unrecognised character #{char}.")
            end
        end

        tokens.append(Token.new(TokenType::EOF, nil))
        tokens
    end
end