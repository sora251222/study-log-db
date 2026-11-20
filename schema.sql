-- =============================================================
-- 学習記録管理アプリ（study_log_app）スキーマ & サンプルデータ
--
-- 事前準備（データベースの作成。postgres データベースに接続して実行）:
--   CREATE DATABASE study_log_app ENCODING 'UTF8';
--
-- 実行方法:
--   psql -h localhost -U postgres -d study_log_app -f schema.sql
-- =============================================================

-- このファイルは UTF-8 で保存しているため、クライアントの文字コードを合わせる
SET client_encoding = 'UTF8';

BEGIN;

-- -------------------------------------------------------------
-- テーブル作成
-- 外部キーで参照される subjects を先に作成する
-- -------------------------------------------------------------

-- 学習科目
CREATE TABLE subjects (
  id   SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- 学習記録（1つの科目に複数の記録が紐づく 1対多）
CREATE TABLE study_logs (
  id         SERIAL PRIMARY KEY,
  studied_on DATE    NOT NULL,                       -- 学習日
  minutes    INTEGER NOT NULL,                       -- 学習時間（分）
  memo       TEXT,                                   -- メモ（任意）
  subject_id INTEGER NOT NULL REFERENCES subjects(id) -- 科目のid（外部キー）
);

-- -------------------------------------------------------------
-- サンプルデータ投入
-- -------------------------------------------------------------

INSERT INTO subjects (name) VALUES
  ('HTML'),
  ('CSS'),
  ('JavaScript');

INSERT INTO study_logs (studied_on, minutes, memo, subject_id) VALUES
  ('2026-11-16',  60, '基本タグと文書構造を学習',     (SELECT id FROM subjects WHERE name = 'HTML')),
  ('2026-11-17',  45, 'フォーム要素を練習',           (SELECT id FROM subjects WHERE name = 'HTML')),
  ('2026-11-18',  90, 'セレクタとボックスモデル',     (SELECT id FROM subjects WHERE name = 'CSS')),
  ('2026-11-19',  30, 'Flexboxでレイアウトを作成',    (SELECT id FROM subjects WHERE name = 'CSS')),
  ('2026-11-20', 120, '変数・条件分岐・ループの基礎', (SELECT id FROM subjects WHERE name = 'JavaScript'));

COMMIT;

-- -------------------------------------------------------------
-- 動作確認用：テーブルを結合して学習記録の一覧を取得
-- -------------------------------------------------------------
SELECT l.id, l.studied_on, s.name AS subject, l.minutes, l.memo
FROM study_logs l
INNER JOIN subjects s ON l.subject_id = s.id
ORDER BY l.studied_on;
