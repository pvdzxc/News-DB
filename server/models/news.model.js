const connection = require("../config/database");

async function getDocList(search, sort, order) {
  search = search || '';
  sort = sort || 'ArPublishDate';
  order = order || 'DESC';
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
    M.MLink
    FROM
        Article A
    JOIN 
        PublishedArticle PA ON A.ArticleID = PA.PublishedArticleID
    LEFT JOIN
        Attach AT ON A.ArticleID = AT.ArticleID
    LEFT JOIN
        Media M ON AT.MediaID = M.MediaID
      WHERE
        A.ArTitle LIKE ?
      ORDER BY
        PA.${sort} ${order};
    `, [`%${search}%`]);

    // Process the query result
    // console.log(result);
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

async function addNews(username, title,content,imgURL, genre){

}

module.exports = {
  getDocList,
  getNewsGenre
};
