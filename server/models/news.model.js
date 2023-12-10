const connection = require("../config/database");

async function getDocList(search, sort, order) {
  try {
    const [result] = await connection.execute(`CALL SearchArticles('${search}', '${sort}', '${order}')`)
    return result[0];
  } catch (error) {
    console.error('Error executing query:', error);
    throw error;
  }
}

async function getArticleById(articleID){
  try {
    const [result] = await connection.execute(`
    SELECT
    A.ArticleID,
    A.ArTitle,
    A.ArContent,
    PA.ArPublishDate,
    PA.ArTotalViews,
    PA.ArTotalLikes,
    PA.ArTotalShares,
    A.AuthorID,
    M.MLink,
    Au.AUsername
    FROM
        Article A
    JOIN 
        PublishedArticle PA ON A.ArticleID = PA.PublishedArticleID
    LEFT JOIN
        Attach AT ON A.ArticleID = AT.ArticleID
    LEFT JOIN
        Media M ON AT.MediaID = M.MediaID
	LEFT JOIN 
		Author Au ON A.AuthorID = Au.AuthorID
      WHERE
        A.ArticleID = ?
    `, [articleID]);

    // Process the query result
    //console.log(result);
    return result;
  } catch (error) {
    console.error('Error executing query:', error);
    throw error;
  }
}

async function getNewsGenre(){
  try {
    const [result] = await connection.execute(`
    SELECT * FROM genre
    `);

    // Process the query result
    // console.log(result);
    return result;
  } catch (error) {
    console.error('Error executing query:', error);
    throw error;
  }
}

async function getNewsTopic(){
  try {
    const [result] = await connection.execute(`
    SELECT * FROM topic
    `);

    // Process the query result
    // console.log(result);
    return result;
  } catch (error) {
    console.error('Error executing query:', error);
    throw error;
  }
}

async function addNews(username, title, content,imgURL, genre, topic){
  try {
    const [rows, fields] = await connection.execute('CALL ProcInsertArticle(?, ?, ?, ?, ?, ?)', [
      title,
      content,
      genre,
      topic,
      username,
      imgURL,
    ]);
    // rows will contain the result of the stored procedure
    console.log('Stored Procedure Result:', rows);
    return true;
  } catch (error) {
    console.error('Error executing query:', error);
    throw error;
  }
}

async function deleteNews(ArticleID){
  try {
    console.log(ArticleID);
    const [rows, fields] = await connection.execute('CALL ProcDeleteArticle(?)', [ArticleID]);
    // rows will contain the result of the stored procedure
    console.log('Stored Procedure Result:', rows);
    return true;
  } catch (error) {
    console.error('Error executing query:', error);
    throw error;
  }
}

module.exports = {
  getDocList,
  getNewsGenre,
  getNewsTopic,
  addNews,
  deleteNews,
  getArticleById
};
