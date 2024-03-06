import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("127.0.0.1", 8080))
s.send(b"POST / HTTP/1.0\r\nusername: Richard\r\npassword: 3TQI8TB39DFIMI6\r\n\r\n")
response = s.recv(1024)
print('Received', response)
s.close()