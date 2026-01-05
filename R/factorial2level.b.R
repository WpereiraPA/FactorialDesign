factorial2levelClass <- if (requireNamespace("jmvcore", quietly = TRUE))
  R6::R6Class(
    "factorial2levelClass",
    inherit = factorial2levelBase,
    
    private = list(
      
      .run = function() {
        
        if (is.null(self$options$factors) || length(self$options$factors) < 1)
          return()
        
        if (is.null(self$options$response))
          return()
        
        factors  <- as.character(self$options$factors)
        response <- as.character(self$options$response)
        
        df <- as.data.frame(self$data)
        all_cols <- c(factors, response)
        
        if (!all(all_cols %in% names(df)))
          return()
        
        complete_rows <- complete.cases(df[, all_cols, drop = FALSE])
        if (sum(complete_rows) < 3) {
          self$results$coefficients$setNote("note", "Insufficient data")
          return()
        }
        
        df <- df[complete_rows, all_cols, drop = FALSE]
        
        df[[response]] <- suppressWarnings(as.numeric(gsub(",", ".", trimws(as.character(df[[response]])))))
        if (all(is.na(df[[response]]))) {
          self$results$coefficients$setNote("note", "Response não pôde ser convertida para numérica.")
          return()
        }
        
        for (fct in factors)
          df[[fct]] <- as.factor(df[[fct]])
        
        tryCatch({
          
          formula_str <- paste(response, "~", paste(factors, collapse = " * "))
          model <- lm(as.formula(formula_str), data = df)
          
          coef_table   <- self$results$coefficients
          coef_summary <- summary(model)$coefficients
          
          for (i in seq_len(nrow(coef_summary))) {
            coef_table$addRow(rowKey = as.character(i), values = list(
              term     = rownames(coef_summary)[i],
              estimate = coef_summary[i, 1],
              se       = coef_summary[i, 2],
              t        = coef_summary[i, 3],
              p        = coef_summary[i, 4]
            ))
          }
          
          metrics_table <- self$results$metrics
          metrics_table$addRow(rowKey = "r2", values = list(
            metric = "R-squared",
            value  = summary(model)$r.squared
          ))
          metrics_table$addRow(rowKey = "adjr2", values = list(
            metric = "Adjusted R-squared",
            value  = summary(model)$adj.r.squared
          ))
          metrics_table$addRow(rowKey = "rmse", values = list(
            metric = "RMSE",
            value  = sqrt(mean(residuals(model)^2))
          ))
          
          equation_table <- self$results$equation
          coefs <- coef(model)
          terms <- names(coefs)
          
          eq_parts <- character(length(coefs))
          eq_parts[1] <- sprintf("%.4f", coefs[1])
          
          if (length(coefs) >= 2) {
            for (i in 2:length(coefs)) {
              sgn <- ifelse(coefs[i] >= 0, "+", "-")
              eq_parts[i] <- sprintf("%s %.4f*%s", sgn, abs(coefs[i]), terms[i])
            }
          }
          
          equation_table$addRow(rowKey = "eq1", values = list(
            equation = paste(response, "=", paste(eq_parts, collapse = " "))
          ))
          
          effects_table <- self$results$effects
          
          for (fct in factors) {
            
            lvls <- levels(df[[fct]])
            if (length(lvls) < 2)
              next
            
            means <- sapply(lvls, function(lvl) {
              mean(df[df[[fct]] == lvl, response], na.rm = TRUE)
            })
            
            if (all(is.na(means)))
              next
            
            effects_table$addRow(rowKey = paste0("eff_", fct), values = list(
              factor     = fct,
              effect     = means[length(means)] - means[1],
              low_level  = means[1],
              high_level = means[length(means)]
            ))
          }
          
          if (isTRUE(self$options$mainEffects)) {
            self$results$mainEffectsPlot$setState(list(
              data = df,
              factors = factors,
              response = response
            ))
          }
          
        }, error = function(e) {
          self$results$coefficients$setNote("note", paste("Error:", e$message))
        })
      },
      
      .plot = function(image, theme = NULL, ggtheme = NULL, ...) {
        
        if (!isTRUE(self$options$mainEffects))
          return(TRUE)
        
        state <- image$state
        if (is.null(state))
          return(TRUE)
        
        df <- state$data
        factors <- state$factors
        response <- state$response
        
        df[[response]] <- suppressWarnings(as.numeric(gsub(",", ".", trimws(as.character(df[[response]])))))
        if (all(is.na(df[[response]])))
          return(TRUE)
        
        means_list <- list()
        
        for (fct in factors) {
          
          x_raw <- as.character(df[[fct]])
          x_num <- suppressWarnings(as.numeric(gsub(",", ".", trimws(x_raw))))
          
          ok <- !is.na(x_num) & !is.na(df[[response]])
          if (sum(ok) < 2)
            next
          
          tmp <- data.frame(Level = x_num[ok], Response = df[[response]][ok])
          m <- stats::aggregate(Response ~ Level, data = tmp, FUN = mean)
          m$Factor <- fct
          means_list[[fct]] <- m
        }
        
        if (length(means_list) == 0)
          return(TRUE)
        
        means_data <- do.call(rbind, means_list)
        
        means_data$Level <- factor(means_data$Level, levels = c(-1, 1))
        
        p <- ggplot2::ggplot(
          means_data,
          ggplot2::aes(x = Level, y = Response, group = Factor, color = Factor)
        ) +
          ggplot2::geom_line(linewidth = 1.2) +
          ggplot2::geom_point(size = 3) +
          ggplot2::labs(
            title = "Estimated Effects",
            x = "Coded level",
            y = paste("Mean", response),
            color = "Factor"
          ) +
          ggplot2::theme_minimal() +
          ggplot2::theme(
            plot.title = ggplot2::element_text(hjust = 0.5, size = 15, face = "bold"),
            axis.title = ggplot2::element_text(size = 13),
            axis.text  = ggplot2::element_text(size = 12),
            legend.position = "right"
          )
        
        print(p)
        TRUE
      }
    )
  )
