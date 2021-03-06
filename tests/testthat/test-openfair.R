context("Sample TEF")
test_that("Sample TEF", {
  set.seed(1234)
  tef <- sample_tef(params = list(10, 1, 10, 100))
  expect_is(tef, "list")
  # ensure that the list has the required elements
  expect_equal(names(tef), c("type", "samples", "details"))
  # ensure that the samples matches the number requested
  expect_equal(length(tef$samples), 10)
  # ensure that TEF values are returned as integers
  expect_is(tef$samples, "integer")
  # ensure that values of samples is correct
  expect_equal(unlist(tef$samples),
               c(7, 30, 2, 34, 36, 13, 14, 14, 9, 15))
})

context("Sample DIFF")
test_that("Sample DIFF", {
  set.seed(1234)
  dat <- sample_diff(params = list(10, 50, 70, 75, 3))
  expect_is(dat, "list")
  # ensure that the list has the required elements
  expect_equal(names(dat), c("type", "samples", "details"))
  # ensure that the samples matches the number requested
  expect_equal(length(dat$samples), 10)
  # ensure that values of samples is correct
  expect_equal(signif(unlist(dat$samples), digits = 4),
               signif(c(72.5519454551502, 65.1852603020272, 59.1564180836877,
                        74.5816023178688, 64.1192226440207, 63.561355776164,
                        70.1284833577168, 69.9960887031119, 70.0802721600923,
                        71.4683219144408), digits = 4))
})
test_that("Multi control diff works", {
  diff_estimates <- data_frame(l = c(1, 2), ml = c(10, 15), h = c(20, 100),
                               conf = c(1, 3))
})

context("Sample TC")
test_that("Sample TC", {
  set.seed(1234)
  tc <- sample_tc(params = list(10, 50, 75, 100, 4))
  expect_is(tc, "list")
  # ensure that the list has the required elements
  expect_equal(names(tc), c("type", "samples", "details"))
  # ensure that the samples matches the number requested
  expect_equal(length(tc$samples), 10)
  # ensure that values of samples is correct
  expect_equal(signif(unlist(tc$samples), digits = 4),
               signif(c(61.7026564773373, 78.188740471894, 87.0623477417219,
                        53.1987199785052, 79.9184628308895, 80.7889924652588,
                        68.4387021948896, 68.7541469869603, 68.554057026653,
                        64.9764652390671), digits = 4))
})

context("Sample VULN")
test_that("Sample VULN works with binom", {
  set.seed(1234)
  dat <- sample_vuln(params = list(10, 1, .5))
  expect_is(dat, "list")
  # ensure that the list has the required elements
  expect_equal(names(dat), c("type", "samples", "details"))
  # ensure that the samples matches the number requested
  expect_equal(length(dat$samples), 10)
  # ensure that values of samples is correct
  expect_equal(sum(dat$samples), 7)
})
test_that("Sample VULN works with TC and DIFF", {
  set.seed(1234)
  tc <- sample_tc(params = list(10, 50, 70, 85, 2))$samples
  diff <- sample_diff(params = list(10, 50, 70, 85, 2))$samples
  dat <- sample_vuln(func = select_loss_opportunities, params = list(tc = tc, diff = diff))
  expect_is(dat, "list")
  # ensure that the list has the required elements
  expect_equivalent(names(dat), c("type", "samples", "details"))
  # ensure that the samples matches the number requested
  expect_equivalent(length(dat$samples), 10)
  # ensure that values of samples is correct
  expect_equivalent(sum(dat$samples), 5)
  # ensure that mean_tc_exceedance is set correctly
  expect_equivalent(floor(dat$details$mean_tc_exceedance), 7)
  # ensure that mean_diff_exceedance is set correctly
  expect_equivalent(floor(dat$details$mean_diff_exceedance), 8)
})

context("Sample LM")
test_that("Sample LM", {
  set.seed(1234)
  lm <- sample_lm(params = list(10, 1*10^4, 5*10^4, 1*10^7, 3))
  expect_is(lm, "list")
  # ensure that the list has the required elements
  expect_equal(names(lm), c("type", "samples", "details"))
  # ensure that the samples matches the number requested
  expect_equal(length(lm$samples), 10)
  # ensure that values of samples is correct
  expect_equal(signif(unlist(lm$samples), digits = 4),
               signif(c(332422.727880636, 2831751.79415706, 35602.2608120876,
                        3349352.73654269, 3632631.71769846, 927503.010814968,
                        966756.805719722, 941718.366417413, 569057.598433507,
                        1069488.76293628), digits = 4))
})

