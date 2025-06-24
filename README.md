# kdb+taq

kdb-taq is a tool for processing and analyzing historical NYSE Daily TAQ (Trade and Quote) data using kdb+/q. This repository contains scripts and utilities to parse, load, and query TAQ datasets efficiently.

## Prerequisites

- [kdb+](https://kx.com/kdb-personal-edition-download/) installed on your machine
- NYSE Daily TAQ files from [ftp.nyse.com](https://ftp.nyse.com/Historical%20Data%20Samples/DAILY%20TAQ/)

## Getting Started

Follow the steps below to set up and process a TAQ file:

### 1. Download a Sample TAQ File

Obtain TAQ data files from the NYSE FTP link. For example:

```bash
export DATE=$(curl -s https://ftp.nyse.com/Historical%20Data%20Samples/DAILY%20TAQ/| grep -oE 'EQY_US_ALL_TRADE_2[0-9]{7}' | grep -oE '2[0-9]{7}'|head -1)
wget https://ftp.nyse.com/Historical%20Data%20Samples/DAILY%20TAQ/EQY_US_ALL_TRADE_$DATE.gz
```

These files are ~2GB each so may take significant time to download.

### 2. Clone the Repository

Clone the kdb-taq repository to your server:

```bash
git clone https://github.com/KxSystems/kdb-taq.git
cd kdb-taq
```

### 3. Prepare the Data

Create a source directory and move the downloaded TAQ file to this and decompress it:

```bash
mkdir SRC
mv /path/to/EQY_US_ALL_TRADE_$DATE.gz SRC/
gzip -d SRC/*
```

### 4. Process the TAQ Data

Run the `tq.q` script to process the data. Replace `SRC` with the full path to the source directory if necessary:

```bash
q tq.q -s 8 SRC
```

The `-s` option specifies the number of threads (optional).

### 5. Load the Processed Data

Load the data into the kdb+ environment:

```bash
q)\l tq
```

### 6. Query the Data

You can now query the loaded data. For example runnning `meta` to see the table schema and datatypes:

```q
q)meta trade

c                                 | t f a
----------------------------------| -----
date                              | d    
Time                              | n    
Exchange                          | c    
Symbol                            | s   p
SaleCondition                     | s    
TradeVolume                       | i    
TradePrice                        | e    
TradeStopStockIndicator           | b    
TradeCorrectionIndicator          | h    
SequenceNumber                    | i    
TradeId                           | C    
SourceofTrade                     | c    
TradeReportingFacility            | b    
ParticipantTimestamp              | n    
TradeReportingFacilityTRFTimestamp| n    
TradeThroughExemptIndicator       | b   
```

And run aggregations on the data, for example get the number of trades and the max prices for each hour:

```q
q)select numTrade:count i,maxPrice:max TradePrice by Time.hh from trade

hh| numTrade maxPrice
--| -------------------
1 | 14019    15.0399   
2 | 28475    15.04391  
3 | 28535    15.04839  
4 | 194690   7465      
5 | 122619   3880      
6 | 117835   7475      
7 | 281648   7460      
8 | 676191   7458.8    
9 | 7657888  611225.6  
10| 11303243 611071.8  
11| 8726594  610600    
12| 7114388  610980    
13| 7039454  611065    
14| 7512397  611679.9  
15| 16510252 613149.4  
16| 385603   612600.2  
17| 145800   7460      
18| 121943   610668    
19| 96918    610668    
20| 6655     8662.955

```

## Changelog
Detailed update history can be found in [CHANGELOG.md](CHANGELOG.md).

## Best Practices for Integration

You are welcome to download and use this code according to the terms of the licence.

[KX](kx.com) recommends you do not link your application to this repository,
which would expose your application to various risks:

- This is not a high-availability hosting service
- Updates to the repo may break your application
- Code refactoring might return 404s to your application

### Recommendation:
Instead, download code and subject it to the version control and regression testing
you use for your application.
