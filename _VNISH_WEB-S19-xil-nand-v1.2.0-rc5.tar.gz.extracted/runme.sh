#!/bin/sh
# Developed by vnish team

TMPDIR=/tmp/fw.$$
CURDIR=$(pwd)

cleanup() {
	cd "$CURDIR"
	[ -d "$TMPDIR" ] && rm -rf "$TMPDIR"
}

trap cleanup EXIT SIGINT

if [ ! -f sign-public.pem ]; then
	echo "sign-public.pem not found"
	exit 1
fi

if [ ! -f sign-public.pem.sig ]; then
	echo "sign-public.pem.sig not found"
	echo 1
fi

if [ -f /etc/keys/master-public.pem ]; then
	openssl dgst -sha256 -verify /etc/keys/master-public.pem \
		-signature sign-public.pem.sig sign-public.pem > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "Invalid signature for sign-public.pem"
		exit 1
	fi
fi

if [ ! -f fw.tar.gz.sig ]; then
	echo "fw.tar.gz.sig not found"
	exit 1
fi

echo "Verifying fw.tar.gz signature"
openssl dgst -sha256 -verify sign-public.pem \
	-signature fw.tar.gz.sig fw.tar.gz > /dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "Invalid signature for fw.tar.gz"
	exit 1
fi

mkdir -p $TMPDIR

echo "Extracting fw.tar.gz"
tar xzf fw.tar.gz -C "$TMPDIR"
rm -f fw.tar.gz

if [ -f apikeys.json ]; then
	cp apikeys.json "$TMPDIR"
fi

if [ -f anthill.json ]; then
	cp anthill.json "$TMPDIR"
fi

echo "Executing install.sh"
cd "$TMPDIR"
sh install.sh
exit $?
