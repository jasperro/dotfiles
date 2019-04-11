static const char norm_fg[] = "#dbdde3";
static const char norm_bg[] = "#111513";
static const char norm_border[] = "#999a9e";

static const char sel_fg[] = "#dbdde3";
static const char sel_bg[] = "#5D9CC9";
static const char sel_border[] = "#dbdde3";

static const char urg_fg[] = "#dbdde3";
static const char urg_bg[] = "#6D8AA0";
static const char urg_border[] = "#6D8AA0";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
