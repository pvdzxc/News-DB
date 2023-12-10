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

function addPostToDB(data){
    return "abc xyz";
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

async function addNews(req,res){
    
}


module.exports = {
    getNewsList: getNewsList,
    addPostToDB: addPostToDB,
    getNewsGenre: getNewsGenre,
}