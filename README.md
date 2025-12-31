\# Factorial Design



A Jamovi module for factorial design of experiments (DOE) analysis.



\## Overview



\*\*FactorialDesign\*\* provides comprehensive tools for analyzing factorial designs with 2-level and 3-level factors. This module is ideal for industrial experiments, optimization studies, quality control, and research applications requiring systematic factor analysis.



\## Features



\- \*\*2-Level Factorial Design Analysis\*\*

&nbsp; - Main effects analysis

&nbsp; - Interaction effects

&nbsp; - Regression coefficients

&nbsp; - Visual plots for interpretation



\- \*\*3-Level Factorial Design Analysis\*\*

&nbsp; - Extended factor analysis

&nbsp; - Quadratic effects

&nbsp; - Complex interaction patterns

&nbsp; - Comprehensive regression output



\## Installation



\### From Jamovi Library



1\. Open Jamovi

2\. Click on the `+` button in the top right

3\. Select "jamovi library"

4\. Search for "Factorial Design"

5\. Click "Install"



\### From GitHub (Development Version)



```r

\# Install remotes package if needed

install.packages("remotes")



\# Install FactorialDesign

remotes::install\_github("WpereiraPA/FactorialDesign")

```



\## Usage



\### 2-Level Factorial Design



1\. Open your dataset in Jamovi

2\. Navigate to \*\*Analyses\*\* → \*\*FactorialDesign\*\* → \*\*Factorial Design - 2 Levels\*\*

3\. Select your factors (independent variables)

4\. Select your response variable (dependent variable)

5\. Choose display options:

&nbsp;  - Main Effects Plot

&nbsp;  - Interaction Plot

&nbsp;  - Regression Coefficients



\### 3-Level Factorial Design



1\. Navigate to \*\*Analyses\*\* → \*\*FactorialDesign\*\* → \*\*Factorial Design - 3 Levels\*\*

2\. Follow similar steps as 2-level design

3\. Analyze more complex factor relationships



\## Example



Consider an experiment testing the effect of temperature (A) and pressure (B) on yield:



\*\*Data Structure:\*\*

```

| A  | B  | C  | Response |

|----|----|----|----------|

| -1 | -1 | -1 |   52.7   |

|  1 | -1 | -1 |   40.1   |

| -1 |  1 | -1 |   13.4   |

|  1 |  1 | -1 |   26.8   |

```



\*\*Results will show:\*\*

\- Main effects of each factor

\- Interaction effects between factors

\- Regression coefficients with statistical significance

\- Visual plots for interpretation



\## Output Interpretation



\### Regression Coefficients Table

\- \*\*Estimate\*\*: Effect size of each term

\- \*\*Std. Error\*\*: Standard error of the estimate

\- \*\*t-value\*\*: Test statistic

\- \*\*p-value\*\*: Statistical significance (< 0.05 indicates significance)



\### Main Effects Plot

Shows the average response at each level of each factor



\### Interaction Plot

Displays how factors interact to affect the response



\## Requirements



\- Jamovi >= 1.0.8

\- R >= 3.6



\## Author



\*\*Wanderley Xavier Pereira\*\*

\- Email: wander.wx@gmail.com

\- GitHub: \[@WpereiraPA](https://github.com/WpereiraPA)



\## License



This module is licensed under GPL-3.



\## Citation



If you use this module in your research, please cite:



```

Pereira, W. X. (2025). FactorialDesign: Factorial Design Analysis for Jamovi 

(Version 1.0.5) \[Jamovi module]. https://github.com/WpereiraPA/FactorialDesign

```



\## Contributing



Contributions are welcome! Please feel free to:

\- Report bugs

\- Suggest features

\- Submit pull requests



Visit the \[Issues page](https://github.com/WpereiraPA/FactorialDesign/issues) to get started.



\## Support



For questions or support:

\- Open an issue on GitHub

\- Email: wander.wx@gmail.com



\## Changelog



\### Version 1.0.5 (2025-01-21)

\- Initial release for Jamovi Library

\- 2-level factorial design analysis

\- 3-level factorial design analysis

\- Main effects and interaction plots

\- Comprehensive regression output



---



\*\*Keywords\*\*: DOE, Design of Experiments, Factorial Design, Statistical Analysis, Jamovi, Experimental Design, Quality Control, Optimization

