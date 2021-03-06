% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ReadSessions.R
\name{ReadSessions}
\alias{ReadSessions}
\title{Read Session Information}
\usage{
ReadSessions(file = "meditate.csv", tz = Sys.timezone())
}
\arguments{
\item{file}{'character' string or '\link[base:connections]{connection}'.
File to read session information.}

\item{tz}{'character' string.
Time zone to format date-time values,
see \code{\link[base:timezones]{OlsonNames}} function for available names.}
}
\value{
An object of class 'sessions' that inherits behavior from the 'data.frame' class.
  A \code{print} method is provided for this class.
  Class 'sessions' is a data table with 2 variables:
  \code{start_date} is of class '\link[base:DateTimeClasses]{POSIXct}"
    and represents the date-time at the beginning of the meditation session; and
  \code{duration} is of class '\link[base:difftime]{difftime}'
    and represents the length of the session.
  Its attribute list includes:
  \describe{
    \item{\code{current_streak}}{current streak in days.}
    \item{\code{longest_streak}}{longest streak in days.}
    \item{\code{total_practice}}{number of days that included at least one session.}
    \item{\code{average_day}}{average session time per day in minutes.}
    \item{\code{average_session}}{average session time in minutes.}
    \item{\code{total_time}}{time meditating in days.}
    \item{\code{since}}{date of first session.}
  }
}
\description{
Read session data saved by the \code{\link{Meditate}} function and summarize this information.
}
\examples{
file <- system.file("extdata/meditate-ex.csv", package = "meditate")
x <- meditate::ReadSessions(file)
x

print.data.frame(x)

}
\author{
J.C. Fisher
}
\keyword{IO}
