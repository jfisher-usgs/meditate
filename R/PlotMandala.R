#' Plot Mandala
#'
#' Draw a colored mandala using Voronoi tessellation and a Wes Anderson color palette.
#'
#' @param radius 'numeric' vector of length 1 or 2.
#'   Factor of expansion or compression.
#'   A random-number generator may be used by defining the
#'   lower and upper limits of a uniform distribution.
#' @param npoints 'integer' vector.
#'   Number of points is randomly selected from this argument.
#' @param depth 'integer' vector.
#'   Number of iterations is randomly selected from this argument.
#' @param scheme 'character' vector.
#'   Name of color palette(s) to choose from, see
#'   \code{\link[wesanderson:wes_palette]{wes_palette}} function for choices.
#'   By default, specified using a random selection from all possible palettes.
#' @param mar 'numeric' vector of length 4.
#'   Number of lines of margin to be specified on the bottom, left, top, and right side of the plot.
#' @param seed 'integer' count.
#'   Random number generator state, used to replicate the mandala.
#'
#' @details
#'   \if{html}{\figure{mandala.svg}{options: width=480px}}
#'   \if{latex}{\figure{mandala.pdf}{options: width=4in}}
#'
#' @return Invisible \code{NULL}
#'
#' @author J.C. Fisher
#'
#' @keywords hplot
#'
#' @references This function was derived from the
#'   \href{https://github.com/aschinchon/mandalas-colored}{mandalas-colored}
#'   \R script by A.S. Chinchón, accessed on Dec 13, 2019.
#'
#' @export
#'
#' @examples
#' meditate::PlotMandala()
#'
#' \dontrun{
#' for (seed in sample.int(1e8, 100)) {
#'   cat("seed =", seed, "\n")
#'   meditate::PlotMandala(seed = seed)
#'   ans <- if (interactive()) readline("continue? [Y/n]: ") else "n"
#'   if (tolower(substr(ans, 1, 1)) == "n") break
#' }
#'
#' svglite::svglite("mandala.svg", width = 7, height = 7, bg = "transparent")
#' meditate::PlotMandala(seed = 8471)
#' grDevices::dev.off()
#'
#' grDevices::pdf("mandala.pdf")
#' meditate::PlotMandala(seed = 8471)
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

PlotMandala <- function(radius=c(1.1, 1.8), npoints=14L, depth=3L,
                        scheme=NULL, mar=c(0, 0, 0, 0), seed=NULL) {

  checkmate::assertNumeric(radius, finite=TRUE, any.missing=FALSE,
                           min.len=1, max.len=2, unique=TRUE, sorted=TRUE)
  checkmate::assertIntegerish(npoints, lower=4, any.missing=FALSE, min.len=1)
  checkmate::assertIntegerish(depth, lower=2, any.missing=FALSE, min.len=1)
  checkmate::assertCharacter(scheme, any.missing=FALSE, min.len=1,
                             unique=TRUE, null.ok=TRUE)
  checkmate::assertNumeric(mar, lower=0, finite=TRUE, any.missing=FALSE, len=4)
  checkmate::assertInt(seed, null.ok=TRUE)

  if (!is.null(seed)) set.seed(seed)

  choices <- names(wesanderson::wes_palettes)
  if (!is.null(scheme))
    choices <- match.arg(scheme, choices, several.ok=TRUE)
  scheme <- sample(choices, 1)

  if (length(radius) > 1)
    radius <- stats::runif(1, min=radius[1], max=radius[2])
  if (length(npoints) > 1)
    npoints <- sample(npoints, 1)
  if (length(depth) > 1)
    depth <- sample(depth, 1)

  ang <- seq(0, 2 * pi * (1 - 1 / npoints), length.out=npoints) + pi / 2

  itr <- 0L
  repeat {
    itr <- itr + 1L
    if (itr > 100L) stop("maximum number of iterations exceeded")

    pnt <- list(x=0, y=0)
    for (k in seq_len(depth)) {
      x <- as.numeric()
      y <- as.numeric()
      for (i in seq_along(pnt$x)) {
        x <- c(pnt$x[i] + radius^(k - 1) * cos(ang), x)
        y <- c(pnt$y[i] + radius^(k - 1) * sin(ang), y)
      }
      pnt$x <- x
      pnt$y <- y
    }

    cell <- try({
      suppressMessages(deldir::tile.list(deldir::deldir(pnt, suppressMsge=TRUE)))
    }, silent=TRUE)
    if (inherits(cell, "tile.list")) break

    radius <- radius + sample(c(-1, 1), 1) * 0.001
  }

  cell <- cell[vapply(cell, function(x) sum(x$bp) == 0, TRUE)]
  cell <- cell[vapply(cell, function(x) {
    length(intersect(which(x$x == 0), which(x$y == 0))) == 0
  }, TRUE)]

  area <- vapply(cell, function(x) x$area, 0)
  xy   <- lapply(cell, function(x) x[c("x", "y")])

  idx <- order(area)
  xy <- xy[idx]
  area <- area[idx]

  idx <- cumsum(c(TRUE, diff(area) != 0))
  pal <- wesanderson::wes_palette(scheme, max(idx), type="continuous")
  pal <- sample(pal, length(pal))
  col <- pal[idx[seq_along(xy)]]

  xlim <- range(unlist(lapply(xy, function(x) x[["x"]])))
  ylim <- range(unlist(lapply(xy, function(x) x[["y"]])))

  op <- graphics::par(mar=mar)
  on.exit(graphics::par(op))
  graphics::plot.default(NA, type="n", xlim=xlim, ylim=ylim, main="",
                         xaxs="i", yaxs="i", bty="n", xaxt="n", yaxt="n",
                         xlab="", ylab="", asp=1)
  for (i in seq_len(length(xy))) {
    graphics::polygon(xy[[i]], col=col[i], border="#5E5E5E", lwd=0.25)
  }

  invisible()
}
