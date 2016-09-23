
LD_RUN_PATH=/usr/lib:/lib:/usr/lib
export LD_RUN_PATH

function run_lisp {
    cat "$1" | alisp -I alisp.dxl  -batch -locale japan.euc  -batch -backtrace-on-error
}

run_lisp build.tmp
# run_lisp cat.tmp

status=$?

exit $status
