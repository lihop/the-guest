if [ "$(id -u)" != "0" ]; then 
	logger -p auth.info "$(whoami) login on 'console'"
fi
