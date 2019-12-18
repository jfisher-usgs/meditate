#' Read Session Information
#'
#' Read session data saved by the \code{\link{Meditate}} function and summarize this information.
#'
#' @param file 'character' string or '\link[base:connections]{connection}'.
#'   File to read session information.
#' @param tz 'character' string.
#'   Time zone to format date-time values,
#'   see \code{\link[base:timezones]{OlsonNames}} function for available names.
#'
#' @return An object of class 'sessions' that inherits behavior from the 'data.frame' class.
#'   A \code{print} method is provided for this class.
#'   Class 'sessions' is a data table with 2 variables:
#'   \code{start_date} is of class '\link[base:DateTimeClasses]{POSIXct}"
#'     and represents the date-time at the beginning of the meditation session; and
#'   \code{duration} is of class '\link[base:difftime]{difftime}'
#'     and represents the length of the session.
#'   Its attribute list includes:
#'   \describe{
#'     \item{\code{current_streak}}{current streak in days.}
#'     \item{\code{longest_streak}}{longest streak in days.}
#'     \item{\code{total_practice}}{number of days that included at least one session.}
#'     \item{\code{average_day}}{average session time per day in minutes.}
#'     \item{\code{average_session}}{average session time in minutes.}
#'     \item{\code{total_time}}{time meditating in days.}
#'     \item{\code{since}}{date of first session.}
#'   }
#'
#' @author J.C. Fisher
#'
#' @keywords IO
#'
#' @export
#'
#' @examples
#' file <- system.file("extdata/meditate-ex.csv", package = "meditate")
#' x <- meditate::ReadSessions(file)
#' x
#'
#' print.data.frame(x)
#'

ReadSessions <- function(file="meditate.csv", tz=Sys.timezone()) {

  checkmate::assertFileExists(file, access="r", extension="csv")
  checkmate::assertString(tz)
  checkmate::assertSubset(tz, OlsonNames())

  d <- utils::read.csv(file, colClasses=c("character", "numeric"))
  checkmate::assertDataFrame(d, any.missing=FALSE, min.rows=1, ncols=2)

  d[, 1] <- as.POSIXct(d[, 1], tz="UTC")
  attr(d[, 1], "tzone") <- tz
  d <- d[order(d[, 1]), ]
  d[, 2] <- as.difftime(d[, 2], units="mins")

  dates <- as.Date(d$start_time, tz=tz)
  is_current <- utils::tail(dates, 1) >= Sys.Date() - 1

  x <- rle(as.numeric(diff(unique(dates))))
  if (length(x) > 0 && is_current && utils::tail(x$values, 1) == 1)
    current_streak <- utils::tail(x$lengths, 1) + 1L
  else
    current_streak <- as.integer(is_current)

  x <- x$lengths[x$values == 1]
  if (length(x) > 0)
    longest_streak <- max(x) + 1L
  else
    longest_streak <- 1L

  total_practice <- length(unique(dates))

  x <- stats::aggregate(as.numeric(d$duration), by=list(dates), sum)$x
  average_day <- as.difftime(mean(x), units="mins")

  average_session <- mean(d$duration)

  total_time <- sum(d$duration)
  units(total_time) <- "days"

  since <- dates[1]

  structure(d,
            current_streak  = current_streak,
            longest_streak  = longest_streak,
            total_practice  = total_practice,
            average_day     = average_day,
            average_session = average_session,
            total_time      = total_time,
            since           = since,
            class           = append("sessions", class(d)))
}


#' @export

# print-method for 'session' information

print.sessions <- function(x, ...) {

  cat("Meditation Session Information\n")
  cat("------------------------------\n")
  cat(sprintf("Current streak: %s days\n",
              format(attr(x, "current_streak"), big.mark=",")))
  cat(sprintf("Longest streak: %s days\n",
              format(attr(x, "longest_streak"), big.mark=",")))
  cat(sprintf("Total practice: %s days\n",
              format(attr(x, "total_practice"), big.mark=",")))
  cat(sprintf("Average per day: %s\n",
              format(round(attr(x, "average_day"), 1))))
  cat(sprintf("Average per session: %s\n",
              format(round(attr(x, "average_session"), 1))))
  cat(sprintf("Time meditating: %s since %s\n",
              format(round(attr(x, "total_time"), 2), big.mark=",", nsmall=1),
              format(attr(x, "since"), "%b %d %Y")))

  cat("Latest sessions:\n")
  n <- 5L
  d <- as.data.frame(utils::tail(x, n + 1L))
  d[, 1] <- format(d[, 1], "%a, %b %d %Y %I:%M %p")
  d[, 2] <- sprintf("  %s", format(round(d[, 2], 1)))
  if (nrow(x) > n) d[1, ] <- rep("...", ncol(d))
  print(d, row.names=FALSE)

  invisible()
}
