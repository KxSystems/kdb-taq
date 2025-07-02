// ** tickNotes **
/
 globals used
 .u.w - dictionary of tables->(handle;syms)
 .u.i - msg count in log file
 .u.j - total msg count (log file plus those held in buffer)
 .u.t - table names
 .u.L - tp log filename, e.g. `:./sym2008.09.11
 .u.l - handle to tp log file
 .u.d - date
\

////////////////////////// INSTRUCTIONS TO RUN //////////////////////////
// TICKERPLANT
q tick.q sym logFiles/ -p 5000

// FEEDHANDLER
q tick/fh.q sym 5010

// RDB1 - subscribing for quote and trade and publishing aggTrade Table
export AGGRDB="TRUE"
q tick/r.q localhost:5000 localhost:5002 -p 5005


// RDB2 - subscribing for aggTrade Table Only
export SUBTABS="aggTrade"
q tick/r.q localhost:5000 localhost:5002 -p 5006

// HDB
q sym -p 5012
/////////////////////////////////////////////////////////////////////////