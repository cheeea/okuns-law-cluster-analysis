**Okun's Law Cluster Analysis**

Cluster analysis of US states based on fit of Okun's Law and other relevant covariates. 

1. **Okuns_state.R**

Queried state-level time-series data (roughly 1997 to 2023 after joins) from FRED's API of [real GDP](https://fred.stlouisfed.org/series/CARGSP) and [unemployment rate](https://fred.stlouisfed.org/release/tables?rid=112&eid=1195039) to calculate Okun's law for each US state. Fit is calculated using RMSE. I define Okun's law as follows:

$$
\Delta \\% \text{Real GDP} = 0.03 - 2 * \Delta \text{Unemployment Rate}
$$

Other covariates of interest are the state-level average growth rates of [population levels](https://fred.stlouisfed.org/release/tables?rid=118&eid=259194), [real median household income](https://fred.stlouisfed.org/release/tables?rid=249&eid=259515), and [PCE (Personal Consumption Expenditure)](https://fred.stlouisfed.org/release/tables?rid=391&eid=216084), in addition to the median [number of degrees attained at the bachelor's level or higher](https://fred.stlouisfed.org/release/tables?rid=330&eid=391444).  

3. **okuns.ipynb**
