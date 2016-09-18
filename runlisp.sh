cat "$1" | alisp -I /home/rett/dev/acl100express/alisp.dxl -qq -batch -backtrace-on-error -locale japan.euc -q -batch -backtrace-on-error

status=$?

exit $status
