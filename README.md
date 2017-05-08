# kdb+taq

## Changes to kdb+taq

### 2015.07.27 (version 1.12)
Timestamp precision extended from millisecond to microseconds (additional 3 digits ignored for now).
Ignore 3 additional fields participant timestamp, RRN and TRF   
http://www.nyxdata.com/nysedata/default.aspx?tabid=993&id=2784

### 2014.04.28 (version 1.11)
Support additional exchange codes (12-15 - ZJKY) in taqmaster 

### 2014.01.15 (version 1.10)
Amend taq.k to discard the first line of taqmaster* when it is just lists the record count

### 2013.11.25 (version 1.9)
Amend taq.k and tq.q to recognise and ignore the new quote fields:
- SIP-generated Message Identifier
- National BBO LULD Indicator
tq.q to recognise and ignore the new NBBO fields:
- Limit-Up/Limit-Down Indicator 
- Limit-up/Limit-down NBBO Indicator
- SIP-generated Message Identifier
and handle deletion of previous NBBO fields:
- Limit-Up/Limit-Down NBBO (UTP) Indicator
- Limit-Up/Limit-Down NBBO (CQS) Indicator

The format change is scheduled to take effect from 2nd December 2013
see:
http://www.nyxdata.com/nysedata/Default.aspx?tabID=993&id=2194

### 2013.01.22 (version 1.8)
Amended taq.k and tq.q to recognise and ignore the new quote fields:
- Short Sale Restriction (SSR) Indicator
- Limit-Up/Limit-Down BBO (UTP) Indicator
- Limit-Up/Limit-Down BBO (CQS) Indicator
- FINRA ADF MPID Indicator
and tq.q to recognise and ignore the new NBBO fields:
- Limit-Up/Limit-Down NBBO (UTP) Indicator
- Limit-Up/Limit-Down NBBO (CQS) Indicator

The format change is scheduled to take effect from 1st February 2013
see:  
http://www.nyxdata.com/nysedata/default.aspx?tabid=993&id=1771  
http://www.nyxdata.com/doc/185107

### 2012.07.31 (version 1.7)
Amended taq.k and tq.q to recognise (and ignore) the new Quote field RPI (Retail Interest Indicator) 

### 2011.10.07
Added tq.q as example of how to load more fields from the FTP files. 
taq.k is unchanged.

### 2011.08.11
Adjust partitioning used with -par to split at a whole symbol – so any particular symbol will only be in one partition.

### 2011.08.07
Enabled to handle >2billion rows in input file. Use in combination with `-par` cmd line option and par.txt

### 2010.08.19 
Amend the file detection code to pick up the new file names (as well as the old ones)
when NYSE changes the filenames for the FTP download on September 17th, 2010.


## Hot linking from your application


You are welcome to download and use this code according to the terms of the licence. 

Kx Systems recommends you do not link your application to this repository, 
which would expose your application to various risks:

- This is not a high-availability hosting service
- Updates to the repo may break your application 
- Code refactoring might return 404s to your application

Instead, download code and subject it to the version control and regression testing 
you use for your application.
