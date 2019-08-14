# CFSSL

|Go.x509.KeyUsage|CFSSL config.json| id-ce-keyUsage|Comment|
|-----|-----|-----|-----|
|KeyUsageDigitalSignatureKeyUsage|digital signature|digitalSignature||
|KeyUsageContentCommitment|content commitment|nonRepudiation|recent editions of X.509 have renamed this bit to contentCommitment|
|KeyUsageKeyEncipherment|key encipherment|keyEncipherment||
|KeyUsageDataEncipherment|key agreement|dataEncipherment||
|KeyUsageKeyAgreement|data encipherment|keyAgreement||
|KeyUsageCertSign|cert sign|keyCertSign||
|KeyUsageCRLSign|crl sign|cRLSign||
|KeyUsageEncipherOnly|encipher only|encipherOnly||
|KeyUsageDecipherOnly|decipher only|decipherOnly||


````
docker run -ti -v c:\docker/shared:/shared cfssl
cfssl gencert -initca ca_csr.json  | cfssljson -bare /shared/hasCA

cfssl gencert -ca /shared/hasCA.pem -ca-key /shared/hasCA-key.pem -config="config.json" -profile="intermediate" ica-csr.json | cfssljson -bare /shared/hasICA

cfssl gencert -ca /shared/hasICA.pem -ca-key /shared/hasICA-key.pem -config=config.json -profile="server" destek.csr.json |cfssljson -bare /shared/destek

cat /shared/hasICA.pem /shared/hasCA.pem > /shared/hasCA-chain.pem



openssl verify -CAfile /shared/hasCA.pem /shared/hasICA.pem

cat /shared/hasICA.pem /shared/hasCA.pem > /shared/hasCA-chain.pem

openssl verify -CAfile hasCA-chain.pem /serv/destek.pem
cat /shared/hasICA.pem /shared/hasCA.pem > /shared/hasCA-chain.pem
````
https://propellered.com/post/cfssl_setting_up/
