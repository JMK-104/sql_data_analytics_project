# Data Analytics Project Roadmap

This document outlines the roadmap for the **SQL-Based Data Analytics Project**, divided into two key phases: **Exploratory Data Analysis (EDA)** and **Advanced Data Analytics (ADA)**.  

The roadmap ensures a structured approach to understanding raw data, performing exploration, and progressing toward advanced insights that drive decision-making.

---

## Phase 1: Exploratory Data Analysis (EDA)

The first phase focuses on understanding the structure, content, and fundamental properties of the dataset. It lays the foundation for deeper analysis by answering basic questions about the data.

### Key Activities:
- **Database Exploration**  
  Investigate the overall database, tables, relationships, and metadata.  
- **Dimension Exploration**  
  Explore categorical attributes (e.g., country, category, subcategory).  
- **Measure Exploration**  
  Examine quantitative metrics (e.g., sales, revenue, quantity).  
- **Date Range Exploration**  
  Analyze time-based dimensions.  
- **Magnitude Analysis**  
  Assess the scale of values (e.g., maximum, minimum, averages, totals).  
- **Ranking Analysis**  
  Rank entities (e.g., top customers, best-selling products, highest revenue regions).

---

## Phase 2: Advanced Data Analytics (ADA)

The second phase applies more advanced analytical techniques to derive actionable insights. These activities build on the foundational understanding from Phase 1.

### Key Activities:
- **Change Over Time**  
  Evaluate trends, growth patterns, and changes across time intervals.  
- **Cumulative Analysis**  
  Calculate running totals, cumulative sums, or progressive growth metrics.  
- **Performance Analysis**  
  Assess key performance indicators (KPIs) to evaluate efficiency and success.  
- **Part-to-Whole**  
  Understand proportions and contributions of categories to the overall dataset.  
- **Data Segmentation**  
  Group and classify data into meaningful segments (e.g., customer cohorts, product categories).  
- **Reporting**  
  Create dashboards and reports that summarize insights for stakeholders.

---

## Roadmap Flow

```mermaid
flowchart LR
    A[Phase 1: Exploratory Data Analysis] 

    A --> A1[Database Exploration]
    A --> A2[Dimension Exploration]
    A --> A3[Measure Exploration]
    A --> A4[Date Range Exploration]
    A --> A5[Magnitude Analysis]
    A --> A6[Ranking Analysis]
    A --> B[Phase 2: Advanced Data Analytics]

    B --> B1[Change Over Time]
    B --> B2[Cumulative Analysis]
    B --> B3[Performance Analysis]
    B --> B4[Part-to-Whole]
    B --> B5[Data Segmentation]
    B --> B6[Reporting]
