factorial3levelClass <- if (requireNamespace("jmvcore", quietly = TRUE))
  R6::R6Class(
    "factorial3levelClass",
    inherit = factorial3levelBase,
    
    private = list(
      
      .run = function() {
        
        # Validar se PELO MENOS 2 fatores e a resposta foram selecionados
        if (is.null(self$options$factorA) || 
            is.null(self$options$factorB) || 
            is.null(self$options$dep)) {
          return()
        }
        
        # Obter os dados
        factorA <- self$options$factorA
        factorB <- self$options$factorB
        factorC <- self$options$factorC  # Pode ser NULL (opcional)
        dep <- self$options$dep
        
        # Montar lista de colunas necessárias
        all_cols <- c(factorA, factorB, dep)
        factors <- c(factorA, factorB)
        
        if (!is.null(factorC)) {
          all_cols <- c(all_cols, factorC)
          factors <- c(factors, factorC)
        }
        
        df <- as.data.frame(self$data)
        
        # Verificar se as colunas existem
        if (!all(all_cols %in% names(df)))
          return()
        
        # Remover linhas com NA
        complete_rows <- complete.cases(df[, all_cols, drop = FALSE])
        if (sum(complete_rows) < 3) {
          if (self$options$showANOVA)
            self$results$anovaTable$setNote("note", "Insufficient data")
          return()
        }
        
        df <- df[complete_rows, all_cols, drop = FALSE]
        
        # Converter para fatores
        for (fct in factors)
          df[[fct]] <- as.factor(df[[fct]])
        
        df[[dep]] <- as.numeric(df[[dep]])
        
        tryCatch({
          
          # Criar fórmula ANOVA dinâmica
          formula_str <- paste(dep, "~", paste(factors, collapse = " * "))
          
          # Executar ANOVA
          model <- aov(as.formula(formula_str), data = df)
          anova_summary <- summary(model)
          
          # Preencher tabela ANOVA
          if (self$options$showANOVA) {
            anova_table <- self$results$anovaTable
            anova_data <- as.data.frame(anova_summary[[1]])
            terms <- rownames(anova_data)
            
            for (i in seq_along(terms)) {
              if (terms[i] != "Residuals") {
                anova_table$addRow(rowKey = as.character(i), values = list(
                  term = terms[i],
                  df   = anova_data[i, "Df"],
                  ss   = anova_data[i, "Sum Sq"],
                  ms   = anova_data[i, "Mean Sq"],
                  F    = anova_data[i, "F value"],
                  p    = anova_data[i, "Pr(>F)"]
                ))
              }
            }
          }
          
          # Calcular e preencher tabela de efeitos principais
          if (self$options$showANOVA) {
            effects_table <- self$results$effects
            
            for (fct in factors) {
              lvls <- levels(df[[fct]])
              means <- sapply(lvls, function(lvl) {
                mean(df[df[[fct]] == lvl, dep], na.rm = TRUE)
              })
              
              # Calcular efeito (diferença entre maior e menor média)
              effect <- max(means) - min(means)
              
              effects_table$addRow(rowKey = fct, values = list(
                factor = fct,
                levels = paste(lvls, collapse = ", "),
                means = paste(round(means, 2), collapse = ", "),
                effect = effect
              ))
            }
          }
          
          # Preparar gráfico de interação
          if (self$options$showPlot) {
            image <- self$results$plot
            image$setState(list(
              data = df,
              factors = factors,
              dep = dep
            ))
          }
          
        }, error = function(e) {
          if (self$options$showANOVA)
            self$results$anovaTable$setNote("note", paste("Error:", e$message))
        })
        
      },
      
      .plot = function(image, ggtheme, theme, ...) {
        
        state <- image$state
        if (is.null(state))
          return(FALSE)
        
        df <- state$data
        factors <- state$factors
        dep <- state$dep
        
        tryCatch({
          
          library(ggplot2)
          
          if (length(factors) < 1)
            return(FALSE)
          
          if (! dep %in% names(df))
            return(FALSE)
          
          df[[dep]] <- as.numeric(df[[dep]])
          
          means_list <- list()
          
          for (fct in factors) {
            
            if (! fct %in% names(df))
              next
            
            x_raw <- as.character(df[[fct]])
            x_num <- suppressWarnings(as.numeric(gsub(",", ".", trimws(x_raw))))
            
            ok <- ! is.na(x_num) & ! is.na(df[[dep]])
            if (sum(ok) < 3)
              next
            
            tmp <- data.frame(Level = x_num[ok], Response = df[[dep]][ok])
            
            m <- aggregate(Response ~ Level, data = tmp, FUN = mean)
            
            m$Factor <- fct
            
            means_list[[fct]] <- m
          }
          
          if (length(means_list) == 0)
            return(FALSE)
          
          means_data <- do.call(rbind, means_list)
          
          means_data$Level <- factor(means_data$Level, levels = c(-1, 0, 1))
          
          p <- ggplot(means_data,
                      aes(x = Level, y = Response, group = Factor, color = Factor)) +
            geom_line(linewidth = 1.2) +
            geom_point(size = 3) +
            labs(
              title = "Estimated Effects",
              x = "Coded level",
              y = paste("Mean", dep),
              color = "Factor"
            ) +
            theme_minimal() +
            theme(
              plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
              axis.title = element_text(size = 14),
              axis.text = element_text(size = 14),
              legend.position = "right"
            )
          
          print(p)
          return(TRUE)
          
        }, error = function(e) {
          return(FALSE)
        })
      }
    )
  )
