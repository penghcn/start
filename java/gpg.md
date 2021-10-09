# gpg加密
    gpg --version

    gpg --gen-key
    gpg --full-generate-key  

    gpg --list-keys

    gpg --keyserver pgp.mit.edu --send-keys 6AEE2218768A902C125BBE11B94193F32B8F142E
    gpg --keyserver pgp.mit.edu --recv-keys 6AEE2218768A902C125BBE11B94193F32B8F142E

    gpg --keyserver keyserver.ubuntu.com --send-keys 6AEE2218768A902C125BBE11B94193F32B8F142E
    gpg --keyserver keyserver.ubuntu.com --recv-keys 6AEE2218768A902C125BBE11B94193F32B8F142E

# ssh-keygen
    ssh-keygen -t rsa -f ~/data/test.pem -b 2048 -m PKCS8 -N ''
    openssl rsa -pubout -in ~/data/test.pem -out ~/data/tmp.pub

    cat ~/data/test.pem
    cat ~/data/tmp.pub