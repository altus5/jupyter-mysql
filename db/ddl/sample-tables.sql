CREATE TABLE m_company
(
  id            BIGINT UNSIGNED NOT NULL COMMENT 'ID',
  company_cd    VARCHAR(6)      NOT NULL COMMENT '会社コード',
  company_name  VARCHAR(100)    NOT NULL COMMENT '会社名',
  test_id       CHAR(3)         NOT NULL COMMENT 'テストID',
  version_no    INT UNSIGNED    NOT NULL COMMENT 'バージョンNo',
  created_at    DATETIME        NOT NULL COMMENT '作成日時',
  updated_at    DATETIME        NOT NULL COMMENT '更新日時',
  CONSTRAINT pk_m_company PRIMARY KEY (id ASC)
)
ENGINE=InnoDB
DEFAULT CHARSET utf8mb4
COMMENT = '会社マスタ'
;

ALTER TABLE m_company
 ADD CONSTRAINT uk_company_cd UNIQUE (company_cd ASC)
;

CREATE TABLE m_department
(
  id              BIGINT UNSIGNED NOT NULL COMMENT 'ID',
  department_cd   VARCHAR(6)      NOT NULL COMMENT '部署コード',
  department_name VARCHAR(100)    NOT NULL COMMENT '部署名',
  company_id      BIGINT UNSIGNED NOT NULL COMMENT '会社ID',
  version_no      INT UNSIGNED    NOT NULL COMMENT 'バージョンNo',
  created_at      DATETIME        NOT NULL COMMENT '作成日時',
  updated_at      DATETIME        NOT NULL COMMENT '更新日時',
  CONSTRAINT pk_m_department PRIMARY KEY (id ASC)
)
ENGINE=InnoDB
DEFAULT CHARSET utf8mb4
COMMENT = '部署マスタ'
;

ALTER TABLE m_department
 ADD CONSTRAINT uk_department_cd UNIQUE (department_cd ASC)
;
ALTER TABLE m_department
 ADD INDEX idx_company (company_id ASC)
;

CREATE TABLE m_user
(
  id              BIGINT UNSIGNED NOT NULL COMMENT 'ID',
  login_id        VARCHAR(20)     NOT NULL COMMENT 'ログインID',
  password        VARCHAR(100)    NOT NULL COMMENT 'パスワード',
  user_name       VARCHAR(100)    NOT NULL COMMENT 'ユーザー名',
  role_cd         VARCHAR(3)      NOT NULL COMMENT '権限コード',
  company_id      BIGINT UNSIGNED NOT NULL COMMENT '会社ID',
  version_no      INT UNSIGNED    NOT NULL COMMENT 'バージョンNo',
  created_at      DATETIME        NOT NULL COMMENT '作成日時',
  updated_at      DATETIME        NOT NULL COMMENT '更新日時',
  CONSTRAINT pk_m_user PRIMARY KEY (id ASC)
)
ENGINE=InnoDB
DEFAULT CHARSET utf8mb4
COMMENT = 'ユーザマスタ'
;

ALTER TABLE m_user
 ADD CONSTRAINT uk_login_id UNIQUE (login_id ASC)
;
ALTER TABLE m_user
 ADD INDEX idx_company (company_id ASC)
;

CREATE TABLE m_user_dept
(
  id              BIGINT UNSIGNED NOT NULL COMMENT 'ID',
  user_id         BIGINT UNSIGNED NOT NULL COMMENT 'ユーザーID',
  department_id   BIGINT UNSIGNED NOT NULL COMMENT '部署ID',
  CONSTRAINT pk_m_user_dept PRIMARY KEY (id ASC)
)
ENGINE=InnoDB
DEFAULT CHARSET utf8mb4
COMMENT = 'ユーザ所属部署'
;

ALTER TABLE m_user_dept
 ADD CONSTRAINT uk_user_dept UNIQUE (user_id ASC, department_id ASC)
;

/* Foreign Key */

/* [FK] 部署 → 会社 */
ALTER TABLE m_department
 ADD CONSTRAINT fk_dept_company
  FOREIGN KEY (company_id) REFERENCES m_company (id) ON DELETE Restrict ON UPDATE Restrict
;

/* [FK] ユーザー → 会社 */
ALTER TABLE m_user
 ADD CONSTRAINT fk_user_company
  FOREIGN KEY (company_id) REFERENCES m_company (id) ON DELETE Restrict ON UPDATE Restrict
;

/* [FK] ユーザー所属部署 → ユーザー */
ALTER TABLE m_user_dept
 ADD CONSTRAINT fk_user_dept_user
  FOREIGN KEY (user_id) REFERENCES m_user (id) ON DELETE Restrict ON UPDATE Restrict
;
/* [FK] ユーザー所属部署 → 部署 */
ALTER TABLE m_user_dept
 ADD CONSTRAINT fk_user_dept_dept
  FOREIGN KEY (department_id) REFERENCES m_department (id) ON DELETE Restrict ON UPDATE Restrict
;

