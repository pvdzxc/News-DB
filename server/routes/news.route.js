const express = require('express');

const newsController = require('../controllers/news.controller');

const router = express.Router();

router.get('/', newsController.getNewsList);

router.get('/news-genre', newsController.getNewsGenre)

//router.post('/addNews', newsController.addNews);

// router.post('/createPost', newsController.addPostToDB) //localhost:9000/api/news/createPost

//router.get('/products/:id', productsController.getProductDetails);

module.exports = router;