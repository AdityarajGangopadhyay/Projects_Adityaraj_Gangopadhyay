import socket
import hashlib
import sys


def main():
    listen_port = int(sys.argv[1])
    key_file = sys.argv[2]

    keys = []
    with open(key_file, 'r') as f:
        for line in f:
            keys.append(line.strip())

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('', listen_port))
    s.listen(1)

    conn, addr = s.accept()
    data = conn.recv(1024).decode()
    print(data.strip())
    if data != 'HELLO\n':
        print('Error:', data)
        conn.close()
        return

    conn.sendall(b'260 OK\n')
    for key in keys:
        data = conn.recv(1024).decode()
        print(data.strip())
        if data == 'QUIT\n':
            print(data.strip())
            conn.close()
            return
        elif data != 'DATA\n':
            print('Error:', data)
            conn.close()
            return

        message = ''
        '''while True:
            line = conn.recv(1024).decode()
            print(line)
            if line == '\n.\n':
                print("BREAK")
                break
            message += line.replace('\\.', '.')'''

        line = conn.recv(1024).decode()
        print(line)
        message += line.replace('\\.', '.')

        h = hashlib.sha256()
        h.update((message + key).encode())
        signature = h.hexdigest()

        conn.sendall(b'270 SIG\n')
        conn.sendall((signature + '\n').encode())

        data = conn.recv(1024).decode()
        print(data.strip())
        if data not in ['PASS\n', 'FAIL\n']:
            print('Error:', data)
            conn.close()
            return

        conn.sendall(b'260 OK\n')
    data = conn.recv(1024).decode()
    print(data.strip())

if __name__ == "__main__":
    main()
