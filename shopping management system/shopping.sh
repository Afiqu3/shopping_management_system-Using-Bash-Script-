function welcome () {
	clear
	echo "----------------------------------------------------"
	echo "<-----------> Welcome to Afique's shop <----------->"
	echo "----------------------------------------------------"
	echo "							  "
}

function intro () {
	echo "Are you admin or customer?"
	echo "1. Admin"
	echo "2. Customer"
	echo "3. Exit"
	checkIntro
}

function checkIntro () {
	echo ""
	read -p "Enter your choice: " choice
	if [ $choice -eq 1 ]
then
	admin
	elif [ $choice -eq 2 ]
then
	customerMenu1
	elif [ $choice -eq 3 ]
then
	echo -e "\nThanks for visiting.Come back again.\n"
	exit
	else
	echo "invalid choice"
	intro
fi
}

function admin () {
	echo ""
	read -p "Enter your user name: " adminUN
	read  -p "Enter your password: " adminPW
	if [ $adminUN == "admin" ] && [ $adminPW == "admin123" ]
then
	adminMenu
	else
	echo "Invalid Password!"
	read -p "Are you continue?[y/n] " choice
	if [ $choice == "y" ] || [ $choice == "Y" ]
then
	admin
	else
	intro
fi
fi
}

function adminMenu () {
	echo ""
	echo "1. Add product category"
	echo "2. Add new product"
	echo "3. Update product info"
	echo "4. Product info"
	echo "5. Log out"
	readAdminMenu
}

function readAdminMenu () {
	echo ""
	read -p "Enter your choice: " choice
	case $choice in
	1)
	addCategory
	;;
	2)
	addNewProduct
	;;
	3)
	updateProductInfo
	;;
	4)
	showProduct
	adminMenu
	;;
	5)
	intro
	;;
	*)
	echo "Invalid input"
	adminMenu
	;;
	esac
}

function addCategory () {
	echo ""
	read -p "Enter category name: " category
	echo "$category" >> categories.csv
	read -p "Do you want to add more category?[y/n] " ans
	if [ $ans == "y" ] || [ $ans == "Y" ]
then
        addCategory
        else
        adminMenu
fi
}

function addNewProduct () {
	echo ""
	read -p "Enter category name: " category
	read -p "Enter product name: " pname
	read -p "Enter quantiy: " quantity
	read -p "Enter price: " price
	if [[ -z $category ]] || [[ -z $pname ]] || [[ -z $price ]] || [[ -z $quantity ]]
then
	echo "Please provide all information"
	addNewProduct
fi
	#price=`echo "scale=3; $price / 1" | bc`
	echo "$pname,$price,$quantity" >> $category.csv
	echo -e "New product added successfully\n"
	read -p "Do you want to add more product?[y/n] " ans
        if [ $ans == "y" ] || [ $ans == "Y" ]
then
        addNewProduct
        else
        adminMenu
fi
}

function updateProductInfo () {
	echo -e "\nWhich field you want to update ?"
	echo -e "1. Price\n2. Quantity"
	read -p "Enter your choice: " choice
	if [ $choice -eq 1 ]
then
	updatePrice
	adminMenu
	elif [ $choice -eq 2 ]
then
	updateQuantity
	adminMenu
	else
	echo -e "Invalid Input!!!"
	adminMenu
fi
}

function updatePrice () {
	echo ""
	read -p  "Enter category name: " catg
	read -p "Enter product name: " pdt
	read -p "Enter new price: " nprc
	inputfile=$catg.csv
	OLDIFS=$IFS
	IFS=','
	[ ! -f $inputfile ] && { echo "$inputfile file not found!!!"; updateProductInfo; }
	while read pname ppc pqnt
	do
		if [ "$pdt" == "$pname" ]
		then
			echo "$pname,$nprc,$pqnt" >> temp.csv
		else
			echo "$pname,$ppc,$pqnt" >> temp.csv
		fi
	done < $inputfile
	IFS=$OLDIFS
	echo "Price updated successfully"
	rm $catg.csv
	mv temp.csv $catg.csv
}

