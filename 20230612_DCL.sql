-- 20230612_DCL.sql
/******************************************
	 계정 성생 및 권한 부여&회수
     사용자 계정 생성
     CREATE USER 계정명@접속위치 IDENTIFIED BY 비밀번호;
     접속 위치
     컴퓨터 주소 : IP
     % : 어디서나 접근 가능
     localhost OR 127.0.0.1 : 현재 서버가 설치된 위치에서만 접근가능
*/

-- 사용자 계정 관리 table     --      mysql
USE mysql;
SELECT * FROM user;

CREATE USER user1@'localhost' IDENTIFIED BY '1234';

SELECT user, host FROM user;

SHOW GRANTS FOR user1@'localhost';

SHOW GRANTS FOR root@'localhost';

-- 계정 삭제
DROP user user1@'localhost';

SELECT user, host FROM user;

-- 권한 부여 및 권한 회수
CREATE USER 'pm'@'%' IDENTIFIED BY '1234';

-- 권한 부여
-- WITH GRANT OPTION 다른 계정에 권한을 부여할 수 있는 권한 
GRANT ALL ON *.* TO pm@'%' WITH GRANT OPTION;

SHOW GRANTS FOR pm@'%';

-- pm 계정의 모든 권한 회수 및 권한 부여 옵션 해제
-- 권한 부여 옵션 해제
REVOKE GRANT OPTION ON *.* FROM 'pm'@'%';

-- 부여된 모든 권한 회수 , workbench 오류 무시
REVOKE ALL ON *.* FROM 'pm'@'%';

SHOW GRANTS FOR 'pm'@'%';







