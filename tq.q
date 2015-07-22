/2015.08.03 timestamps milli->micro, handle (ignore) additional participant timestamp, RRN, TRF 
/ http://www.nyxdata.com/nysedata/default.aspx?tabid=993&id=2784
/2013.11.25 quote has 2 new field (+3, -1), nbbo has 2 new fields for>20131201
/http://www.nyxdata.com/nysedata/Default.aspx?tabID=993&id=2194
/2013.01.22 quote has 4 new fields, nbbo 2 new fields for>20130201
/ http://www.nyxdata.com/nysedata/default.aspx?tabid=993&id=1771
dst:`:tq
F:key src:`$":",.z.x 0
D:"I"$-8#string first F

/ trade fields (types;widths)   trf after 200609
tf:`time`ex`sym`s`cond`size`price`stop`corr`seq`cts`trf
tt:($[20150802<D;"T ";"T"],"CSS*IFBIJCC ";$[20150802<D;9 3;9],1 6 10 4 9 11 1 2 16 1 1,1+(20060930<D)+32*20150802<D)

/ quote fields (types;widths)
qf:`time`ex`sym`s`bid`bsize`ask`asize`cond`mmid`bex`aex`seq`bbo`qbbo`corr`cqs /`rpi /`ssr`l0`l1`mpid/`sip`bboluld
qt:($[20150802<D;"T ";"T"],"CSSFIFIC*CCJCCCC ";$[20150802<D;9 3;9],1 6 10 11 7 11 7 1 4 1 1 16 1 1 1 1,2+(20120731<D)+(4*20130201<D)+(2*20131202<D)+32*20150802<D)

/ nbbo fields (types;widths)
nf:`time`ex`sym`s`bid`bsize`ask`asize`cond`mmid`bex`aex`seq`bbo`qbbo`corr`cqs`qcond`bbex`bbprice`bbsize`bbmmid`bbmmloc`bbmmdeskloc`baex`baprice`basize`bammid`bammloc`bammdeskloc /`l0`l1`sip
nt:($[20150802<D;"T ";"T"],"CSSFIFIC*CCJCCCCCCFI*SCCFI*SC ";$[20150802<D;9 3;9],1 6 10 11 7 11 7 1 4 1 1 16 1 1 1 1 1 1 11 7 4 2 1 1 11 7 4 2 1,2+(2*20130201<D)+(1*20131202<D)+32*20150802<D) 

/ sym[.s] "e"$pricebidask 
g:{[f;x]`sym`time xcols delete s from @[;`sym;{$[null y;x;` sv x,y]}';x`s]@[x;f;"e"$%;1e4]}
foo:{[d;f;t;g;x]@[;`sym;`p#].Q.dsftg[(dst;"D"$-8#string x;d);(` sv src,x;sum t 1;0);f;t;g]}

\t foo[`trade;tf;tt;g[`price]  ]each F where F like"taqtrade*[0-9]"
\t foo[`quote;qf;qt;g[`bid`ask]]each F where F like"taqquote*[0-9]"
\t foo[`nbbo ;nf;nt;g[`bid`ask]]each F where F like"taqnbbo*[0-9]"

\
http://www.nyxdata.com/Data-Products/Daily-TAQ
http://www.nyxdata.com/doc/185107
