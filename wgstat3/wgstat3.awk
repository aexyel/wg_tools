# RUN as root:
# ( cat /etc/hostname.wg0 ; ifconfig wg0 ) | awk -f wgstat3.awk

BEGIN {descr="# unknown"; ep="not connected"; dur="ever"; mode=1};

/^#/ {descr=$0}

/wgpubkey/ {mode=2}

/wgpeer/ {if(mode==1){
	keys[$2]=$2; ds[$2]=descr; descr="";
	} else {
	key=$2; descr=ds[key]; if (descr==""){descr="# unknown"};
	};
};

/wgendpoint/ {ep=$2 ":" $3};
/tx:/ {tx=$2;rx=$4};
/handshake:/ {dur=$3 " sec ago"};

/wgaip/ {if(mode==2){
	print "peer:", key, descr; 
	print " ip:", ep " (" dur ");", "wgaip:", $2;
	print " tx:", tx, "rx:", rx;
	descr="unknown"; ep="not connected"; dur="ever"
	};
};
