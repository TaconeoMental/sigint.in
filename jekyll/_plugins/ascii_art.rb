module Jekyll
  module Tags
    class AsciiArtBlock < Liquid::Block
      def initialize(tag_name, text, token)
        super
        # Argument format: (left|right|center), (\d|[a-zA-Z0-9_]+)
        align, padding = text.split(',').map(&:strip)
        @align = align || ''
        @padding = padding
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

      def normalize_lengths(text)
        # Normalize line lengths to maintain picture's shape when right aligned
        lines = text.lines.map(&:chomp).map(&:rstrip)
        if lines[0].empty?
          lines = lines.drop(1)
        end
        max_length = lines.map(&:length).max
        padded_lines = lines.map { |line| line.ljust(max_length) }
        padded_lines.join("\n")
      end

      def apply_padding(text, align, padding)
        lines = text.lines.map(&:chomp).map(&:rstrip)
        padded_lines = lines.map do |line|
          if align == 'left'
            line = line.prepend(" " * padding)
          elsif align == 'right'
            line = line.concat(" " * padding)
          end
          line
        end
        padded_lines.join("\n")
      end

      def get_padding(ctx)
        padding_int = Integer(@padding, exception: false)
        # Test if argument passed is an integer or a variable in the ctx's
        # namespace. Set the padding as 10 otherwise
        padding_int || ctx[@padding] || ctx["asciiart_padding"] || 0
      end

      def get_align(ctx)
        if ['left', 'center', 'right'].include?(@align)
          return @align
        end
        ctx[@align] || ctx["asciiart_align"] || 'center'
      end

      def render(context)
        real_padding = get_padding(context)
        real_align = get_align(context)
        content = normalize_lengths(escape_xhtml(super(context)))
        content = apply_padding(content, align=real_align, padding=real_padding)
        "<pre class=\"ascii-art-#{real_align}\">#{content}</pre>"
      end
    end
  end
end

Liquid::Template.register_tag('asciiart', Jekyll::Tags::AsciiArtBlock)
