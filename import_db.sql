CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  FOREIGN KEY (question_id) REFERENCES questions(id)
)