function updateQuantity () {
        echo ""
        read -p  "Enter category name: " catg
        read -p "Enter product name: " pdt
        read -p "Enter the quantity need to added: " nqnt
        inputfile=$catg.csv
        OLDIFS=$IFS
        IFS=','
        [ ! -f $inputfile ] && { echo "$inputfile file not found!!!"; updateProductInfo; }
        while read pname ppc pqnt
        do
                if [ "$pdt" == "$pname" ]
                then
                        echo "$pname,$ppc,$((pqnt + nqnt))" >> temp.csv
                else
                        echo "$pname,$ppc,$pqnt" >> temp.csv
                fi
        done < $inputfile
        IFS=$OLDIFS
        echo "Quantity updated successfully"
        rm $catg.csv
	mv temp.csv $catg.csv
}

function showProduct () {
	read -p  "Enter category name: " catg
	inputfile=$catg.csv
        OLDIFS=$IFS
        IFS=','
        [ ! -f $inputfile ] && { echo "$inputfile file not found!!!"; updateProductInfo; }
	echo -e "\n\n\tProduct Name\t\tPrice\t\tQuantity"
        while read pname ppc pqnt
        do
		 echo -e "\t$pname\t\t\t$ppc\t\t$pqnt"
        done < $inputfile
        IFS=$OLDIFS
}

function customerMenu1 () {
	echo -e "\n1. Register"
	echo -e "2. Log In"
	echo -e "3. Go back\n"
	readCustomerMenu1
}

function readCustomerMenu1 () {
	read -p "Enter your choice: " choice
        if [ $choice -eq 1 ]
then
        customerRegister
	customerMenu1
        elif [ $choice -eq 2 ]
then
        customerLogin
	customerMenu2
        elif [ $choice -eq 3 ]
then
        intro
        else
        echo "invalid choice"
        customerMenu1
fi
}

function customerRegister () {
	echo ""
	read -p "Enter a user name: " uname
	read -p "Enter password: " paswd
	read -p "Enter your contract no.: " cnum
	if [ -z $uname ] || [ -z $paswd ] || [ -z $cnum ]
then
	echo "Please provide all information"
	customerRegister
fi
	flag=0
	while (( flag == 0 ))
do
	flag=1
	inputfile=customerInfo.csv
        OLDIFS=$IFS
        IFS=','
        [ ! -f $inputfile ] && { flag=2; }
	if [ $flag -eq 2 ]
then
	break
fi
        while read x y z
        do
             if [ "$x" == "$uname" ]
	then
		flag=0
	fi
        done < $inputfile
        IFS=$OLDIFS
	if [ $flag -eq 0 ]
then
	echo "This user name is already used"
	read -p "Enter a user name: " uname
fi
done
	echo "Registered Successfully!!!"
	echo "$uname,$paswd,$cnum" >> customerInfo.csv
}

function customerLogin () {
	echo ""
        read -p "Enter user name: " uname
        read -p "Enter password: " paswd
	flag=1
        inputfile=customerInfo.csv
        OLDIFS=$IFS
        IFS=','
        [ ! -f $inputfile ] && { echo "Register first to log in"; customerMenu1; }
        while read x y z
        do
             if [ "$x" == "$uname" ] && [ "$y" == "$paswd" ]
        then
                flag=0
        fi
        done < $inputfile
        IFS=$OLDIFS
        if [ $flag -eq 0 ]
then
        echo "Log in successfully!!!"
	else
	echo "Wrong username or password!!!"
	customerMenu1
fi
}

function customerMenu2 () {
	echo -e "\n1. Account Info"
	echo  -e "2. Update Password"
	echo -e "3. Buy Product"
	echo -e "4. Log out"
	readCustomerMenu2
}

function readCustomerMenu2 () {
	read -p "Enter your choice: " choice
        if [ $choice -eq 1 ]
then
        customerAccountInfo 
        elif [ $choice -eq 2 ]
then
        updatePassword
        elif [ $choice -eq 3 ]
then
        buyProduct
	elif [ $choice -eq 4 ]
then
        customerMenu1
        else
        echo "invalid choice"
        customerMenu2
fi
}

