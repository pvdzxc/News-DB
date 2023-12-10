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
