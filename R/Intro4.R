
local({
  .Table <- data.frame(Probability=dbinom(0:10, size=10, prob=0.2))
  rownames(.Table) <- 0:10 
  print(.Table)
})
local({
  .Table <- data.frame(Probability=dhyper(0:2, m=3, n=2, k=2))
  rownames(.Table) <- 0:2 
  print(.Table)
})
local({
  .Table <- data.frame(Probability=dpois(0:16, lambda=6))
  rownames(.Table) <- 0:16 
  print(.Table)
})
pnorm(c(90), mean=110, sd=10, lower.tail=TRUE)

