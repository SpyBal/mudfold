boot_bias_std <- function(x){
  boot.out <- x$BOOTSTRAP$BOOT
  index <- 1L:ncol(boot.out$t)
  sim <- boot.out$sim
  cl <- boot.out$call
  t <- matrix(boot.out$t[, index], nrow = nrow(boot.out$t))
  allNA <- apply(t, 2L, function(t) all(is.na(t)))
  ind1 <- index[allNA]
  index <- index[!allNA]
  t <- matrix(t[, !allNA], nrow = nrow(t))
  rn <- paste("t", index, "*", sep = "")
  if (length(index) == 0L) op <- NULL else if (is.null(t0 <- boot.out$t0)) {
    if (is.null(boot.out$call$weights)) 
      op <- cbind(apply(t, 2L, mean, na.rm = TRUE), sqrt(apply(t, 
                                                               2L, function(t.st) var(t.st[!is.na(t.st)]))))
    else {
      op <- NULL
      for (i in index) op <- rbind(op, imp.moments(boot.out, 
                                                   index = i)$rat)
      op[, 2L] <- sqrt(op[, 2])
    }
    dimnames(op) <- list(rn, c("mean", "std. error"))
  }else {
    t0 <- boot.out$t0[index]
    t0[is.na(t0)] <- 0
    if (is.null(boot.out$call$weights)) {
      op <- cbind( apply(t, 2L, mean, na.rm = TRUE) - 
                     t0, sqrt(apply(t, 2L, function(t.st) var(t.st[!is.na(t.st)]))))
      dimnames(op) <- list(rn, c( " bias  ", 
                                  " std. error"))
    }
    else {
      op <- NULL
      for (i in index) op <- rbind(op, imp.moments(boot.out, 
                                                   index = i)$rat)
      op <- cbind(op[, 1L] - t0, sqrt(op[, 2L]), apply(t, 
                                                       2L, mean, na.rm = TRUE))
      dimnames(op) <- list(rn, c( " bias  ", 
                                  " std. error", " mean(t*)"))
    }
  }
  return(op)
}