local colors = {}

colors = {
    Light = {
        Text = {
            Primary = HSLToColor(0 ,0, 0.15),
            Secondary = HSLToColor(0, 0, 0.39),
            Tertiary = HSLToColor(0, 0, 0.55),
            Disable = HSLToColor(0, 0, 0.63)
        },

        Fill = {
            Stroke = HSLToColor(0, 0, 0.89),

            Card = {
                Primary = HSLToColor(0 ,0, 1),
                Secondary = HSLToColor(0 ,0, 98),
            },

            Accent = {
                Primary = Color(0, 95, 184),
                Secondary = Color(26, 111, 191),
                Tertiary = Color(51, 127, 198),
                Disable = HSLToColor(0, 0, 0.78)
            }
        }
    },

    Dark = {
        Text = {
            Primary = HSLToColor(0 ,0, 1),
            Secondary = HSLToColor(0, 0, 0.81),
            Tertiary = HSLToColor(0, 0, 0.62),
            Disable = HSLToColor(0, 0, 0.47)
        },

        Fill = {
            Stroke = HSLToColor(0, 0, 0.27),

            Card = {
                Primary = HSLToColor(0 ,0, 0.215),
                Secondary = HSLToColor(0, 0, 0.20)
            },

            Accent = {
                Primary = Color(96, 205, 255),
                Secondary = Color(91, 189, 233),
                Tertiary = Color(86, 173, 213),
                Disable = HSLToColor(0, 0, 0.30)
            }
        }
    }
}

RiceUI.ThemeNT.DefineColors("modern_nt", colors)