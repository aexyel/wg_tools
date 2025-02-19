# RUN as root:
# ( cat peers.txt ; ifconfig wg0 ) | awk -f wgstat2.awk

BEGIN {descr="unknown"; ep="not connected"; dur="ever"};

{
    d[$1]=$0;
}

/wgpeer/ {key=$2; descr=d[key]; if (descr==""){descr=key " unknown"};};
/wgendpoint/ {ep=$2 ":" $3};
/tx:/ {tx=$2;rx=$4};
/handshake:/ {dur=$3 " sec ago"};

/wgaip/ {print "peer:", descr; 
	print " ip:", ep " (" dur ");", "wgaip:", $2;
	print " tx:", tx, "rx:", rx;
	descr="unknown"; ep="not connected"; dur="ever"};
