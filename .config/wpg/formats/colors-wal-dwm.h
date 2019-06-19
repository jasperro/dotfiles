static const char norm_fg[] = "#d7c89f";
static const char norm_bg[] = "#120c08";
static const char norm_border[] = "#968c6f";

static const char sel_fg[] = "#d7c89f";
static const char sel_bg[] = "#9D4827";
static const char sel_border[] = "#d7c89f";

static const char urg_fg[] = "#d7c89f";
static const char urg_bg[] = "#635352";
static const char urg_border[] = "#635352";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
