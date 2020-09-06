SET pbomanager="C:\Program Files\PBO Manager v.1.4 beta\PBOConsole.exe"
SET repo="C:\Users\Kerkkoh\Documents\GitHub\RPFramework\"
SET armalocation="C:\Program Files (x86)\Steam\steamapps\common\Arma 3\"

SET reposerver="%repo:~1, -1%@RPF_Server\addons\rpf_server"
SET repomission="%repo:~1, -1%rpframework.altis"
SET pboserver="%armalocation:~1, -1%@RPF_Server\Addons\rpf_server.pbo"
SET pbomission="%armalocation:~1, -1%MPMissions\rpframework.altis.pbo"
SET bakserver="%armalocation:~1, -1%@RPF_Server\Addons\rpf_server.pbo.bak"
SET bakmission="%armalocation:~1, -1%MPMissions\rpframework.altis.pbo.bak"

%pbomanager% -pack %reposerver% %pboserver%
del /F %bakserver%
%pbomanager% -pack %repomission% %pbomission%
del /F %bakmission%