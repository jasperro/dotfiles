const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#090B05", /* black   */
  [1] = "#CC5E46", /* red     */
  [2] = "#7C8474", /* green   */
  [3] = "#958A74", /* yellow  */
  [4] = "#E08872", /* blue    */
  [5] = "#ABA798", /* magenta */
  [6] = "#C7B6A7", /* cyan    */
  [7] = "#dcdad2", /* white   */

  /* 8 bright colors */
  [8]  = "#9a9893",  /* black   */
  [9]  = "#CC5E46",  /* red     */
  [10] = "#7C8474", /* green   */
  [11] = "#958A74", /* yellow  */
  [12] = "#E08872", /* blue    */
  [13] = "#ABA798", /* magenta */
  [14] = "#C7B6A7", /* cyan    */
  [15] = "#dcdad2", /* white   */

  /* special colors */
  [256] = "#090B05", /* background */
  [257] = "#dcdad2", /* foreground */
  [258] = "#dcdad2",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
