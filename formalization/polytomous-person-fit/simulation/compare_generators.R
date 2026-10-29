# Two Monte Carlo files, aberrant-direction grand rates, two-SE and Holm.
# Rscript compare_generators.R mirt.csv hand.csv out
args <- commandArgs(trailingOnly = TRUE)
a <- read.csv(args[[1]], stringsAsFactors = FALSE)
b <- read.csv(args[[2]], stringsAsFactors = FALSE)
out <- if (length(args) >= 3) args[[3]] else "out"
a <- a[!is.na(a$bias), ]
b <- b[!is.na(b$bias), ]
cols <- c(G_upper_sens = "sens", G_upper_spec = "spec", G_upper_ppv = "ppv", G_upper_npv = "npv",
          H_lower_sens = "sens", H_lower_spec = "spec", H_lower_ppv = "ppv", H_lower_npv = "npv",
          U3_upper_sens = "sens", U3_upper_spec = "spec", U3_upper_ppv = "ppv", U3_upper_npv = "npv")
rows <- list()
for (col in names(cols)) {
  for (bias in unique(a$bias)) {
    aa <- a[a$bias == bias, ]
    bb <- b[b$bias == bias, ]
    keya <- interaction(aa$k, aa$dim, aa$length, drop = TRUE)
    keyb <- interaction(bb$k, bb$dim, bb$length, drop = TRUE)
    ma <- tapply(aa[[col]], keya, mean)
    mb <- tapply(bb[[col]], keyb, mean)
    sa <- tapply(aa[[col]], keya, stats::sd)
    sb <- tapply(bb[[col]], keyb, stats::sd)
    na <- tapply(aa[[col]], keya, length)
    nb <- tapply(bb[[col]], keyb, length)
    common <- intersect(names(ma), names(mb))
    va <- sa[common]^2 / na[common]
    vb <- sb[common]^2 / nb[common]
    va[!is.finite(va)] <- 0
    vb[!is.finite(vb)] <- 0
    diff <- mean(ma[common] - mb[common])
    se <- sqrt(sum(va + vb) / length(common)^2)
    z <- if (se == 0) (if (abs(diff) < 1e-12) 0 else Inf) else abs(diff) / se
    p <- if (is.infinite(z)) 0 else 2 * stats::pnorm(-z)
    rows[[length(rows) + 1L]] <- data.frame(
      column = col, outcome = cols[[col]], bias = bias,
      mirt = mean(ma[common]), hand = mean(mb[common]),
      diff = diff, se = se, z = z, p = p, stringsAsFactors = FALSE)
  }
}
tab <- do.call(rbind, rows)
tab$p_holm <- NA_real_
for (oc in unique(tab$outcome)) {
  ix <- tab$outcome == oc
  tab$p_holm[ix] <- p.adjust(tab$p[ix], method = "holm")
}
tab$raw_band <- ifelse(!is.finite(tab$z), "no match",
                       ifelse(tab$z <= 2, "match", ifelse(tab$z <= 3, "close", "no match")))
tab$holm_band <- ifelse(tab$p_holm >= 0.05, "match", "no match")
utils::write.csv(tab, file.path(out, "generator_compare.csv"), row.names = FALSE)
print(tab[tab$outcome == "sens", c("column", "bias", "mirt", "hand", "diff", "se", "raw_band", "holm_band")],
      digits = 4, row.names = FALSE)
cat("\n")
print(table(tab$outcome, tab$raw_band))
cat("Holm\n")
print(table(tab$outcome, tab$holm_band))
