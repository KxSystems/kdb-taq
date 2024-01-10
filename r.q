/q tick/r.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
/2008.09.09 .k ->.q
\c 20 200
\l util.q
if[not "w"=first string .z.o;system "sleep 1"];
.conn.open`localhost:5000;
updVanilla:{if[not x in tables[];:()];.[upsert;(x;flip y);{()}]};

computeAggs:{updVanilla[x;y];
 aggTrade:`sym xcols 0!(?[trade;();(enlist`sym)!enlist`sym;
	    	(!). flip
		  	((`time 		;(last;`time));
	       	(`maxTPrice 	;(max;`price));
	       	(`minTPice 	;(min;`price));
	 	   	(`tVolume 	;(sum;`size)))])
	   	lj
	  	   ?[quote;();(enlist`sym)!enlist`sym;
	    	(!). flip 
	  	  	((`bestBid 	;(max;`bid));
	  	   	(`bestAsk   	;(min;`ask)))];
  if[0=count aggTrade;:()];
  .conn.asyncSend[`localhost:5000;](`.u.upd;`aggTrade;value flip aggTrade);
 };
 .pc.data:();
defTabs:`trade`quote;
subsTabs:{a:$["," in x;`$"," vs x;`$x];$[1=count a;1#a;a]}getenv `SUBTABS;
// Set Upd Based On Config
upd:$[(getenv `AGGRDB) like "TRUE";computeAggs;updVanilla];
// Takes Conf Tabs: if AggRDB T&Q Required to complete Aggr
tabs:{$[(getenv `AGGRDB) like "TRUE";defTabs;all subsTabs=`;defTabs;subsTabs]}[];
/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");
/ end of day: save, clear, hdb reload
.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};
/ init schema and sync up from log file
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;
	.log.info "Replaying Log Messages to Ensure Sync Up:","\n",.Q.s tables[]!count each value each tables[]};
/ connect to ticker plant for (schema;(logcount;log))
//.u.rep . {schemas:.conn.syncSend[`localhost:5000;](`.u.sub;tabs;`);(enlist schemas),enlist .conn.syncSend[`localhost:5000;](`.u;`i`L)}tabs;
.u.repSpec:{[tpLog;t;sym]
	if[b:(a:(get tpLog)[0;0])in system"f";updOld:value a];
	a set {[tc;symc;t;data]if[t<>tc;:()];data:(flip data) where symc=data[1];.[upsert;(t;data);{()}]}[t;sym;;];
	-11!tpLog;
	//if[b;a set updOld];
	.log.info"Replayed ",string[t]," Log for Sym: ",string[sym]," - ",string[count[value[t]]]," rows";
 };
 //.u.PubCSVtoTP[`:trade.csv;`localhost:5000]
 .u.PubCSVtoTP:{
 	data:(exec t from meta value a:-4_except[;":"]string x;enlist",")0:x;
 	.conn.asyncSend[y;(`upd;`$a;data)]
  };








