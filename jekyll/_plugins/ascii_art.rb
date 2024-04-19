module Jekyll
  module Tags
    class AsciiArtBlock < Liquid::Block
      def initialize(tag_name, text, token)
        super
        if ['left', 'center', 'right'].include? text
          @align = text
        else
          @align = 'center'
        end
      end

      def escape_xhtml(text)
        # Note: > does not need to be escaped in XML content, but HTML4 spec
        # says "should escape" to avoid problems with older user agents
        # Note: Characters with restricted/discouraged usage are left unchanged
        text.gsub(/[&<>]|[^\u0009\u000A\u000D\u0020-\uD7FF\uE000-\uFFFD\u10000-\u10FFF]/) do | match |
          case match
          when '&' then '&amp;'
          when '<' then '&lt;'
          when '>' then '&gt;'
          else "&#x#{match.ord};"
          end
        end
      end

      def render(context)
        content = escape_xhtml(super(context))
        "<pre style=\"border: none; padding: 0;\">#{content}</pre>"
      end
    end
  end
end

Liquid::Template.register_tag('asciiart', Jekyll::Tags::AsciiArtBlock)
