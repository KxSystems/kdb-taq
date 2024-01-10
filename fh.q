\l conn.q
.conn.open `localhost:5000; /connect to tickerplant 
syms:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L; /stocks
prices:syms!45.15 191.10 178.50 128.04 341.30; /starting prices 
n:2 /number of rows per update
flag:1; /generate 10% of updates for trade and 90% for quote

getmovement:{[s] rand[0.0001]*prices[s]}; /get a random price movement 
getprice:{[s] prices[s]+:rand[1 -1]*getmovement[s]; prices[s]}; /generate trade price
getbid:{[s] prices[s]-getmovement[s]}; /generate bid price
getask:{[s] prices[s]+getmovement[s]} /generate ask price

/timer function
.z.ts:{
  s:n?syms;
  $[0<flag mod 10;.conn.asyncSend[`localhost:5000;](".u.upd";`quote;(n#.z.N;s;getbid'[s];getask'[s];n?1000;n?1000)); h(".u.upd";`trade;(n#.z.N;s;getprice'[s];n?1000f))];
  flag+:1;
 };
/trigger timer every 100ms
\t 100