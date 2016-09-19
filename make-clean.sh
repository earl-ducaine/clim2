rm -rf ~/.cache/common-lisp
find . -name '*.fasl' -print | xargs rm -f
rm -f *.dxl
