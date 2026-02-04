read -p "yiu want to continue ? (Y/N)" choice

case "$choice" in
	Y | y)
		echo "Continue....."
		;;
	N | n)
		echo "Exiting..."
		;;

	*)
		echo "Invalid entry........."

	esac
