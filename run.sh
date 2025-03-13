#!/bin/sh

run_jdb(){
	./RunningAppInfo |
		jq -c |
		dasel \
			--read=json \
			--write=yaml |
		bat --language=yaml
}

which jq    | fgrep -q jq    || exec ./RunningAppInfo
which dasel | fgrep -q dasel || exec ./RunningAppInfo
which bat   | fgrep -q bat   || exec ./RunningAppInfo

run_jdb
