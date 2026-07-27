# 🚀 NASA HTTP Web Log Analytics using PostgreSQL

## 📖 Overview

This project analyzes the **NASA HTTP Web Server Logs** using **Python** and **PostgreSQL**. The original dataset is provided as an unstructured text log file, which is parsed and converted into a structured CSV using **Jupyter Notebook**. The cleaned data is then imported into PostgreSQL, where advanced SQL queries are used to extract meaningful insights about website traffic, user behavior, and server performance.

---

# 🛠️ Tech Stack

* Python
* Jupyter Notebook
* Pandas
* PostgreSQL
* SQL

---

# 📂 Dataset

The dataset contains HTTP access logs from NASA's web server. Each log entry includes:

* IP Address
* Timestamp
* HTTP Method
* Requested URL
* HTTP Protocol
* HTTP Status Code
* Bytes Sent

Example log entry:

```text
199.72.81.55 - - [01/Jul/1995:00:00:01 -0400] "GET /history/apollo/ HTTP/1.0" 200 6245
```

---

# 🔄 Project Workflow

```text
NASA HTTP Log (.txt)
        │
        ▼
Jupyter Notebook
(Log Parsing & Data Cleaning)
        │
        ▼
CSV File
        │
        ▼
PostgreSQL
(Data Import)
        │
        ▼
SQL Analytics
        │
        ▼
Business Insights
```

---

# 📝 Converting Log File to CSV Using Jupyter Notebook

The NASA dataset is available as a raw text file and cannot be imported directly into PostgreSQL. A Jupyter Notebook was used to transform the logs into a structured CSV format.

### Steps Performed

* Loaded the raw log file.
* Parsed each log entry using **Regular Expressions (Regex)**.
* Extracted the following fields:

  * IP Address
  * Timestamp
  * HTTP Method
  * URL
  * HTTP Protocol
  * Status Code
  * Bytes Sent
* Replaced missing byte values (`-`) with `0`.
* Converted timestamps into PostgreSQL-compatible format.
* Exported the cleaned data as **nasa_logs.csv**.

---

# 🗄️ Database Schema

| Column      | Data Type   |
| ----------- | ----------- |
| ip_address  | TEXT        |
| log_time    | TIMESTAMP   |
| http_method | VARCHAR(10) |
| url         | TEXT        |
| protocol    | VARCHAR(20) |
| status_code | INTEGER     |
| bytes_sent  | INTEGER     |

---

# 📊 SQL Analysis Performed

### Website Traffic Analysis

* Total number of requests received
* Number of unique visitors (IP addresses)
* Most visited pages
* Day with the highest traffic
* Top 5 busiest hours for each day
* Weekday vs Weekend traffic comparison
* 7-day moving average of website traffic

### User Behavior Analysis

* Users who visited the greatest number of unique pages
* Users who viewed more than 10 unique pages in a session
* Rarely visited pages
* Most active visitors
* Visitor bandwidth consumption ranking
* Visitor percentile segmentation using `NTILE()`

### Error Analysis

* HTTP status code distribution
* Pages with the highest percentage of 404 errors
* IP addresses generating the most failed requests
* Failed request analysis by error type

### Advanced SQL Analysis

* Rank the top pages using `RANK()`
* Find the busiest hours using `ROW_NUMBER()` and `DENSE_RANK()`
* Detect pages with more than 50% traffic growth using `LAG()`
* Analyze traffic trends with window functions
* Compare visitor bandwidth usage

---

# 💡 SQL Concepts Used

* Aggregate Functions
* GROUP BY
* HAVING
* CASE WHEN
* Common Table Expressions (CTEs)
* Window Functions

  * RANK()
  * DENSE_RANK()
  * ROW_NUMBER()
  * LAG()
  * NTILE()
* Date & Time Functions
* Conditional Aggregation
* Sessionization
* Regular Expressions (Regex)

---

# 📁 Project Structure

```text
NASA-Web-Log-Analytics/
│
├── data/
│   ├── NASA_access_log.txt
│   └── nasa_logs.csv
│
├── notebooks/
│   └── log_to_csv.ipynb
│
├── sql/
│   ├── create_table.sql
│   ├── load_data.sql
│   └── analytics_queries.sql
│
├── README.md
└── LICENSE
```

---

# 🎯 Key Features

* Converted raw NASA web logs into a structured CSV format.
* Cleaned and transformed log data using Python and Pandas.
* Imported structured data into PostgreSQL.
* Performed advanced SQL analytics using window functions and CTEs.
* Analyzed website traffic, user behavior, bandwidth usage, and server errors.
* Demonstrated real-world log analysis and SQL problem-solving techniques.

---

# 📚 Key Learnings

* Parsing unstructured log files with Python.
* Data cleaning and preprocessing using Pandas.
* Importing data into PostgreSQL.
* Writing advanced SQL queries for analytical reporting.
* Using window functions for ranking, trend analysis, and user segmentation.
* Performing end-to-end web log analytics on real-world data.
