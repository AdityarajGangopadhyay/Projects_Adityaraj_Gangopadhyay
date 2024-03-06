# Set your server IP and port
SERVER_IP="127.0.0.1"
SERVER_PORT="8080"

# Variables for storing session cookies
SESSION_COOKIE=""

# Common curl options for HTTP/1.0 and connection close
CURL_OPTIONS="--http1.0 --connect-timeout 5 --max-time 10 --fail --silent"

# Test case 1: Successful login
echo "Test case 1: Successful login"
SESSION_COOKIE=$(curl $CURL_OPTIONS -i -X POST -H "username: Richard" -H "password: 3TQI8TB39DFIMI6" "http://${SERVER_IP}:${SERVER_PORT}/" | grep -i 'Set-Cookie' | cut -d ' ' -f 2 | cut -d '=' -f 2)
echo "\\nCookie (sessionID) for user: $SESSION_COOKIE"

# Test case 2: Access file with valid session
echo "Test case 2: Access file with valid session"
curl $CURL_OPTIONS -v -X GET -H "Cookie: sessionID=$SESSION_COOKIE" "http://${SERVER_IP}:${SERVER_PORT}/file.txt"

# Test case 3: Access file with invalid session
echo "Test case 3: Access file with invalid session"
curl $CURL_OPTIONS -v -X GET -H "Cookie: sessionID=invalid" "http://${SERVER_IP}:${SERVER_PORT}/file.txt"

# Test case 4: Access non-existent file
echo "Test case 4: Access non-existent file"
curl $CURL_OPTIONS -v -X GET -H "Cookie: sessionID=$SESSION_COOKIE" "http://${SERVER_IP}:${SERVER_PORT}/non_existent_file.txt"

# Test case 5: Attempt login with incorrect credentials
echo "Test case 5: Attempt login with incorrect credentials"
curl $CURL_OPTIONS -i -v -X POST -H "username: WrongUser" -H "password: WrongPassword" "http://${SERVER_IP}:${SERVER_PORT}/"
