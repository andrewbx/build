#!/bin/bash
#--------------------------------------------------------------------------
# Program     : build_docker
# Version     : v1.0
# Description : Dirty script to manage docker containers.
# Syntax      : build_docker.sh
# Author      : Andrew (andrew@devnull.uk)
#--------------------------------------------------------------------------

#set -x
workdir=$PWD
docker_app=docker.app
export BUILDKIT=1

function help()
{
cat << EOF
Build/maintain docker applications.

Usage: $0 [-c|-b|-r|-m|-h]
Options:
  -c|--clean		Cleanup docker images/containers
  -b|--build true|false	Build with encryption/no encryption
  -r|--run		Run containers
  -m|--mkssl		Make SSL Certificates
  -h|--help		Display this help

EOF
}

function docker_clean()
{
	echo "[+] Clean up docker stuff..."

        if [[ ! -z $(docker ps -a -q --filter ancestor=$docker_app) ]]; then
                docker stop $(docker ps -a -q --filter ancestor=$docker_app)
        fi

	if [[ ! -z $(docker ps -a -q --filter ancestor=$docker_app) ]]; then
		docker rm $(docker ps -a -q --filter ancestor=$docker_app) -f
	fi

	if [[ ! -z $(docker images -q $docker_app | uniq) ]]; then
		docker rmi $(docker images -q $docker_app | uniq) -f
	fi
}

function build_sslcert()
{
	echo "[+] Make Server Certificates for TLS..."
	$PWD/bin/build_sslcert.sh
}

function docker_build()
{
	if (( $# < 1 )); then
		help
		exit
	fi

	echo "[+] Build docker service..."
	docker build . --no-cache -t $docker_app -f $PWD/docker/docker-file-$docker_app --build-arg SSL=$1
}

function docker_run()
{
	echo "[+] Start up docker service..."
	docker run --rm -p -d $docker_app
}

main() {
	if (( $# < 1 )); then
		help
	else
	while [ $# -ne 0 ]; do
		case $1 in
		-c | --clean )	shift;
				docker_clean
				exit
				;;
        	-b | --build )	shift;
				docker_build $1
				exit
                                ;;
                -r | --run )	shift;
				docker_run
				exit
                                ;;
                -m | --mkssl )	shift;
				build_sslcert
				exit
				;;
        	-h | --help )	help
                                exit
                                ;;
        	* )		help
                                exit 1
    		esac
    	shift
	done
	fi
}

main "$@"
