import secrets
import string
import argparse

chars = string.ascii_letters + string.digits + string.punctuation
parser = argparse.ArgumentParser()
parser.add_argument("-n", type=int, default=1)
args = parser.parse_args()

for _ in range(args.n):
    pswd = ''.join(secrets.choice(chars) for _ in range(32))
    print(f"{pswd}")
