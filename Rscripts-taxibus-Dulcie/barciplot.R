barci <- function(x, y, data, xlab=deparse(substitute(x)),
                  ylab=deparse(substitute(y)), main=NULL, ylim=c(NA, NA),
                  breaks=c(NA, NA), error="cl", ...) {

  # argument and variable handling - taken directly from ggplot's qplot code
  argnames <- names(as.list(match.call(expand.dots=FALSE)[-1]))
  arguments <- as.list(match.call()[-1])
  aesthetics <- compact(arguments)
  aesthetics <- aesthetics[!is.constant(aesthetics)]
  aes_names <- names(aesthetics)
  aesthetics <- rename_aes(aesthetics)
  class(aesthetics) <- "uneval"

  # getting the range and the breaks to use on the y axis - only used if
  # ylim and breaks not specified as options
  yrange <- range(eval(aesthetics$y, env=data))
  ydigits <- as.numeric(prettyNum(diff(yrange)/5, digits=2))

  yrange <- yrange - yrange %% ydigits
  yrange[2] <- yrange[2] + ydigits

  ysteps <- seq(yrange[1], yrange[2], ydigits*2)
  
  env <- parent.frame()

  # work around an apparent bug with widths:
  dodge <- position_dodge(width=0.9)
  width=0.3
  #if (hasArg("fill")) width=NULL

  errorfunc = "mean_cl_boot"
  if (error == "sd") {
    errorfunc <- function(x) {
      m <- mean(x)
      u <- m + sd(x)
      l <- m - sd(x)
      return(data.frame(ymin=l, ymax=u))
    }
  }
  else if (error == "sem") {
    errorfunc <- function(x) {
      m <- mean(x)
      u <- m + (sd(x)/sqrt(length(x)))
      l <- m - (sd(x)/sqrt(length(x)))
      return(data.frame(ymin=l, ymax=u))
    }
  }

  if (!is.na(breaks[1])) ysteps <- breaks
  if (!is.na(ylim[1])) yrange <- ylim
  
  # the actual plotting commands - barplot representing the mean
  # plus bootstrapped 95% confidence interval error-bar
  p <- ggplot(data, aesthetics, environment=env)
  p <- p + stat_summary(fun.y=mean, geom="bar", alpha=0.5, position=dodge)
  p <- p + stat_summary(fun.data=errorfunc, width=width, geom="errorbar",
                        position=dodge)
  p <- p + scale_y_continuous(breaks=ysteps)
  p <- p + coord_cartesian(ylim=yrange)

  # set axis names and titles
  yscale <- p$scales$get_scales("y")
  xscale <- p$scales$get_scales("x")

  if (!missing(xlab)) xscale$name <- xlab
  if (!missing(ylab)) yscale$name <- ylab
  if (!is.null(main)) p <- p + opts("title" = main)
  
  return(p)
}
