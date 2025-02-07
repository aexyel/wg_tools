# RUN as root:
# ifconfig wg0 | awk -f wgstat.awk

BEGIN {descr="unknown"; ep="not connected"};


# add your peers below
# vvvvvvvvvvvvvvvvvvvv

# peer's pubkeys -> descr; escape "+" and "/" with "\" symbol

/94egwYT7D0\/IigTUFuWcWL6U9npywzfMxaF3ycnLn3g=/ {descr="home"};
/fij7BXDno6yU0p\+7Emy\/LbB5zFGg4uKaCmSH\+xyOMJE=/ {descr="office"};

# ^^^^^^^^^^^^^^^^^^^^
# add your peers above


/wgpeer/ {key=$2};
/wgendpoint/ {ep=$2 ":" $3};
/tx:/ {tx=$2;rx=$4};

/wgaip/ {print "peer:", key, descr; 
	print " ip:", ep ";", "wgaip:", $2;
	print " tx:", tx, "rx:", rx;
	descr="unknown"; ep="not connected"};
