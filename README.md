# Read Me
### Contributer
- Yanjun Li (UFID 17869282)
- Shuyu Yin (UFID 70858564)
### Questions
##### problem 1
- In our implementation, work unit refers how large of the sub-problems that is assigned to a worker througth a single request from the server side. To efficiently make use of the computational capability of the worker, the work assigner in the server will send an assignment "seed" to the worker, when the worker first conncets to the server. Througth this way, we ensure that after sending the work assignment one time, the server does not need to send extra information to the client, which largely reduces the time consume on the TCP communication. 
- For the specific work assigment "seed", we implement the following policy to generate it. First, the fixed prefix of the seed is our last names, which is required in the project description. Then based on the work unit setting, which you can flexibly adjust in the program, the server will generate corresponding meta prefix, which differs for the different workers. And the policy ensures that all the meta prefixes will cover intact search scope for the bitcoin. The server will concatnate the fixed prefix and work assignment prefix as a string to send to the assigned worker. After each worker receives the unique seed, it will start to generate the rest part of the final string to be hashed. For example, if the work unit is set as 100 and the string only contains the number, the meta prefix will be divided into 100 pieces, from (00, 01, ..., 98, 99). So if the worker receives the message contains the meta prefix 00, it will be responsible for hashing all the strings starts as fixed prefix + "00", including "001", "002", "0012".  
And here you can also set the total length of the final string. Suppose the total length is given, worker will start from the initial point in the scope and iterate all the possible values to construct the intact final string. Once a string is finalized, it will be hashed by the SHA-256.  

- The result is show below

Worker No. | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11
---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ----
unit 1 | 0.980 | 1.63 | 2.08 | 2.08 | 2.06 | 2.10 | 2.21 | 2.20 | 2.40 | 2.52 | 2.42
unit 2 | 0.975 | 1.805 | 2.53 | 2.99 | 3.49 | 3.63 | 4.06 | 4.21 | 4.45 | 4.46 | 4.30

