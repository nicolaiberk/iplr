red <- "\033[31m"
yellow <- "\033[33m"
light_gray <- "\033[37m"
magenta <- "\033[35m"
light_blue <- "\033[94m"
reset <- "\033[0m"

#' Prints a log message.
#'
#' Will quit on ERROR.
#'
#' @param msg Message
#' @param level DEBUG, INFO, WARNING, ERROR
#'
#' @export
ipl_log <- function(..., level, envir = parent.frame()) {
  levels <- c("DEBUG" = 0, "INFO" = 1, "WARNING" = 2, "ERROR" = 3)
  requested.level <- levels[level]
  if (is.na(requested.level)) {
    ipl_log(
      "level must be one of: ", paste(names(levels), collapse = ", "),
      ". Given level: ", level,
      level = "ERROR"
    )
  }

  # Attempt to find caller information
  caller_info <- tryCatch(
    {
      srcref <- attr(sys.call(-1), "srcref")
      srcfile <- attr(srcref, "srcfile")
      list(basename = basename(srcfile$filename), line = as.integer(srcref[1L]))
    },
    error = function(e) list(basename = "", line = "")
  )

  color.prefix <- ""
  color.reset <- ""
  if (level == "DEBUG") {
    color.prefix <- light_gray
    color.reset <- reset
  } else if (level == "INFO") {
    color.prefix <- light_blue
    color.reset <- reset
  } else if (level == "WARNING") {
    color.prefix <- yellow
    color.reset <- reset
  } else if (level == "ERROR") {
    color.prefix <- red
    color.reset <- reset
  }

  level.to.log <- Sys.getenv("LOG_LEVEL", "INFO") 
  should.log <- requested.level >= levels[level.to.log]
  if (should.log) {
    if (caller_info$basename == "") {
      prefix <- level 
      total.length <- 7
    } else {
      prefix <- paste0(level, "[", caller_info$basename, ":", caller_info$line, "]")
      total.length <- 40
    }
    prefix.length <- nchar(prefix)
    message(prefix.length)
    if (prefix.length <= total.length) {
      # Pad with spaces if shorter than total_length
      padded.prefix <- sprintf("%-*s", total.length, prefix)
    } else if (prefix.length > total.length) {
      # Truncate from the end of the basename if longer than total_length
      to.truncate <- prefix.length - total.length
      base_filename <- caller_info$basename
      truncated.basename <- substr(base_filename, to.truncate, nchar(base_filename))
      padded.prefix <- paste0(color.prefix, level, "[", truncated.basename, ":", caller_info$line, "]")
    } else {
      # Already the correct length
      padded.prefix <- prefix
    }
    cat(color.prefix, padded.prefix, ": ", ..., color.reset, "\n", sep = "")
  }
  if (level == "ERROR") {
    if (!interactive()) {
      quit(save = "no", status = 1, runLast = TRUE)
    } else {
      stop()
    }
  }
}

#' Prints a debug log message.
#'
#' @export
ipl_debug <- function(..., envir = parent.frame()) {
  ipl_log(..., level = "DEBUG")
}

#' Prints an info log message.
#'
#' @export
ipl_info <- function(..., envir = parent.frame()) {
  ipl_log(..., level = "INFO")
}

#' Prints a warning log message.
#'
#' @export
ipl_warning <- function(..., envir = parent.frame()) {
  ipl_log(..., level = "WARNING")
}

#' Prints a error log message.
#' This causes the program to exit.
#'
#' @export
ipl_error <- function(..., envir = parent.frame()) {
  ipl_log(..., level = "ERROR")
}

#' If condition isn't true, print a message at the specified log level
#'
#' @param condition Condition to check
#' @param msg Message
#' @param level
#'
#' @export
assert_or_log <- function(condition, msg = "Default Message", level = "ERROR") {
  if (!condition) {
    ipl_log(msg, level = level)
  }
}

#' If condition isn't true, error
#'
#' @param condition Condition to check
#' @param msg Message
#'
#' @export
assert_or_error <- function(condition, msg = "Default Message") {
  if (!condition) {
    ipl_log(msg, level = "ERROR")
  }
}
