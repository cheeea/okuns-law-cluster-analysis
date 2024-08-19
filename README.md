## **Okun's Law Cluster Analysis**

Cluster analysis of US states based on fit of Okun's Law and other relevant covariates. 

1. **Okuns_state.R**

Queried state-level time-series data (roughly 1997 to 2023 after joins) from FRED's API of [real GDP](https://fred.stlouisfed.org/series/CARGSP) and [unemployment rate](https://fred.stlouisfed.org/release/tables?rid=112&eid=1195039) to calculate Okun's law for each US state. Fit is calculated using RMSE. I define Okun's law as follows:

$$
\Delta \\% \text{Real GDP} = 0.03 - 2 * \Delta \text{Unemployment Rate}
$$

Other covariates of interest are the state-level average growth rates of [population levels](https://fred.stlouisfed.org/release/tables?rid=118&eid=259194), [real median household income](https://fred.stlouisfed.org/release/tables?rid=249&eid=259515), and [PCE (Personal Consumption Expenditure)](https://fred.stlouisfed.org/release/tables?rid=391&eid=216084), in addition to the median [number of degrees attained at the bachelor's level or higher](https://fred.stlouisfed.org/release/tables?rid=330&eid=391444).  

2. **okuns.ipynb**

Carried out K-means clustering to group states based on similar values of RMSE with respect to Okun's law and the aforementioned covariates. A summary of the K = 5 clusters, chosen from silhouette score analysis, is below: 

| Cluster      | States |
| ----------- | ----------- |
| 1      | Connecticut, Illinois, Iowa, Kansas, Maine, Massachusetts, Minnesota, Missouri, Nebraska, New Hampshire, New Jersey, New York, Pennsylvania, Rhode Island, Vermont, Wisconsin      |
| 2   | Alaska, Arizona, California, Florida, Idaho, Nevada, New Mexico, North Carolina, Oklahoma, Texas |
| 3  | Alabama, Arkansas, Indiana, Kentucky, Louisiana, Michigan, Mississippi, Ohio, South Carolina, West Virginia      |
| 4   | Colorado, Georgia, Maryland, Montana, Oregon, South Dakota, Tennessee, Utah, Virginia, Washington      | 
| 5  | Delaware, Hawaii, North Dakota, Wyoming        |

Created a choropleth plot to visualize the clusters. The full interactive plot is available [here](https://nbviewer.org/github/cheeea/okuns-law-cluster-analysis/blob/main/okuns.ipynb). 

![image](https://github.com/user-attachments/assets/1eede76b-4e4d-452b-9a99-d877af15cd38)

