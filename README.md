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

        yanjunshuyu;cwtss70f41 00000AB5A22E2B370AEEE2D2EB1815A27578C068CE678D8EC082C49E43241F0A
        yanjunshuyu;e6m44a3l6s  0000302166330A20274264C2DA3C9BE7D6870A4B08F672946EEBF63CA17D8AB6
        yanjunshuyu;acw2t4gpy2  000031EC14A475420C511972040990C91AC21006E78D9BEAA9336F736F0021C9
        yanjunshuyu;et6e5natn8  00000077EF136EB442AD028B007979BAA51AF1599A3943E5A7FDC5FC552286AE
        yanjunshuyu;e1r9my1kc0  00007B122469F9B21BF6DBCDDDD59ABAF0C158921CB895665E1E5C0FCACA3F9D
        yanjunshuyu;gjlng9psc7  0000BFB70DE59CDB3FF7B75148BBB828390203461B12C3A1206173AB36B2F8C6
        yanjunshuyu;hsccpiv0rf  00007508DADC1DA0A4472C55D4C3CB0C0FEBD66041E755763BCB4E815F2699AD
        yanjunshuyu;icg0jla9n6  000050BC2ED2FE0D52185704D4645F1C8206094B3E32BF8C15B28E04A5A2AF8F
        yanjunshuyu;e11fvgj2gs  0000A7C78A94EFBEC19911F1691BD5C0F94EC87020CBA1D4CFCCAB84C3772E1E
        yanjunshuyu;c25scehaml  0000D323160CAFE2066D8EE4D9FD183E9D9FAC6C609FD9905BD43316359307D4
        yanjunshuyu;in7jdlzo6l  00000F63F9380B5A7C07115650F934DB13E99EF8128F6E1475C338FD565453BA
        yanjunshuyu;ceo37v1cf6  0000D7E1D72E82C2F25CA3D01DBA4CC6BBA5A04B99BF49327B12D8B1E1D18791
        yanjunshuyu;ad3ww2p2rj  0000EB95ECAA51F6CDF04768D328367679EFDCD7F51DA7595C25203D0C5CD58C
        yanjunshuyu;ihpq5978i9  0000D74C54DE5E48858C2733C0349C35F3DB5C8DA24750C4E5577AFBB4852923
        yanjunshuyu;a9dnfsqqzh  0000AB8D217DBA537799E89752F38E122FD64984493B532153CAADA87612F36F
        yanjunshuyu;fpprytycqb  00009AD4CBFF71969F827C56991C2AF4EC3FDE990EF9C6E08C033D48EE371820
        yanjunshuyu;au61t8ds3p  0000303E4A584DA1481A9CB7C5C35C0DA06F95EC49601FEFB55A2FACE5C4664B
        yanjunshuyu;ce4zwzcy9w  0000B428A723ED23C2372CC72D6AF124392E72231A32130A94CC823736957B5D
        yanjunshuyu;dpdm95ts5b  000005B8DF67045A82A6B1EC041CC864B9E135811817F83537AA0E065CDA1A3F
        yanjunshuyu;f9hgr4ch2t  000019A23803A4078BE34880D529B28CCA9AA92CDDE32235A2E2F900D2EF694F
        yanjunshuyu;eczrfwsos0  000090EE0FD2C14DFAB620171C1D73A5412524CA63781E65058CEC2C26AAF674
        yanjunshuyu;c3i3vhf4cv  0000AD9A59A5448D454C6F1AC585733FBCCC4B1698F9403D9930ABC88F9658B8
        yanjunshuyu;e45q3rxw2n  000094D57C1AF898469F23F50B8D0BE26DC69C23C91B3795C8D894FAF5C645F1
        yanjunshuyu;j7y3fj79ud  0000D17984E4D37A00387EA6794AAF1CCD8D9993A0123ED82D19D344AB931627
        yanjunshuyu;ehizki3n4n  000043F8C6ADA22D8FD1F0BDD494A45A1894E1F8284E9E9ADA601F226740A7F3
        yanjunshuyu;c46xpnhxcu  0000C2DDC77685DD1F5E03B4A55C19EB9E91EC3F385EFF85458F42C9A8EF1701
        yanjunshuyu;h7mf21bs3d  0000195594F81E524B20474A7F8BFC1DAB869E30C0A593F44774AFA90C92D1A8
        yanjunshuyu;fn3exedbta  000056177FC8E4DD673DF4F579BC0BCF340509C5957C28385AE6A02BEA67DDA5
        yanjunshuyu;irbsr5dfzq  00000EED186BD0F94FFC3F79047DC2B33B60BCB0D620D3B877A81072E255F98F
        yanjunshuyu;fa8fp6zydd  0000F9097A8AA4C19F6F025E417F5600B677B3C69C4F84095BEAA63A706C69C6
        yanjunshuyu;hlv0310kvy  0000DA98EA8B050B5707842CA9C109C6EC35CAC4883DD144FD750257191B5843
        yanjunshuyu;elgspy3ozp  00004340E568803078FB9CED44AE118DA5C17D881FE142CE04EC68A06E6A4AB8
        yanjunshuyu;bg9spc8fxz  0000FEAB605EA5C8D066EB23280E7A126F4930870843E342DF35EA4824142823
        yanjunshuyu;anpwuuiss2  0000E5A59E665649435354AD79D04C2B6906428DDC4AF8D546AE7F49264EC48B

##### problem 3
- The CUP information is: 1.6 GHz Intel Core i5 with 2 core 4 thread
- The Memory information is: 4 GB 1600 MHz DDR3
- The CPU time (User time) and real time is: 

        real    3m7.356s
        user    10m42.677s
- We can see that the ratio is above 3. 

##### problem 4
- yanjunshuyu;apaeiklcsh  0000000001A9FF7FEB0B83D0EB1826FFF5FC5714FB4DE97E6B9BC7AC55F58D8E
- yanjunshuyu;afaathsjpv  000000000213740A781B12CB052C8B9D4E4A5E60C2354AB0E8F75D551777EB1C
- yanjunshuyu;awadohcjoy  0000000008C484AC5130B9349CA42DDF38B05B2791296990ECA739F4D991DCC1
- yanjunshuyu;apaeiklcsh  0000000001A9FF7FEB0B83D0EB1826FFF5FC5714FB4DE97E6B9BC7AC55F58D8E
##### problem 5
- We run 1 worker in one machine and it could connect at most 12 machines together.
