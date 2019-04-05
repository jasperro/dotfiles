static const char norm_fg[] = "#dcdad2";
static const char norm_bg[] = "#090B05";
static const char norm_border[] = "#9a9893";

static const char sel_fg[] = "#dcdad2";
static const char sel_bg[] = "#7C8474";
static const char sel_border[] = "#dcdad2";

static const char urg_fg[] = "#dcdad2";
static const char urg_bg[] = "#CC5E46";
static const char urg_border[] = "#CC5E46";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