function customerAccountInfo () {
	echo ""
	read -p "Enter user name: " uname
	inputfile=customerInfo.csv
        OLDIFS=$IFS
        IFS=','
        [ ! -f $inputfile ] && { echo exit; }
        while read x y z
        do
		if [ "$uname" == "$x" ]
then
		echo "User Name: $x"
		echo "Password: $y"
		echo "Contract No.: $z"
fi
        done < $inputfile
        IFS=$OLDIFS
	customerMenu2
}

function updatePassword () {
	echo ""
        read -p "Enter user name again: " uname
        read -p "Enter old password: " opaswd
	read -p "Enter new password: " npaswd
	inputfile=customerInfo.csv
	OLDIFS=$IFS
	IFS=','
	[ ! -f $inputfile ] && { echo "$inputfile file not found!!!"; exit; }
	while read x y z
	do
		if [ "$x" == "$uname" ]
		then
			echo "$uname,$npaswd,$z" >> temp.csv
		else
			echo "$x,$y,$z" >> temp.csv
		fi
	done < $inputfile
	IFS=$OLDIFS
	echo "Password updated succcessfully!!!"
	rm customerInfo.csv
	mv temp.csv customerInfo.csv
	customerMenu2
}

function buyProduct () {
	echo ""
	i=0
	ar=()
	inputfile=categories.csv
        OLDIFS=$IFS
        IFS=','
        [ ! -f $inputfile ] && { echo exit; }
        while read x
        do
		echo "$((i + 1)). $x"
		i=$((i + 1))
		ar+=($x)
        done < $inputfile
        IFS=$OLDIFS
	len=${#ar[*]}
	read -p "Enter your choice: " choice
        if [ $choice -gt $len ]
then
        echo "invalid choice"
        buyProduct
fi
	choice=$((choice -1))
	inputfile=${ar[$choice]}.csv
	pn=()
	pq=()
	pp=()
        OLDIFS=$IFS
        IFS=','
        [ ! -f $inputfile ] && { echo exit; }
        while read x y z
        do
		echo -e "Product name: $x\t Available Quantity: $z\t Price: $y BDT"
		pn+=($x)
		pq+=($z)
		pp+=($y)
        done < $inputfile
        IFS=$OLDIFS
	read -p "Enter the product name which you want to buy: " selectProduct
	flag=0
	selectpos=0
	while (( flag == 0 ))
	do
		for (( j = 0; j < ${#pn[*]}; ++j ))
		do
		if [ "${pn[$j]}" == "$selectProduct" ]
		then
			selectpos=$((j))
			flag=1
		fi
		done
	if [ $flag -eq 0 ]
	then
		echo -e "Wrong product name!!"
		read -p "Enter the product name which you want to buy: " selectProduct
	fi
	done
	read -p "Enter the quantity for $selectProduct: " qnum
	flag=0
	while (( flag == 0 ))
	do
		if [ ${pq[$selectpos]} -ge $qnum ] && [ $qnum -ge 0 ]
		then
		flag=1
		break
		fi
	echo -e "Enter the available quantity."
	read -p "Enter the quantity for $selectProduct: " qnum
	done
	payment=`echo "scale=3; $qnum * ${pp[selectpos]}" | bc`
	echo "Your have to pay $payment BDT"
	inputfile=${ar[$choice]}.csv
        OLDIFS=$IFS
        IFS=','
        [ ! -f $inputfile ] && { exit; }
        while read x y z
        do
                if [ "$x" == "$selectProduct" ]
                then
                        echo "$x,$y,$((z - qnum))" >> temp.csv
                else
                        echo "$x,$y,$z" >> temp.csv
                fi
        done < $inputfile
        IFS=$OLDIFS
        rm ${ar[$choice]}.csv
	mv temp.csv ${ar[$choice]}.csv
	customerMenu2
}

#main program start here
welcome
intro

