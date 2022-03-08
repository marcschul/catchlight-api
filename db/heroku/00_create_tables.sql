DROP TABLE IF EXISTS conversation_participants CASCADE;
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS conversations CASCADE;
DROP TABLE IF EXISTS media_streaming_services CASCADE;
DROP TABLE IF EXISTS streaming_subscriptions CASCADE;
DROP TABLE IF EXISTS streaming_services CASCADE;
DROP TABLE IF EXISTS friends CASCADE;
DROP TABLE IF EXISTS interactions CASCADE;
DROP TABLE IF EXISTS media CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  profile_picture VARCHAR(255),
  created DATE DEFAULT CURRENT_DATE NOT NULL,
  modified DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE media (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL UNIQUE,
  description TEXT NOT NULL,
  image TEXT, 
  imdb_id VARCHAR(255) NOT NULL
);

CREATE TABLE interactions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  media_id INTEGER REFERENCES media(id) ON DELETE CASCADE,
  rating VARCHAR(255) CHECK (rating IN ('like','dislike','meh', 'interest')) DEFAULT NULL,
  created DATE DEFAULT CURRENT_DATE NOT NULL,
  modified DATE DEFAULT CURRENT_DATE NOT NULL,
  UNIQUE(user_id, media_id)
);

CREATE TABLE friends (
  id SERIAL PRIMARY KEY,
  sending_user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  recieving_user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  friendship BOOLEAN DEFAULT FALSE,
  friendship_pending BOOLEAN DEFAULT TRUE,
  created DATE DEFAULT CURRENT_DATE,
  modified DATE DEFAULT CURRENT_DATE,
  UNIQUE(sending_user_id, recieving_user_id)
);

CREATE TABLE streaming_services (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE streaming_subscriptions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  streaming_service_id INTEGER REFERENCES streaming_services(id) ON DELETE CASCADE
);

CREATE TABLE media_streaming_services (
  id SERIAL PRIMARY KEY,
  media_id INTEGER REFERENCES media(id) ON DELETE CASCADE,
  streaming_service_id INTEGER REFERENCES streaming_services(id) ON DELETE CASCADE
);

CREATE TABLE conversations (
  id SERIAL PRIMARY KEY,
  media_id INTEGER REFERENCES media(id) ON DELETE CASCADE
);

CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  conversation_id INTEGER REFERENCES conversations(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  deleted BOOLEAN DEFAULT FALSE,
  created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE conversation_participants (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  conversation_id INTEGER REFERENCES conversations(id) ON DELETE CASCADE,
  message_waiting BOOLEAN DEFAULT true
);