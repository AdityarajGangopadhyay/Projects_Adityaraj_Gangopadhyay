# Set your server IP and port
SERVER_IP="127.0.0.1"
SERVER_PORT="8080"

# Variables for storing session cookies
SESSION_COOKIE=""
SESSION_COOKIE1=""

# Common curl options for HTTP/1.0 and connection close
CURL_OPTIONS="--http1.0 --connect-timeout 5 --max-time 10 --fail --silent"

SESSION_COOKIE=$(curl -i -v -X POST -H "password: 4W61E0D8P37GLLX" "http://${SERVER_IP}:${SERVER_PORT}/" | grep -i 'Set-Cookie' | cut -d ' ' -f 2 | cut -d '=' -f 2)
echo "\\nCookie (sessionID) for user: $SESSION_COOKIE"\

SESSION_COOKIE=$(curl -i -v -X POST -H "username: Jerry" -H "password: 4W61E0D8P37GLLX" "http://${SERVER_IP}:${SERVER_PORT}/" | grep -i 'Set-Cookie' | cut -d ' ' -f 2 | cut -d '=' -f 2)
echo "\\nCookie (sessionID) for user: $SESSION_COOKIE"\

SESSION_COOKIE1=$(curl -i -v -X POST -H "username: Jerry" -H "password: 4W61E0D8P37GLLX" "http://${SERVER_IP}:${SERVER_PORT}/" | grep -i 'Set-Cookie' | cut -d ' ' -f 2 | cut -d '=' -f 2)
echo "\\nCookie (sessionID) for user: $SESSION_COOKIE1"\

SESSION_COOKIE=$(curl -i -v -X POST -H "username: Jerry" -H "password: 4W61E0D8P37GLLX" "http://${SERVER_IP}:${SERVER_PORT}/" | grep -i 'Set-Cookie' | cut -d ' ' -f 2 | cut -d '=' -f 2)
echo "\\nCookie (sessionID) for user: $SESSION_COOKIE"\

curl $CURL_OPTIONS -v -X GET -H "Cookie: sessionID=$SESSION_COOKIE" "http://${SERVER_IP}:${SERVER_PORT}/filed.txt"

SESSION_COOKIE=$(curl -i -v -X POST -H "username: Richard" -H "password: 3TQI8TB39DFIMI6" "http://${SERVER_IP}:${SERVER_PORT}/" | grep -i 'Set-Cookie' | cut -d ' ' -f 2 | cut -d '=' -f 2)
echo "\\nCookie (sessionID) for user: $SESSION_COOKIE"

curl $CURL_OPTIONS -v -X GET -H "Cookie: sessionID=" "http://${SERVER_IP}:${SERVER_PORT}/filed.txt"