    read -p "Test of Green Env is working: 0 or 1:  " result
    echo $result
    if [ $result -eq 0 ];then echo $result; else echo "Fail";exit; fi

    echo "Out"
