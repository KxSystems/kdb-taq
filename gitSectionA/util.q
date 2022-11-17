//////////////////////////////////////////////////////
//                                                  //
//         Overwrite of Logging Library             //
//                                                  //
//////////////////////////////////////////////////////
.log.initialised:0b;
.log.info:{.log.conn@"\n","Info Log @ ",string[.z.Z]," ",("[",";" sv string value .Q.w[]),"]: ",x;};
.log.error:{.log.conn@"\n","Error Log @ ",string[.z.Z]," ",("[",";" sv string value .Q.w[]),"]: ",x;};
.log.init:{
	if[.log.initialised=1b;:()];
	.log.lName:$[""~a:getenv`LOGDIR;(("logs/proc"),first string 1+count system "ls logs"),".log";a];
	.log.conn:hopen hsym `$.log.lName;
	.log.info"Log Library Initialised: ",.log.lName;
	.log.initialiased:1b;
 };
.log.init[];
//////////////////////////////////////////////////////
//                                                  //
//           Overwrite of Conn Library              //
//                                                  //
//////////////////////////////////////////////////////
.conn.priv:1!flip(`cName`h`lastUpdate`status`err)!(());
.conn.open:{
			`.conn.priv upsert(x;0Ni;.z.Z;`;`);
			x1:$[10h=type x;hsym `$x;hsym `$ string x];
	        val:@[hopen;x1;{`.conn.priv upsert(x;0Ni;0Nz;`DOWN;`$y);y}[x]];
	        $[-6h=type val;[`.conn.priv upsert(x;val;.z.Z;`UP;`);1b];:0b]
	};
.conn.close:{
		`.conn.priv upsert(x;0Ni;.z.Z;`;`);
		x1:$[10h=type x;hsym `$x;hsym `$ string x];
		if[not x in key .conn.priv;:.log.error"Invalid Connection Name: Conn Must be present in .conn.priv"];
		`.conn.priv upsert(x;0ni;.z.Z;`CLOSED;`);
	    hclose x1;1b
	};
.conn.syncSend:{[cName;data]
	   if[not cName in key .conn.priv;:.log.error"Invalid Connection Name: Conn Must be present in .conn.priv";];
	   if[(.conn.priv[cName]`status)in`DOWN`CLOSED;[.log.info"Connection Down! Retrying Connection...";.conn.open[cName]]];
	   .[{[cName;data](.conn.priv[cName]`h)(data)};(cName;data);
	   		{$[y like "Cannot write to handle*";
	   			[`.conn.priv upsert(x;0Ni;.z.Z;`DOWN;`$y);.log.error("Connection Failed: "),string y;];
	   			x]
	   		}[cName]
	   	]
	};
.conn.asyncSend:{[cName;data]
	   if[not cName in key .conn.priv;:.log.error"InValid Connection Name: Conn Must be present in .conn.priv";];
	   if[(.conn.priv[cName]`status)in`DOWN`CLOSED;[.log.info"Connection Down! Retrying Connection...";.conn.open[cName]]];
	   .[{[cName;data](neg .conn.priv[cName]`h)(data)};(cName;data);
	   		{$[y like "Cannot write to handle*";
	   			[`.conn.priv upsert(x;0Ni;.z.Z;`DOWN;`$y);0N!raze("Connection Failed: "),string y;];
	   			x]
	   		}[cName]
	   	]
	};
.z.ts:{.log.info .Q.s .conn.priv};
//if[0i=system "t";system "t 60000"]; // if time is not set logging will be created to pub every minute