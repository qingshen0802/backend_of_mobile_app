module PlayceletColors
	USED_COLORS = %w(
	)
	NAME_AND_CODES_LIST =%w(
		Red,#FF0000
 		Green,#00FF00
        Blue,#0000FF
        Turquoise,#00FFFF
        Yellow,#FFFF00
        White,#FFFFFF
        Magenta,#FF00FF
	).map{|n| n.split(',#')}.map{|n| {color_name: n.first, color: n.last}}
    NAMES_BY_COLOR = NAME_AND_CODES_LIST.inject({}){|memo, c| memo.merge(c[:color] => c[:color_name])}

	class << self
		def codes
			NAME_AND_CODES_LIST.map{|c| c[:color]}
		end

		def name_by_color(color)
			NAMES_BY_COLOR[color]
		end

		def options_for_select
			NAME_AND_CODES_LIST.map{|c| [c[:color_name], c[:color]]}
		end
	end
  
end