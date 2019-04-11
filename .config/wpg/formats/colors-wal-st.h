const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#111513", /* black   */
  [1] = "#6D8AA0", /* red     */
  [2] = "#5D9CC9", /* green   */
  [3] = "#96A0A8", /* yellow  */
  [4] = "#B7C5BA", /* blue    */
  [5] = "#AEB7C7", /* magenta */
  [6] = "#BBC4D1", /* cyan    */
  [7] = "#dbdde3", /* white   */

  /* 8 bright colors */
  [8]  = "#999a9e",  /* black   */
  [9]  = "#6D8AA0",  /* red     */
  [10] = "#5D9CC9", /* green   */
  [11] = "#96A0A8", /* yellow  */
  [12] = "#B7C5BA", /* blue    */
  [13] = "#AEB7C7", /* magenta */
  [14] = "#BBC4D1", /* cyan    */
  [15] = "#dbdde3", /* white   */

  /* special colors */
  [256] = "#111513", /* background */
  [257] = "#dbdde3", /* foreground */
  [258] = "#dbdde3",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
