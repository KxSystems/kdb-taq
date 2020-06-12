/2020.06.12 support taq3.3 - add TradedOnMEMX and TradedOnMIAX to master
/2020.04.15 support taq3.2 - add TradedOnLTSE to master
/2017.10.20 support taq3.0b - maintaining old schema
/ https://list.theice.com/t/92262/395348/57007/0/
/2016.10.19 support taq2.2a - maintaining old schema
/ http://www.nyxdata.com/doc/247075
/2015.07.27 timestamps milli->micro, handle (ignore) additional participant timestamp, RRN, TRF
/ http:///www.nyxdata.com/nysedata/default.aspx?tabid=993&id=2784
/2014.04.28 support additional exchange codes in master (12-15)
/2014.01.15 discard info line at beginning of taqmaster*
/2013.11.22 handle (ignore) new columns SIP,CTA for>20131130
/2013.01.22 handle (ignore) new columns SSR,UTP,CQS,MPID for>20130201
/ http://www.nyxdata.com/nysedata/default.aspx?tabid=993&id=1771
/2012.07.31 handle (ignore) new column RPI
/ http://www.nyxdata.com/nysedata/InformationProducts/tabid/73/Default.aspx
/2011.10.17 uot(100i and 0 ..1000i for q2 and q3 compatibility)
/2011.08.10 split at whole symbol when using -par
/2011.08.07 >2 billion rows
/2010.08.19 detect new ftp filenames
/2007.05.02 ftp trade cond is first non"@" char
/(FTPday: taq*) (DVDmonth: *.tab *.idx *.bin) 1GB/min
"kdb+taq 3.0 2017.10.20"
o:.Q.opt .z.x;if[2>#.Q.x;-1">q ",($.z.f)," SRC DST [-corr] [-join] [-host [host]:port..] [-par]";exit 1]
F:F@&(_F:!src:`$":",*.Q.x)like;S:0N!`/:src,;dst:`$":",.Q.x[1],"/taq"
host:(`$":",)'o`host;corr:$[`corr in!o;::;{(x_`corr)[;&3>x`corr]}];e:("e"$%;%)`float in!o;s:~`join in!o;par:`par in!o

mf:`cusip`wi`date`name`sym`ex`uot;m:$[@!d:`/:dst,`mas;mf#0!. d;()];ma:{m@:&~~':`date`name_m@:<m,:mf#x@&~x[`cusip]in``0`000000000}
V:{$["2"=*x:1_$x;1+"4"<x 3;0]}   /`out`issue N denom(AB3-8)/out (ind is missing from ftp)  issue?[dvd012345  ftp12347890]
/ MAS/DIV 1993-1999 bad(~5/1) rowsMAS0002/03 have bad dates(ccccyymm) DIV9912 has two bad splits MAB PRK
/ MAS sym: sym,name,cusip,wi,ex(0-2)[,etxNAB  PXTCW],its,ind,out,uot,denom(B3-8),issue(0-5),date mastyymm|myyyymm .tab
\t {tw:("SSSBX BSIICHD";10 30 9 1 2 10 1 4 10 4 1 1,6 10 10 v:V x);x:S x;x:$[v;x[;&~^*|x:tw 0:x];tw 0:x@&(+/tw 1)=#:'x:0:x] /delete bad records
 ma@[;`ex;"NAT"]@[;`uot;{x+100i*~x}]@+`sym`name`cusip`wi`ex`its`ind`out`uot`denom`issue`date!x}'(F"ma*.tab"),F"m2*.tab"

/FTP  http://www.nysedata.com/info/productDetail.asp?dpbid=13&page=1&dptID=48
/\t {d:"D"$-8#$x;m:+`date`cusip`wi`sym`name`uot`ex`r!d,(" SB SSI I S ";1 9 1 15 15 60 1 54 2 2 6,6+78*d>2004.06.24)0:S x
\t {d:"D"$-8#$x;m:(d>2010.11.10)_+`date`cusip`wi`sym`name`uot`ex`r!d,(" SB SSI I S ";1 9 1 15 15 60 1 54 2 2 6,6+78*d>2004.06.24)0:S x
  if[s;m:@[m;`sym;{$[x=y;x;`$(n#x),".",(n:#$y)_x:$x]}';m`r]];ma@[;`ex;"TNBCIMPXTAW DZJKY"0|1+]@[;`uot;0 10 25 50 100 1000i]m}'F"taqmaster*[0-9]"