context("Sample LEF")
test_that("Sample LEF works with composition function", {
  set.seed(1234)
  tef <- sample_tef(params = list(10, 1, 10, 20))
  vuln <- sample_vuln(params = list(10, 1, .6))
  dat <- sample_lef(func = compare_tef_vuln,
             params = list(tef = tef$samples, vuln = vuln$samples))
  expect_is(dat, "list")
  # ensure that the list has the required elements
  expect_equal(names(dat), c("type", "samples", "details"))
  # ensure that the samples matches the number requested
  expect_equal(length(dat$samples), 10)
  # ensure that LEF samples are always integers
  expect_is(dat$samples, "integer")
  # ensure that values of samples is correct
  expect_equal(dat$samples, c(5, 11, 15, 2, 12, 0, 8, 0, 0, 6))
})

context("Standard simulation model")
test_that("Default simulation model returns expected results", {
  sim <- openfair_tef_tc_diff_lm(list(tef_l = 1, tef_ml=10, tef_h=100, tef_conf=4,
                            tc_l = 1, tc_ml = 10, tc_h =75, tc_conf=100,
                            lm_l=1, lm_ml=100, lm_h = 10000, lm_conf=54),
                       diff_estimates = data_frame(l=1, ml=10, h = 50, conf =4),
                       n = 100)
  expect_s3_class(sim, "tbl_df")
  expect_equal(nrow(sim), 100)
  expect_equal(length(sim), 12)
  expect_equal(sum(sim$threat_events), 2287)
  expect_equal(sum(sim$loss_events), 786)
})

context("Main simulation")
test_that("Full wrapped scenario works as expected", {
  scenario <- structure(list(scenario_id = 1L, scenario = "Inadequate human resources are available to execute the informaton security strategic security plan.",
                             tcomm = "Organizational Leadership", domain_id = "ORG", controls = "1, 5, 7, 32, 14, 15, 16",
                             diff_params = list(structure(list(control_id = c("1", "5",
                                                                              "7", "32", "14", "15", "16"), label = c("5 - Optimized",
                                                                                                                      "4 - Managed", "1 - Initial", "4 - Managed", "4 - Managed",
                                                                                                                      "2 - Repeatable", "2 - Repeatable"), type = c("diff", "diff",
                                                                                                                                                                    "diff", "diff", "diff", "diff", "diff"), l = c(70L, 50L,
                                                                                                                                                                                                                   0L, 50L, 50L, 20L, 20L), ml = c(85, 70, 10, 70, 70, 30, 30
                                                                                                                                                                                                                   ), h = c(98L, 84L, 30L, 84L, 84L, 50L, 50L), conf = c(4L,
                                                                                                                                                                                                                                                                         4L, 4L, 4L, 4L, 4L, 4L)), class = c("tbl_df", "tbl", "data.frame"
                                                                                                                                                                                                                                                                         ), row.names = c(NA, -7L), .Names = c("control_id", "label",
                                                                                                                                                                                                                                                                                                               "type", "l", "ml", "h", "conf"))), tef_l = 10L, tef_ml = 24,
                             tef_h = 52L, tef_conf = 4L, tc_l = 33L, tc_ml = 50, tc_h = 60L,
                             tc_conf = 3L, lm_l = 10000L, lm_ml = 20000, lm_h = 500000L,
                             lm_conf = 4L), .Names = c("scenario_id", "scenario", "tcomm",
                                                       "domain_id", "controls", "diff_params", "tef_l", "tef_ml", "tef_h",
                                                       "tef_conf", "tc_l", "tc_ml", "tc_h", "tc_conf", "lm_l", "lm_ml",
                                                       "lm_h", "lm_conf"), row.names = c(NA, -1L), class = c("tbl_df",
                                                                                                             "tbl", "data.frame"))

  results <- evaluate_promise(run_simulations(scenario, 100L))
  expect_s3_class(results$result, "tbl_df")
  expect_equal(nrow(results$result), 100)
  expect_equal(length(results$result), 13)
  expect_equal(sum(results$result$threat_events), 2686)
  expect_equal(sum(results$result$loss_events), 764)
})
