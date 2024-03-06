import socket
import hashlib
import sys


def main():
    server_name = sys.argv[1]
    server_port = int(sys.argv[2])
    message_filename = sys.argv[3]
    signature_filename = sys.argv[4]

    messages = []
    with open(message_filename, 'rb') as f:
        count = 0
        for line in f:
            count += 1
            if count % 2 == 0:
                messages.append(line.strip().replace(b'\\.', b'.'))

    signatures = []
    with open(signature_filename, 'r') as f:
        for line in f:
            signatures.append(line.strip())

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((server_name, server_port))

    s.sendall(b'HELLO\n')
    response = s.recv(1024).decode('utf-8')
    print(response.strip())
    if response != '260 OK\n':
        print('ErrorLLLLL:', response)
        return

    for i, message in enumerate(messages):
        s.sendall(b'DATA\n')
        s.sendall(message)

        response = s.recv(1024).decode('utf-8')
        print(response.strip())
        if response != '270 SIG\n':
            print('Error:', response)
            return

        signature = s.recv(1024).decode('utf-8').strip()
        print(signature)
        if signature == signatures[i]:
            s.sendall(b'PASS\n')
        else:
            s.sendall(b'FAIL\n')

        response = s.recv(1024).decode('utf-8')
        print(response.strip())
        if response != '260 OK\n':
            print('Error:', response)
            return

    s.sendall(b'QUIT\n')
    s.close()


if __name__ == "__main__":
    main()
