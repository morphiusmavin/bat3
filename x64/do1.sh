make clean
make &> out.txt
cat out.txt | grep error
echo ""
ls -ltr *.o
