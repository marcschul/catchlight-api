const router = require('express').Router();

module.exports = db => {

  // Gets a particular conversation 
  router.get('/:id', async function(req, res) {
    const queryParams = [req.params.id];
    const query = "SELECT * FROM conversations WHERE conversations.id = $1;";
    try{
    const conversations = await db.query(query, queryParams);
    res.json(conversations.rows);
    } catch (err) {
      res.send(err.detail);
    }
  });

  //Creates a new conversation
  router.post('/', async function(req, res) {
    const queryParams = [req.body.media_id];
    const query = "INSERT INTO conversations (media_id) VALUES ($1) returning *";
    try {
    const conversation = await db.query(query, queryParams);
    res.json(conversation.rows);
   } catch (err) {
    res.send(err);
   }
  });

  // Modifies a particular conversation
  router.put('/:id', async function(req, res) {
    const queryParams = [req.body.media_id, req.params.id];
    const query = "UPDATE conversations SET media_id= $1 WHERE id = $2 returning *";
    try {
    const conversation = await db.query(query, queryParams);
    res.json(conversation.rows);
   } catch (err) {
    res.send(err);
   }
  });

  //Creates a new message
  router.post('/:id/messages', async function(req, res) {
    const { user_id, conversation_id, content } = req.body
    const queryParams = [user_id, conversation_id, content];
    const query = "INSERT INTO messages (user_id, conversation_id, content) VALUES ($1, $2, $3) returning *";
    try {
    const message = await db.query(query, queryParams);
    res.json(message.rows);
   } catch (err) {
    res.send(err);
   }
  });

  // Gets a particular message from a particular conversation
  router.get('/:conversation_id/messages/:msg_id', async function(req, res) {
    const queryParams = [req.params.msg_id, req.params.conversation_id];
    const query = "SELECT * FROM messages WHERE messages.id = $1 and messages.conversation_id = $2;";
    try{
    const message = await db.query(query, queryParams);
    res.json(message.rows);
    } catch (err) {
      res.send(err.detail);
    }
  });

  //Modifies a message from a particular conversation
  router.put('/:conversation_id/messages/:msg_id', async function(req, res) {
    const { user_id, conversation_id, content } = req.body
    const queryParams = [user_id, conversation_id, content, req.params.msg_id, req.params.conversation_id];
    const query = "UPDATE messages SET user_id= $1, conversation_id = $2, content = $3 WHERE id = $4 and messages.conversation_id = $5 returning *";
    try {
    const message = await db.query(query, queryParams);
    res.json(message.rows);
   } catch (err) {
    res.send(err);
   }
  });

  // Gets a conversation's participants
  router.get('/:id/participants/', async function(req, res) {
    const queryParams = [req.params.id];
    const query = "SELECT * FROM conversation_participants WHERE conversation_participants.conversation_id = $1";
    try {
    const conversation_participants = await db.query(query, queryParams);
    res.json(conversation_participants.rows);
   } catch (err) {
    res.send(err);
   }
  });

  //Modifies a conversation's participant, sets message waiting to false
  router.put('/:conversation_id/participants/:id', async function(req, res) {
    const queryParams = req.params.id;
    const query = "UPDATE conversation_participants SET message_waiting = false WHERE id = $1 returning *";
    try{
    const conversation = await db.query(query, queryParams);
    res.json(conversation)
    } catch (err) {
      res.send(err);
    }
  })
  
  return router;
};

