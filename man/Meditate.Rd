% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Meditate.R
\name{Meditate}
\alias{Meditate}
\title{Run Meditation Timer}
\usage{
Meditate(
  duration = 20,
  interval = NULL,
  repeats = TRUE,
  sound = TRUE,
  preparation = 10,
  file = "meditate.csv",
  mandala = FALSE,
  ...,
  user_stops = FALSE
)
}
\arguments{
\item{duration}{'numeric' number.
Meditation time in minutes.}

\item{interval}{'numeric' number.
Interval time in minutes.}

\item{repeats}{'logical' flag.
Whether to repeat the time interval.}

\item{sound}{'logical' flag.
Whether to include a start, end, and interval sound.
Requires access to an \link[audio:audio.drivers]{audio driver}.}

\item{preparation}{'numeric' number.
Preparation time in seconds.}

\item{file}{'character' string or '\link[base:connections]{connection}'.
File to write session information---new data records
will be appended to this comma-separated values (CSV) file.
A data record consists of a session's start time in
Coordinated Universal Time (UTC) and duration in minutes.}

\item{mandala}{'logical' flag.
Whether to plot a mandala.}

\item{...}{Arguments passed to the \code{\link{PlotMandala}} function.}

\item{user_stops}{'logical' flag.
Whether to manually stop the session timer.
Allows for extended meditation.}
}
\value{
Invisible \code{NULL}
}
\description{
A simple meditation timer that logs session information.
}
\examples{
meditate::Meditate(0.1, sound = FALSE, preparation = NULL, file = NULL)

\dontrun{
# Begin a 10-minute meditation session with mandala:
meditate::Meditate(10, mandala = TRUE)
}

}
\seealso{
\code{\link{ReadSessions}} function to read and summarize the
  exported session information back into \R.
}
\author{
J.C. Fisher
}
\keyword{misc}