if[0N!#m;.[d;();:;m]]

/p:.Q.par . dpt;0N!($p),": ",$m&:M;i::0;n::1000000;do[-_-m%n;@[p;`;$[a|i;,;:];.Q.en[d]@+g f!tw 1:(x;o+b*i;b*n&:m-i)];0N!i+:n];psym p}
M:0Wj
psym:{if[^@[@[;`sym;`p#];x;`];0N!x@&~(x?x)=!#x@:&~=':x@:`sym]}
adsftg:{[a;dpt;xom;f;tw;g]d::*dpt;x::*xom;if[~0<m::xom 2;m+:-7!x];if[r>m::"j"$-.5+r:(m-:o::xom 1)%b::"j"$+/tw 10=@*tw;'`length]
 0N!j:(!#p)*-"j"$-.5-(m&:M)%#p:$[par;`/:'(`$":",'0:`/:d,`par.txt),\:(`$$dpt 1),*|dpt;,.Q.par . dpt];
 xi:{[tw;i;n]tw 1:(x;o+b*i;b*n)}[tw];si:{[xi;f;x]*xi[x;1]@f?`sym}[xi;f]
 if[par&`sym in f;j:0j,{:/{$[~x[m:(+/z)div 2]<y;z[0],m;m,z[1]]}[x;y]/z}'[si;$[(#p)~2;,`K;`$'1_.Q.A@(!#p)*_26%#p];((#p)-1)#,0j,m]]
 {[xi;a;f;g;p;j;k]do[-_-(k-i::j)%n::1000000;@[p;`;$[a|i>j;,;:];.Q.en[d]@+g f!xi[i;n&:k-i]];0N!i+:n];psym 0N!p}[xi;a;f;g]'[p;j;1_j,m]}

/DVD  cq199308 200001 200501 t200610  record changes BRK before 2000 is truncated
tf:`time`price`size`stop`corr`cond`ex	/seq c234   ctyymm/tyyyymm
qf:`time`bid`ask`bsize`asize`mode`ex	/seq mmid   cqyymm/qyyyymm
tt:(("iii hhcc" ;4 4 4 4 2 2 1 1);  ("iji hhc c";4 8 4 4 2 2 1 3 1);("iiihhc c";4 4 4 2 2 1 1 1));tg:{[f;x]x[`stop]=:240h;corr@[x;`price;e;f]}
qt:(("iii hhhc ";4 4 4 4 2 2 2 1 4);("ijj iihc ";4 8 8 4 4 4 2 1 4);("iiiiihc ";4 4 4 4 4 2 1 4));qg:{[f;x]mode@[x;`bid`ask;e;f]}
/IDX sym date start end
idx:{+(&>':x 1)_/:x:flp[("siii";10 4 4 4)]1:`$(-3_$x),"idx"};FP:1e5 1e8 1e4;flp:$[*|-8!1;|:;::];
t10:{$[200609<"I"$-6#-5_$x;y,'(" ";1);y]};q93:{-("I"$-4_-8#$x)in 9301+!7};mode:@[;`mode;" AB  FHILNO R  XZY"]
foo:{[t;x;f;tw;g;a]d:"D"$$a[1;0];b:+/tw 1;s:{[s;x](`sym,!x)!(,s i+!n&m-i),.@[x;`time;"t"$1000*]}[,/(1+-/a 3 2)#'*a]
 adsftg["_"=x@-6+#x:$x;(dst;d;t);x,b*"j"$(a[2;0]-1;*|*|a);f;flp tw;g s@]}
\t {foo[`quote;f;qf;q93[x]_'qt v;qg FP v:V x]'idx f:S x}'F"[cq][q2]*.bin"
\t {foo[`trade;f;tf;t10[x]  tt v;tg FP v:V x]'idx f:S x}'F"[ct][t2]*.bin"

Tf:`time`ex`sym`s`cond`size`price`stop`corr /      seq16    cts1  2  trf
Qf:`time`ex`sym`s`bid`bsize`ask`asize`mode	/mmidba6seq16boc3cqs1  2  rpi  ssr l0 l1 mpid
tt:("TCSS*IFBI ";9 1 6 10  4 9 11 1 2 19);tg:{corr(`sym,tf)#sx@[@[x;`price  ;e;1e4];`cond;{x(x in" @")?0b}']}
qt:("TCSSFIFIC ";9 1 6 10 11 7 11 7 1 28);qg:{    (`sym,qf)#sx  @[x;`bid`ask;e;1e4]}
d1:{$[x<"I"$-8#$y;z,'(" ";1);z]};d2:{$[x<"I"$-8#$y;z,'(" ";2);z]};
d4:{$[x<"I"$-8#$y;z,'(" ";4);z]};s#:".";sx:{x[`ex;&"Q"=x`ex]:"T";@[;`sym;{$[^y;x;`$($x),s,$y]}';x`s]x};
d5:{$[x<"I"$-8#$y;("T ";9 3),'1_'z,'(" ";32);z]}
foo:{[t;tf;tt;tg;x]adsftg[0;(dst;"D"$-8#$x;t);(S x;+/tt 1;0);tf;tt;tg]}

\t {foo[`quote;Qf;d5[20150726;x]d2[20131201;x]d4[20130201;x]d1[20120731;x]qt;qg]x}'F"taqquote*[0-9]";
\t {foo[`trade;Tf;d5[20150726;x]                            d1[20060930;x]tt;tg]x}'F"taqtrade*[0-9]";

// taq 2.2a -- http://www.nyxdata.com/doc/247075
// taq 3.0b -- https://list.theice.com/t/92262/395348/57007/0/ (starting 2017.11.06)
// taq 3.2  -- https://www.nyse.com/trader-update/history#110000241204

s16:{f:$[#s;{x[&x=" "]:".";x};{x&~x=" "}];update`$Symbol from update Symbol:f'Symbol from x where Symbol like"* *"}
sx2:{x[`ex;&"Q"=x`ex]:"T";x}; m:$[@!d:`/:dst,`mas;mf#0!. d;()]
par2:{[d;p;t;C]`/:($[@!h:`/:d,`par.txt;`$":",h .q.mod[*(.q.xrank[hc::#h;.Q.A].Q.A?,C)+p;#h:0:h];d];`$$p;t)}
tj:{"T"$9#'x}; nj:{"N"${(x,".:")[0 1 16 2 3 16 4 5 15 6 7 8 9 10 11 12 13 14]}'x}

\t {d:"D"$-8#$x;m:+sx2`date`sym`name`cusip`ex`uot!d,.:+s16 -1_("*SS    C I                         ",$[d>2017.11.05;" ";""],$[d>2020.04.16;" ";""],$[d>2020.07.23;"  ";""];,"|")0:S x
  ma@[;`uot;0 10 25 50 100 1000i]update wi:0b from m}'F"eqy_us_all_ref_master_*[0-9]"
if[0N!#m;.[d;();:;m]]

adsftg2:{[a;dpt;xom;f;tw;g] d::*dpt;x::*xom
  p:*`/:(,.Q.par . dpt),`;wf:$[(tt:`trade=dpt 2)|"A"=c:(|$x)9;:;,];wp:tt|"Z"=c
  t:.Q.en[d]@+g f!.:+s16 -1_tw 0:x
  if[par&tt;
    0N!.[;();wf;].'+(!:;.:)@\:t@,/'=(&:'($t`sym)like/:.Q.A,'"*")!`/:'(k:par2 .'dpt,/:.Q.A),'`
    :psym'?k]
  if[par&~tt;
    p:*`/:(,par2 . dpt,c),`; wf:$[c in .Q.A@&i:~~':.q.xrank[hc;.Q.A];:;,]; wp:c in .Q.A@&1_i,1b]
  .[p;();wf;t];if[wp;psym p]}

foo2:{[t;tf;tt;tg;x]adsftg2[0;(dst;"D"$-8#$x;t);(S x;0;0);tf;tt;tg]}

Tf2:`time`ex`sym`cond`size`price`stop`corr
tt2:("*C**IEBI       ";,"|")
tg2:{corr(`sym,tf)#sx2@[@[x;`time;tj];`cond;{x(x in" @")?0b}']}
Qf2:`time`ex`sym`bid`bsize`ask`asize`mode
qt2:("*C*EIEIC              ";,"|")
qt3:("*C*EIEIC               ";,"|")
qg2:{(`sym,qf)#sx2@[x;`time;tj]}

if[(#Q:F"splits_us_all_bbo_*[0-9]")within 1 25;-1"missing quote splits";exit 1]
\t {foo2[`quote;Qf2;$[2017.11.05<"D"$-8#$x;qt3;qt2];qg2]x}'.q.asc Q;
\t {foo2[`trade;Tf2;tt2;tg2]x}'F"eqy_us_all_trade_[0-9]*";

{if[x:@[<:;x;0];x"\\l .";>x]}'host
\w
\\

/a:*(" * ";26 4 42)1:`:d:/taqtrade20030910 c:$[c123;`c1`c2`c3;()] /FTP

`p# fails
2003.09.10
2003.12.12 - 31
2004.05.18 - 31
