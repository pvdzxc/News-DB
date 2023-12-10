const path = require("path");
const news_model = require("../models/news.model")

async function getNewsList(req,res){
    const { search, sort, order } = req.query;
    try {
        const result = await news_model.getDocList(search, sort, order);
        if (result.length===0) return res.json({ status: 404 });
        return res.json({newsList: result })
    } catch (error) {
        console.log(error);
        return res.json({ status: 500 });
    }
}

async function getNewsById(req,res){
    const articleID = req.params.articleID;
    try {
        const result = await news_model.getArticleById(articleID);
        if (result.length===0) return res.json({ success: false, message: "Article is not existed" });
        return res.json({success: true, article: result[0] })
    } catch (error) {
        console.log(error);
        return res.json({ status: 500 });
    }
}

async function getCommentOfNews(req,res){
    const articleID = req.params.articleID;
    try {
        const result = await news_model.getCommnetOfArticle(articleID);
        if (result.length===0) return res.json({ success: true, length: 0, message: "Article doesn't have comment" });
        return res.json({success: true, length:result.length, commentList: result })
    } catch (error) {
        console.log(error);
        return res.json({ status: 500 });
    }
}

async function addCommentToArticle(req,res){
    const articleID = req.params.articleID;
    const content = req.body.content;
    const username = req.body.username;
    try {
        const result = await news_model.addCommentToArticle(articleID,content,username);
        if (!result) return res.json({ success: false, message: "Can't not add comment to article" });
        return res.json({success: true, message: "Add comment successfully" })
    } catch (error) {
        console.log(error);
        return res.json({ status: 500 });
    }
}

async function getNewsGenre(req,res){
    try {
        const result = await news_model.getNewsGenre();
        if (result.length===0) return res.json({ status: 404 });
        return res.json({genre: result })
    } catch (error) {
        console.log(error);
        return res.json({ status: 500 });
    }
}

async function getNewsTopic(req,res){
    try {
        const result = await news_model.getNewsTopic();
        if (result.length===0) return res.json({ status: 404 });
        return res.json({topic: result })
    } catch (error) {
        console.log(error);
        return res.json({ status: 500 });
    }
}

async function createNews(req,res){
    try {
        const { title, content, imgUrl, genre, topic } = req.body.data;
        const username = req.body.username || '';
        console.log(title, content, imgUrl, genre, topic,username)
        // Check for valid data
        if (!title || !content || !imgUrl || !genre || !topic || !username) {
          return res.json({ success: false, message: 'Invalid data. All fields are required.' });
        }
    
        // Call the addNews function
        await news_model.addNews(username, title, content, imgUrl, genre, topic);
        // Respond with success
        return res.status(200).json({ success: true, message: 'News added successfully.' });
    
      } catch (error) {
        console.error('Error adding news:', error);
        return res.json({ success: false, message: 'Internal server error.' });
      }
}

async function deleteNews(req,res){
    try {
        const articleID = req.params.articleID;
        const success = await news_model.deleteNews(articleID);
    
        if (success) {
          res.json({ success: true, message: 'News deleted successfully.' });
        } else {
          res.json({ success: false, message: 'Failed to delete news.' });
        }
    } catch (error) {
    console.error('Error deleting news:', error);
    res.json({ success: false, message: 'Internal server error.' });
    }
}


module.exports = {
    getNewsList: getNewsList,
    getNewsGenre: getNewsGenre,
    getNewsTopic: getNewsTopic,
    createNews: createNews,
    deleteNews: deleteNews,
    getNewsById: getNewsById,
    getCommentOfNews: getCommentOfNews,
    addCommentToArticle: addCommentToArticle
}