cat "$1" | alisp -I alisp.dxl -qq -batch -backtrace-on-error -locale japan.euc -q -batch -backtrace-on-error

status=$?

exit $status
