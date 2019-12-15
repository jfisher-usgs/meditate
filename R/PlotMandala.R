#' Plot Mandala
#'
#' Draw a colored mandala using Voronoi tessellation and a Wes Anderson color palette.
#'
#' @param radius 'numeric' vector of length 1 or 2.
#'   Factor of expansion or compression.
#'   A random-number generator may be used by defining the
#'   lower and upper limits of a uniform distribution.
#' @param npoints 'integer' count.
#'   Number of points
#' @param depth 'integer' count.
#'   Number of iterations
#' @param scheme 'character' vector.
#'   Name of color palette(s) to choose from, see
#'   \code{\link[wesanderson:wes_palette]{wes_palette}} function for choices.
#'   By default, specified using a random selection from all possible palettes.
#' @param seed 'integer' count.
#'   Random number generator state, used to replicate the results.
#'
#' @return Invisible \code{NULL}
#'
#' @author J.C. Fisher
#'
#' @keywords hplot
#'
#' @references This function was derived from the
#'   \href{https://github.com/aschinchon/mandalas-colored}{mandalas-colored}
#'   script by A.S. Chinchón, accessed on Dec 13, 2019.
#'
#' @export
#'
#' @examples
#' PlotMandala(seed = 222)
#'
#' \dontrun{
#' grDevices::png("mandala.png")
#' PlotMandala()
#' grDevices::dev.off()
#' }
#'

# MIT License
#
# Copyright (c) 2018 Antonio Sánchez Chinchón
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

PlotMandala <- function(radius=c(0.6, 1.8), npoints=14L, depth=3L,
                        scheme=NULL, seed=NULL) {

  checkmate::assertNumeric(radius, finite=TRUE, any.missing=FALSE,
                           min.len=1, max.len=2, sorted=TRUE)
  checkmate::assertInt(npoints, lower=4)
  checkmate::assertInt(depth, lower=2)
  checkmate::assertCharacter(scheme, any.missing=FALSE, min.len=1,
                             unique=TRUE, null.ok=TRUE)
  checkmate::assertInt(seed, null.ok=TRUE)

  if (!is.null(seed)) set.seed(seed)

  choices <- names(wesanderson::wes_palettes)
  if (!is.null(scheme))
    choices <- match.arg(scheme, choices, several.ok=TRUE)
  scheme <- sample(choices, 1)

  ang <- seq(0, 2 * pi * (1 - 1 / npoints), length.out=npoints) + pi / 2

  if (length(radius) == 2)
    r <- stats::runif(1, min=radius[1], max=radius[2])
  else
    r <- radius

  itr <- 0L
  repeat {
    itr <- itr + 1L
    if (itr > 100L) stop()
    d <- data.frame(x=0, y=0)
    for (k in seq_len(depth)) {
      tmp <- data.frame()
      for (i in seq_len(nrow(d))) {
        tmp <- rbind(data.frame(x=d[i, "x"] + r^(k - 1) * cos(ang),
                                y=d[i, "y"] + r^(k - 1) * sin(ang)), tmp)
      }
      d <- tmp
    }
    l <- try({
      suppressMessages(deldir::tile.list(deldir::deldir(d, suppressMsge=TRUE)))
    }, silent=TRUE)
    if (inherits(l, "tile.list")) break
    r <- r + sample(c(-1, 1), 1) * 0.001
  }

  l <- l[vapply(l, function(x) sum(x$bp) == 0, TRUE)]
  l <- l[vapply(l, function(x) {
    length(intersect(which(x$x == 0), which(x$y == 0))) == 0
  }, TRUE)]

  area <- vapply(l, function(x) x$area, 0)
  xy   <- lapply(l, function(x) x[c("x", "y")])

  idx <- order(area)
  xy <- xy[idx]
  area <- area[idx]

  pal <- wesanderson::wes_palette(scheme)
  pal <- sample(pal, length(pal))

  idx <- cumsum(c(TRUE, diff(area) != 0))
  col <- grDevices::colorRampPalette(pal)(max(idx))
  col <- col[idx[seq_along(xy)]]

  xlim <- range(unlist(lapply(xy, function(x) x[["x"]])))
  ylim <- range(unlist(lapply(xy, function(x) x[["y"]])))

  op <- graphics::par(mar=c(0, 0, 0, 0))
  on.exit(graphics::par(op))
  graphics::plot.default(NA, type="n", xlim=xlim, ylim=ylim, main="",
                         xaxs="i", yaxs="i", bty="n", xaxt="n", yaxt="n",
                         xlab="", ylab="", asp=1)
  for (i in seq_len(length(xy))) {
    graphics::polygon(xy[[i]], col=col[i], border="#5E5E5E", lwd=0.25)
  }

  invisible()
}
