# FactorialDesign

A Jamovi module for factorial design of experiments (DOE) analysis.

## Overview

**FactorialDesign** provides tools for analyzing factorial designs with 2-level and 3-level factors.  
The module is intended for industrial experiments, optimization studies, quality control, and research applications requiring systematic analysis of factor effects.

The interface was simplified in version 1.0.6 to improve usability and consistency with classical DOE terminology.

---

## Features

- Estimated effects analysis for factorial designs
- Support for 2-level and 3-level factors
- Automatic computation of interaction effects and regression results
- Visual plots for interpretation of factor effects

---

## Installation

### From Jamovi Library

1. Open Jamovi
2. Click on the **+** button in the top right
3. Select **Jamovi library**
4. Search for **FactorialDesign**
5. Click **Install**

### From GitHub (Development Version)

```r
# Install remotes package if needed
install.packages("remotes")

# Install FactorialDesign
remotes::install_github("WpereiraPA/FactorialDesign")
