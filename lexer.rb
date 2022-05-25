require_relative 'util'

class UnrecognisedTokenError < StandardError
end

class InvalidNumericRepresentation < StandardError
end

class UnterminatedStringError < StandardError
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

                if ! keyword?(word)
                    tokens.append(Token.new(TokenType::IDENT, word))
                else
                    tokens.append(Token.new({
                        "sort" => TokenType::SORT,
                        "asc" => TokenType::ASC,
                        "desc" => TokenType::DESC,
                        "contains" => TokenType::CONTAINS,
                        "pluck" => TokenType::PLUCK,
                        "open" => TokenType::OPEN,
                    }[word], word))
                end
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
            elsif char == '|'
                tokens.append(Token.new(TokenType::PIPE, '|'))
            elsif char == ','
                tokens.append(Token.new(TokenType::COMMA, ','))
            elsif char == "\""
                str = ""
                escaping = false

                loop do
                    c = chars[i]
                    i += 1

                    if c == "\"" && escaping == false
                        break
                    end

                    if c == nil
                        raise UnterminatedStringError.new("Unterminated string.")
                    end

                    if c == "\\"
                        escaping = true
                    else
                        str += c
                        escaping = false
                    end
                end

                tokens.append(Token.new(TokenType::STRING, str))
            else
                raise UnrecognisedTokenError.new("Unrecognised character #{char}.")
            end
        end

        tokens.append(Token.new(TokenType::EOF, nil))
        tokens
    end
end