#!/bin/bash

## Setup default vars
report_path="/tmp/jmeter-result/report.jtl"
upload_server="jmeter-collector.servicecomb"
testname="spring-demo"

#rm -rf ./dashboard

if [ "$REPORT_UPLOAD_SERVER" != "" ]; then
	echo "Set upload_server to " $REPORT_UPLOAD_SERVER
	upload_server=$REPORT_UPLOAD_SERVER
fi

if [ "$REPORT_PATH" != "" ]; then
	echo "Set report_path to " $REPORT_PATH
	report_path=$REPORT_PATH
fi

if [ "$TESTNAME" != "" ]; then
	echo "Set testname to " $TESTNAME
	testname=$TESTNAME
fi

echo "report_path: " $report_path
echo "upload_server: " $upload_server
echo "testname: " $testname

now_str=$(date +"%Y-%m-%d-%H-%M-%S")
echo $now_str

mkdir -p /${now_str}_jmeter
cd /${now_str}_jmeter

jmeter -g $report_path -o dashboard
cp $report_path ./report.jtl

tar zcf ${now_str}_upload.tgz ./report.jtl ./dashboard/
curl -X POST --data-binary @./"${now_str}"_upload.tgz -H "testname: $testname" http://$upload_server/upload
