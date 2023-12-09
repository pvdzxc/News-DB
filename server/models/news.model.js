const connection = require("../config/database");

async function getDocList(search, sort, order) {
  search = search || '';
  sort = sort || 'ArPublishDate';
  order = order || 'DESC';

  console.log(sort)
  console.log(order)

  try {
    const [result] = await connection.execute(`
    SELECT
      ArticleID,
      ArTitle,
      ArContent,
      ArPublishDate,
      ArTotalViews,
      ArTotalLikes,
      ArTotalShares
    FROM
      Article
    JOIN 
      PublishedArticle ON ArticleID = PublishedArticleID
      WHERE
        ArTitle LIKE ?
      ORDER BY
        ${sort} ${order};
    `, [`%${search}%`]);

    // Process the query result
    // console.log(result);
    return result;
  } catch (error) {
    console.error('Error executing query:', error);
    throw error;
  }
}

module.exports = {
  getDocList,
};
