// u.q
\c 20 200
\l util.q
.u.subs:([]h:`int$();tabs:();syms:());
.u.getH:{.z.w in exec h from .u.subs};
.u.getHByTab:{exec distinct h from .u.subs where x in ' tabs};
.u.modSub:{[hdl;tab]vals:value exec from .u.subs where h=hdl;`.u.subs upsert@[vals;1;union;tab]};
.u.getHByTab:{[x;y]exec distinct h from .u.subs where x in ' tabs,y in ' syms};
.u.sel:{$[`~y;x;select from x where sym in y]};
//////////////////////////////////////////////////
.u.init:{.u.w:.u.t!(count .u.t:tables`)#()};
// Adding a New Subscription to the TickerPlant
.u.add:{
		$[not count tabs:.u.t inter x; // Check if any table exists
		   :.log.error"Error: Invalid Table Name";
		     (not .u.getH`);
		   `.u.subs upsert (.z.w;tabs;enlist y); // Make Sub
		   .u.modSub[.z.w;tabs]]; // Otherwise Modify Subs
		   // Output Tab Names and Schema
		{(x;$[99=type v:value x;.u.sel[v]y;0#v])}[;y]each x
	};
// Publishing Data to Handles
.u.pub:{[t;x]
	   		if[not count han:.u.getHByTab[t;exec sym from x];:()];
	   		{[h;tab;data](neg h)(`upd;tab;data)}[;t;x] each han
	   	};
.u.getHByTab:{[x;y]exec distinct h from .u.subs where x in ' tabs,(`;y) in ':first each syms}
// Deleting Subscriptions from the .u.sub handle
.u.del:{
	delete from `.u.subs where h=x
	};
// Port Close Call Defined
.z.pc:{.u.del[x]};
// .u.sub call registering subs
.u.sub:{
	if[x~`;:.u.add[.u.t;y]];
	.u.add[x;y]
 };
.u.EndOfDay:{
	t:tables[]except`aggTrade;
	upd::{.[upsert;(x;flip y);{()}]};-11!.u.L;
	.Q.dpft[`:HDB;.z.D;`sym;]each t;
	compCols:{a:("HDB/",string[.z.D],"/"),/:string x;b:string except[;`time]each`$system each "ls ",/:a;raze hsym each '`$(a,'"/"),/:'b}t;
	{-19!(x;x;17;2;6)}each compCols;
	{delete from x}each tables[];
 };
.u.end:{{x(`.u.end)}each exec h from .u.subs};