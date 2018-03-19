BASEURI=http://172.17.0.2:5984
PASSWORD=JYva992Yri87SvRh

curl -X PUT $BASEURI/peacock
curl -X PUT $BASEURI/_config/admins/admin -d "\"$PASSWORD\""
