/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#073642", /* black   */
  [1] = "#dc322f", /* red     */
  [2] = "#859900", /* green   */
  [3] = "#b58900", /* yellow  */
  [4] = "#268bd2", /* blue    */
  [5] = "#d33682", /* magenta */
  [6] = "#2aa198", /* cyan    */
  [7] = "#eee8d5", /* white   */

  /* 8 bright colors */
  [8]  = "#526160", /* black   */
  [9]  = "#cb3b16", /* red     */
  [10] = "#569152", /* green   */
  [11] = "#bfae3f", /* yellow  */
  [12] = "#5dabb2", /* blue    */
  [13] = "#b176ba", /* magenta */
  [14] = "#3bc3c3", /* cyan    */
  [15] = "#fdf6e3", /* white   */

  /* special colors */
  [256] = "#002b36", /* background */
  [257] = "#dcf0f0", /* foreground */
};

/*
 * Default colors (colorname index)
 * foreground, background, cursor
 */
static unsigned int defaultfg = 257;
static unsigned int defaultbg = 256;
static unsigned int defaultcs = 257;

/*
 * Colors used, when the specific fg == defaultfg. So in reverse mode this
 * will reverse too. Another logic would only make the simple feature too
 * complex.
 */
static unsigned int defaultitalic = 7;
static unsigned int defaultunderline = 7;
