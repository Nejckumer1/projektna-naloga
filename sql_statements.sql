drop table if exists Users;

CREATE TABLE Users (
    userID INTEGER not NULL PRIMARY KEY AUTOINCREMENT,
    username varchar(255),
    password varchar(255),
    number_of_wins integer
);

INSERT into Users (username, password, number_of_wins) VALUES ('a','a',2);
INSERT into Users (username, password, number_of_wins) VALUES ('ime1','nepovem',7);
INSERT into Users (username, password, number_of_wins) VALUES ('ime2','nepovem',8);
INSERT into Users (username, password, number_of_wins) VALUES ('ime3','nepovem',6);
INSERT into Users (username, password, number_of_wins) VALUES ('ime4','test',8);
INSERT into Users (username, password, number_of_wins) VALUES ('ime5','test',9);
INSERT into Users (username, password, number_of_wins) VALUES ('test','test',3);
INSERT into Users (username, password, number_of_wins) VALUES ('asdf','asdf',3);