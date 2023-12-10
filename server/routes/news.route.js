const express = require('express');

const newsController = require('../controllers/news.controller');

const router = express.Router();

router.get('/', newsController.getNewsList);

router.get('/news-genre', newsController.getNewsGenre)
router.get('/news-topic', newsController.getNewsTopic)
router.post('/createNews', newsController.createNews)
router.delete('/delete/:articleID', newsController.deleteNews)

//router.post('/addNews', newsController.addNews);

// router.post('/createPost', newsController.addPostToDB) //localhost:9000/api/news/createPost

//router.get('/products/:id', productsController.getProductDetails);

module.exports = router;