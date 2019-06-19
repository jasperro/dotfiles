const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#120c08", /* black   */
  [1] = "#635352", /* red     */
  [2] = "#9D4827", /* green   */
  [3] = "#97592F", /* yellow  */
  [4] = "#9D6C54", /* blue    */
  [5] = "#7C852C", /* magenta */
  [6] = "#AD9753", /* cyan    */
  [7] = "#d7c89f", /* white   */

  /* 8 bright colors */
  [8]  = "#968c6f",  /* black   */
  [9]  = "#635352",  /* red     */
  [10] = "#9D4827", /* green   */
  [11] = "#97592F", /* yellow  */
  [12] = "#9D6C54", /* blue    */
  [13] = "#7C852C", /* magenta */
  [14] = "#AD9753", /* cyan    */
  [15] = "#d7c89f", /* white   */

  /* special colors */
  [256] = "#120c08", /* background */
  [257] = "#d7c89f", /* foreground */
  [258] = "#d7c89f",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
