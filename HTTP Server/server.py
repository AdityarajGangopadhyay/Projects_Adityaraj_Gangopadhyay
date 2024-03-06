import socket
import json
import random
import datetime
import hashlib
import sys


def postRequest(username, password):
    if not username or not password:
        return '501 Not Implemented\r\n\r\n', 'LOGIN FAILED'

    with open(jsonFile, 'r') as file:
        accounts = json.load(file)
        if username in accounts and accounts[username][0] == hashlib.sha256((password + accounts[username][1]).encode('utf-8')).hexdigest():
            sessionID = hex(random.getrandbits(64))
            if username in loggedIn:
                sessions.pop(loggedIn[username])

            sessions[sessionID] = [username, datetime.datetime.now()]
            loggedIn[username] = sessionID
            return '200 OK\r\nSet-Cookie: sessionID=' + sessionID + '\r\n\r\nLogged in!', 'LOGIN SUCCESSFUL: ' + username + ' : ' + password
        else:
            return '200 OK\r\n\r\nLogin failed!', 'LOGIN FAILED: ' + username + ' : ' + password


def getRequest(filename, sessionID):
    if not sessionID:
        return '401 Unauthorized\r\n\r\n', ''
    if sessionID not in sessions:
        return '401 Unauthorized\r\n\r\n', 'COOKIE INVALID: /' + filename

    if (datetime.datetime.now() - sessions[sessionID][1]).total_seconds() <= timeout:
        sessions[sessionID][1] = datetime.datetime.now()

        try:
            with open(root + sessions[sessionID][0] + '/' + filename, 'r') as file:
                return '200 OK\r\n\r\n' + file.read(), 'GET SUCCEEDED: ' + sessions[sessionID][0] + ' : /' + filename
        except FileNotFoundError:
            return '404 NOT FOUND\r\n\r\n', 'GET FAILED: ' + sessions[sessionID][0] + ' : /' + filename
    else:
        return '401 Unauthorized\r\n\r\n', 'SESSION EXPIRED: ' + sessions[sessionID][0] + ' : /' + filename


def startServer(ip, port):
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((ip, port))
    server.listen()

    while True:
        client, _ = server.accept()
        request = client.recv(1024).decode('utf-8').split('\r\n')
        method, requestTarget, version = request[0].split()

        if method == 'POST' and requestTarget == '/':
            username = None
            for info in request:
                if 'username:' in info:
                    username = info.split('username:')[1].strip()

            password = None
            for info in request:
                if 'password:' in info:
                    password = info.split('password:')[1].strip()

            statusBody, log = postRequest(username, password)
            print('SERVER LOG: ' + datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S') + ' ' + log)
            client.send((version + ' ' + statusBody).encode('utf-8'))
        elif method == 'GET':
            filename = requestTarget.lstrip('/')
            sessionID = None
            for info in request:
                if 'Cookie:' in info:
                    sessionID = info.split('Cookie: sessionID=')[1].strip()
            statusBody, log = getRequest(filename, sessionID)
            print('SERVER LOG: ' + datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S') + ' ' + log)
            client.send((version + ' ' + statusBody).encode('utf-8'))
        else:
            client.send((version + ' 501 Not Implemented\r\n\r\n').encode('utf-8'))

        client.close()


def main():
    global sessions, timeout, root, jsonFile, loggedIn
    loggedIn = {}
    sessions = {}
    ip = sys.argv[1]
    port = int(sys.argv[2])
    jsonFile = sys.argv[3]
    timeout = int(sys.argv[4])
    root = sys.argv[5]
    startServer(ip, port)


if __name__ == "__main__":
    main()