##### problem 2
- The result of running ./project 4 is showing below(run for 3 minutes)
- 
                yanjunshuyu;eaaaaabren	00005989C4967825D4B54ECB48CC5B1F39E2E6D62A8BCAD74E8E6FA5A887AECC
                yanjunshuyu;baaaaabzve	00007F2B6EEE52E693D01300E8234DC34FFA86161BD3963A336E99F92272A610
                yanjunshuyu;daaaaacdwr	0000B0B7A81491AEBE98A18BA6BDB69B2B2FE36122C91300BA55EBDB6DF4C6B7
                yanjunshuyu;aaaaaacohb	0000B812D3786718EE4A5E4F21640F3B54AB4CA8AAD1CFE2ABD5B298A404C0A6
                yanjunshuyu;baaaaadqne	0000764218B726ED34E1B4DCCB0C7945CA8C356D03FE60723D20EC3B64D32E1A
                yanjunshuyu;caaaaaeadr	00002F6B6D60E9F708A623ECE7EEE41E1B5ED6175E06905274542EEBCFF9F4DF
                yanjunshuyu;eaaaaaefdx	00004B0BD9A303B3A3BC1E82F49B4170C103FA626337993FD8DD5FCDC0B20EDD
                yanjunshuyu;daaaaaehgv	00008FF45CCAF2E391ECC18E62A62C600B5E216808177DDD4BC86C7FA8D0C8B2
                yanjunshuyu;daaaaaesql	0000EA9A7A06803095B17FC0FC29F8709E82D4DA337BBD629C52ABB8F1EBB97A
                yanjunshuyu;gaaaaaegkz	00007AF604E6B4773B869B71BD40971D1641703E897B359B548B78E8591E813F
                yanjunshuyu;caaaaagetv	0000C8368B6E411A813FBF88BDBF74E15BB6719620B226879F87B7E1374819D4
                yanjunshuyu;gaaaaagbbj	0000AE111FDDBBD8CA28980BDCA21435CFAA14EC0C481F6CC2E1BDB62403BD95
                yanjunshuyu;eaaaaagurz	00008B8D75B2388FD46FFD90FFE22A9595FF893EA6F7199D92D5BDF90BEA3F3C
                yanjunshuyu;haaaaagojh	0000BC0249EB4F5C35647C7B748673F8E8F8BD7CC21E297536B367FC6EBDD75A
                yanjunshuyu;faaaaagyuo	0000608623D659AC1BC9606F2DA8D5AB593FF14CB0B6691FDF495B1AF53748A1
                yanjunshuyu;gaaaaahkyb	0000500FA882D24563FD7899102D44A4D0CCF20116C3CB347561451F11B30BB0
                yanjunshuyu;haaaaahpeu	0000CE7D9E40C6DE8A19E2A54D4A7B84093DE15B8EC36849A0808F2A452DC9C2
                yanjunshuyu;faaaaaiffu	00001A98D1734777DAADA3C7810A9DA830023088CA0368630F28407C344F2448
                yanjunshuyu;faaaaaigis	00000E2FC190CD31D7EACC934FEFFA17670C28AFA711FEB003E9A664B8D162F8
                yanjunshuyu;caaaaajysi	00000A44829D03D059F37631EAECC772AE1410CA4D8677DD4E869D50405F9105
                yanjunshuyu;faaaaakqdz	0000CBEA16734B2F1853DB39D555E74612BF1AD42FF8ADD56AB4AB7E374BDD55
                yanjunshuyu;eaaaaakuxq	0000DB5310E341D2E146055BA611C9C1458A983A81562913BDD59317F14A7B19
                yanjunshuyu;caaaaaljnp	0000CB91998D0A1F72DA33D796360E4735BB04860C3D618EF4FCFAAC883088DC
                yanjunshuyu;faaaaalhjx	0000433DD9875A7E7CC41D762EBE4C5B81396082373890D951D24864A1D958E9
                yanjunshuyu;caaaaambcn	0000472818F7148181D91F8D2D6102B8884E14EF133E90E8C163627A653D7786
                yanjunshuyu;aaaaaandjg	0000C4B58B39A291563518DAAA5539984F80FE5A39CC83734F921A35C57D7D10
                yanjunshuyu;faaaaandjy	00000A15F8B6047ED525D68F3B7CBB7D29AEBA0BA79EB6CCA19A7095A2D3F856
                yanjunshuyu;baaaaankdj	0000B2A376C78EDFB0E5B4F04E32610B0E12CC32D06557CCDA54CB6A9C6917A5
                yanjunshuyu;baaaaanxkj	00003CB36F6F944BCA104286E63D1A50DBFB2251298FC97E056C173A763E554D
                yanjunshuyu;aaaaaaqdny	000079D616F0D880EF7ACD3E98F97D03365BAB3EFAA7D3D34F02C117F04FE169
                yanjunshuyu;faaaaappre	00005F5E99910F5E23F3D49F413F0616D127ED0BD35B0D3B9BC397BAD5542A6E
                yanjunshuyu;gaaaaaqqcg	00003FCB1B2182AB361337312D029B4B60B1EFD0EF208DDB86671A368B62D878
                yanjunshuyu;baaaaasacn	0000C91206B8BE54F86D578AEDD9F29CBF9AB357C43A6B511266C7541D072215
                yanjunshuyu;eaaaaarztr	000041403555496DF5B4E763480010D9F6B4268863CB253FF99F9604EAC87C55
                yanjunshuyu;faaaaasehm	00007ED95073B0F5DC49268AC6C1BD1E849E73B96DB18B153CD76AFED094E623
                yanjunshuyu;eaaaaasqza	0000CCD519387A894A301FB8DF5F45FF32F2071F11AF8F9F061114EE3E922A11
                yanjunshuyu;caaaaathwg	00007524DDEC6BE168F11D21F18A7B831156B208AB1D5D46F28341411DD0C507
                yanjunshuyu;gaaaaasrde	00002CE5D42260B1AF4F26980D84076E9876AF161CA1BAFF18F365DE4687AACE
                yanjunshuyu;baaaaauzxv	0000686CB2D1DD8C8627308EEB77563B1803E07D1012C9EADB31DA3113EA99E5
                yanjunshuyu;eaaaaavoci	0000CB67E44EC7CCF4151D45499116415DE7B679DD231D3C7227F05D3C66BEAB
                yanjunshuyu;faaaaavqmk	00003BE612EBDE6DFCC7B43413975D2EAEAA464B32D7A501DF0018C45831580F
                yanjunshuyu;eaaaaavteo	0000802E8966892A141F278C4E5AE0F66887D94543890664DE2AC89AF920DD8F
                yanjunshuyu;daaaaawpoa	0000E6CF2994EB247E1F963054A36D2A78C37CE4E328635BF49DF83ECB19F8CF
                yanjunshuyu;haaaaawfxa	00009D231E01C07B104BD6EF8AD465ABB7958460E6AA63A36351279A0FB6BEC8
                yanjunshuyu;aaaaaaxnnd	000066B751756722818373F9F6025A4D684DA11032335E547AD244662A1814F4
                yanjunshuyu;aaaaaayddc	0000B1C23F0842B6E7D7B7F9FE8F05A4C9894EB2F81C98F3758E979E9BE6AC8F
                yanjunshuyu;haaaaaxqys	0000C49693D058192805F64EE3E01401985A3C220DCB9754F324EAF05A0E1668
                yanjunshuyu;caaaaaypeb	0000DF64D2A763D346EEED51E5030F153B0C5FAB5AC576DE8E39182E86A6307C
                yanjunshuyu;caaaaayqoj	00003F37A67A44DA6F0D25379DBBDAD1E16F78286C8CD0AF8190247A6880E9BA
                yanjunshuyu;eaaaaaytmd	00009C09B90058A41E8669E365F1BDA624662F7A659203C4158FA46B12693EFA

##### problem 3
- The CUP information is: 1.6 GHz Intel Core i5 with 2 core 4 thread
- The Memory information is: 4 GB 1600 MHz DDR3
- The CPU time (User time) and real time is: 

        real    3m7.356s
        user    10m42.677s
- We can see that the ratio is above 3. 

##### problem 4
- The coin with the most 0s we managed to find is as follow, which with nine 0s:
- 
                yanjunshuyu;apaeiklcsh  0000000001A9FF7FEB0B83D0EB1826FFF5FC5714FB4DE97E6B9BC7AC55F58D8E
##### problem 5
- We run 1 worker in one machine and it could connect at most 12 machines together.
