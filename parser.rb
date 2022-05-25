require_relative "lexer"

class InvalidTokenError < StandardError
end

class SortNode
    attr_accessor :column, :order
    def initialize(column, order = "asc")
        @column = column
        @order = order
    end
end

class OpenNode
    attr_accessor :file
    def initialize(file)
        @file = file
    end
end

class Parser
    def parse(tokens)
        ast = []

        return ast if tokens.count == 0

        i = 0
        while i < tokens.count do
            token = tokens[i]
            i += 1

            break if token.type == TokenType::EOF

            if token.type == TokenType::SORT
                column = tokens[i]

                expect?([TokenType::IDENT, TokenType::STRING], column)
                i += 1

                order = "asc"
                if tokens[i] != nil && [TokenType::ASC, TokenType::DESC].include?(tokens[i].type)
                    order = tokens[i].literal
                    i += 1
                end

                ast.append(SortNode.new(column, order))
            elsif token.type == TokenType::OPEN
                file = tokens[i]

                expect?(TokenType::STRING, file)
                i += 1

                ast.append(OpenNode.new(file.literal))
            end
        end

        ast
    end
end

def expect?(expected, actual)
    if ! expected.kind_of?(Array)
        expected = [expected]
    end

    if actual == nil || ! expected.include?(actual.type)
        raise InvalidTokenError.new("Expected #{expected.join(' | ')}, got #{actual.type}.")
    end
end